# AWS SAM DynamoDB to SNS Lambda Function

Transit Gateway と Private Link を使った構成のハンズオンを含めたサンプルです。

![構成](images/image.png)

## 前提条件

以下がインストールされていること

- AWS CLI 
- jq 

## 準備

### リポジトリのクローン

```sh
git clone https://github.com/snakagawax/sample-tgw-privatelink
cd sample-tgw-privatelink
```

### リソースのデプロイ方法

リソースのデプロイまたは削除をするには、スクリプト cfn.sh を使用します。
`./cfn.sh [deploy|delete] [stack_number]` 

例.1 01-network.yml をデプロイするとき
```
$ ./cfn.sh deploy 01
-------------------------------------------
Deploying stack: network using 01-network.yml
-------------------------------------------

Waiting for changeset to be created..
Waiting for stack create/update to complete
Successfully created/updated stack - network
✅ Stack 'network' deployed successfully with status: CREATE_COMPLETE
```

例.2 04-privatelink-service.yml を削除するとき

```
$ ./cfn.sh delete 04
-------------------------------------------
Deleting stack: privatelink-service
-------------------------------------------
Initiated deletion of stack 'privatelink-service'.
Waiting for stack 'privatelink-service' to be deleted...
✅ Stack 'privatelink-service' deleted successfully.
```

例.3 すべてのテンプレートをデプロイするとき

```
$ ./cfn.sh deploy
```

例.4 すべてのスタックを削除するとき

```
$ ./cfn.sh delete
```

## ハンズオン

- [Transit Gateway の作成]

## 片付け

すべてのスタックを削除します

```
$ ./cfn.sh delete
```