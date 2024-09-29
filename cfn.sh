#!/bin/bash

# スクリプトの終了時にエラーが発生した場合に停止
set -e

# 使用方法の表示関数
usage() {
  echo "Usage:"
  echo "  $0 [deploy|delete] [stack_number]"
  echo ""
  echo "Examples:"
  echo "  $0 deploy           # 全てのスタックをデプロイ"
  echo "  $0 delete           # 全てのスタックを削除"
  echo "  $0 deploy 01        # 01-network.yml をデプロイ"
  echo "  $0 delete 02        # 02-ec2.yml を削除"
  exit 1
}

# 引数のチェック
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Error: Invalid number of arguments."
  usage
fi

ACTION=$1

# サポートされているアクションの確認
if [[ "$ACTION" != "deploy" && "$ACTION" != "delete" ]]; then
  echo "Error: Unsupported action '$ACTION'."
  usage
fi

# オプションのスタック番号を取得
STACK_NUMBER=$2

# CloudFormationテンプレートのディレクトリ
TEMPLATE_DIR="./cloudformation"

# スタックデプロイ用関数
deploy_stack() {
  local template_file=$1
  local stack_name=$2

  echo "-------------------------------------------"
  echo "Deploying stack: $stack_name using $template_file"
  echo "-------------------------------------------"

  # デプロイコマンドの実行
  aws cloudformation deploy \
    --template-file "$TEMPLATE_DIR/$template_file" \
    --stack-name "$stack_name" \
    --capabilities CAPABILITY_NAMED_IAM

  # スタックステータスの取得
  stack_status=$(aws cloudformation describe-stacks --stack-name "$stack_name" --query "Stacks[0].StackStatus" --output text)

  # スタックステータスの確認
  if [[ "$stack_status" == "CREATE_COMPLETE" || "$stack_status" == "UPDATE_COMPLETE" ]]; then
    echo "✅ Stack '$stack_name' deployed successfully with status: $stack_status"
  elif [[ "$stack_status" == "ROLLBACK_COMPLETE" || "$stack_status" == "ROLLBACK_FAILED" || "$stack_status" == "UPDATE_ROLLBACK_COMPLETE" || "$stack_status" == "UPDATE_ROLLBACK_FAILED" ]]; then
    echo "❌ Stack '$stack_name' deployment failed with status: $stack_status"
    exit 1
  else
    echo "⚠️  Stack '$stack_name' deployed with unexpected status: $stack_status"
  fi

  echo ""
}

# スタック削除用関数
delete_stack() {
  local stack_name=$1

  echo "-------------------------------------------"
  echo "Deleting stack: $stack_name"
  echo "-------------------------------------------"

  # 削除コマンドの実行
  aws cloudformation delete-stack \
    --stack-name "$stack_name"

  # 削除が開始されたことを通知
  echo "Initiated deletion of stack '$stack_name'."

  # スタックが削除されるまでポーリング
  echo "Waiting for stack '$stack_name' to be deleted..."

  aws cloudformation wait stack-delete-complete --stack-name "$stack_name"

  echo "✅ Stack '$stack_name' deleted successfully."
  echo ""
}

# テンプレートファイルのリスト取得
get_template_files() {
  ls "$TEMPLATE_DIR"/*.yml | sort
}

# テンプレートファイルのリスト取得（削除用、逆順）
get_template_files_reverse() {
  ls "$TEMPLATE_DIR"/*.yml | sort -r
}

# 特定のスタック番号からテンプレートファイルを取得
get_template_by_number() {
  local number=$1
  local files=( "$TEMPLATE_DIR"/"$number"-*.yml )
  
  if [ -e "${files[0]}" ]; then
    echo "${files[0]}"
  else
    echo ""
  fi
}

# メイン処理
main() {
  if [[ "$ACTION" == "deploy" ]]; then
    if [[ -n "$STACK_NUMBER" ]]; then
      # 特定のスタック番号をデプロイ
      template_path=$(get_template_by_number "$STACK_NUMBER")
      if [[ -z "$template_path" ]]; then
        echo "Error: No template file found for stack number '$STACK_NUMBER'."
        exit 1
      fi

      template_file=$(basename "$template_path")
      base_name="${template_file%.yml}"
      stack_name="${base_name#*-}"

      deploy_stack "$template_file" "$stack_name"
    else
      # 全てのスタックをデプロイ
      echo "🌟 Starting deployment of all CloudFormation stacks..."
      TEMPLATE_FILES=$(get_template_files)

      for template_path in $TEMPLATE_FILES; do
        template_file=$(basename "$template_path")
        base_name="${template_file%.yml}"
        stack_name="${base_name#*-}"

        deploy_stack "$template_file" "$stack_name"
      done

      echo "🎉 All specified CloudFormation stacks have been deployed successfully."
    fi
  elif [[ "$ACTION" == "delete" ]]; then
    if [[ -n "$STACK_NUMBER" ]]; then
      # 特定のスタック番号を削除
      template_path=$(get_template_by_number "$STACK_NUMBER")
      if [[ -z "$template_path" ]]; then
        echo "Error: No template file found for stack number '$STACK_NUMBER'."
        exit 1
      fi

      template_file=$(basename "$template_path")
      base_name="${template_file%.yml}"
      stack_name="${base_name#*-}"

      delete_stack "$stack_name"
    else
      # 全てのスタックを削除（逆順）
      echo "🗑️  Starting deletion of all CloudFormation stacks..."
      TEMPLATE_FILES=$(get_template_files_reverse)

      for template_path in $TEMPLATE_FILES; do
        template_file=$(basename "$template_path")
        base_name="${template_file%.yml}"
        stack_name="${base_name#*-}"

        delete_stack "$stack_name"
      done

      echo "🗑️  All specified CloudFormation stacks have been deleted successfully."
    fi
  fi
}

# スクリプトの実行
main