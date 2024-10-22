## はじめに

このハンズオンでは Transit Gateway を作成して、EC2 間で疎通できることを確認します。

![](../images/01-handson-goal.png)

## 手順

### セットアップ

ネットワークリソースをデプロイします。

```
./cfn.sh deploy 01
```

EC2 をデプロイします。

```
./cfn.sh deploy 02
```

デプロイが完成したら以下の構成になります。

![](../images/01-handson-setup.png)

### Transit Gateway を作成

マネージメントコンソール > VPC > Transit Gateway から作成します。

![01-01](../images/01-01.png)

デフォルトのルートテーブルの関連付けと伝搬を外します。

![01-02-2](../images/01-02-2.png)

![01-03](../images/01-03.png)

### Transit Gateway アタッチメントを作成

左ペインから Transit Gateway アタッチメント選択し、[Transit Gateway アタッチメントを作成]をクリックします。

![01-04](../images/01-04.png)

vpc-c の Transit Gateway アタッチメントを作成します。VPC ID で vpc-c を選択します。

![01-04-c](../images/01-04-c.png)

同じように vpc-d の Transit Gateway アタッチメントを作成します。

![01-04-d](../images/01-04-d.png)

作成したら以下の通りに表示されます。Transit Gateway を作成時にデフォルトルートテーブルの関連付けを行っていないため、関連付けルートテーブル ID が空であることを確認します。

![01-04-n](../images/01-04-n.png)

### Transit Gateway ルートテーブルを作成

左ペインから Transit Gateway ルートテーブルを選択し、[Transit Gateway ルートテーブルを作成]をクリックします。

![05](../images/05.png)

アタッチメント C と D 用にそれぞれ作成します。

![05-1](../images/05-1.png)

![05-2](../images/05-2.png)

### Transit Gateway ルートテーブル更新

作成したルートテーブルにルート情報を設定します。
Transit Gateway ルートテーブル C（tgw-rt-c）を選択した状態で、タブ[ルート]を選択し、[ルートを作成]をクリックします。

![05-3](../images/05-3.png)

宛先の Cidr として vpc-d の Cidr（ここでは 10.3.0.0/16）を入力、アタッチメントに tgw-attachmentd-d を選択し、静的ルートを作成します。

![05-4](../images/05-4.png)

続いて同じように Transit Gateway ルートテーブル D（tgw-rt-d）のルートを設定します。
宛先の Cidr として vpc-c の Cidr（ここでは 172.16.0.0/24）を入力、アタッチメントに tgw-attachmentd-c を選択し、静的ルートを作成します。

![05-5](../images/05-5.png)

### Transit Gateway ルートテーブル関連付け

作成した Transit Gateway ルートテーブルをアタッチメントに関連付けます。
Transit Gateway ルートテーブル C（tgw-rt-c）を選択した状態で、タブ[関連付け]を選択し、[関連付けを作成]をクリックします。

![06-01](../images/06-01.png)

Transit Gateway アタッチメント C（tgw-attachment-c）を選択して、関連付けを作成します。

![06-02](../images/06-02.png)

同じ用に Transit Gateway アタッチメント D（tgw-attachment-d）を選択して、関連付けを作成します。

![06-03](../images/06-03.png)

作成すると、関連付けのルートテーブル ID にルートテーブル情報が入っていることを確認できます。
![06-04](../images/06-04.png)

### VPC ルートテーブルを更新

最後に VPC のルートテーブルを更新します。
左ペインから仮想プライベートクラウドのルートテーブルを開きます。
vpc-c のルートテーブル（demo-rtb-c）を選択し、タブ[ルート]を開きます。

![07-01](../images/07-01.png)

送信先に VPC-d の Cidr `10.3.0.0/16`、ターゲットに tgw-attachment-c を選択します。

![07-02](../images/07-02.png)

![07-03](../images/07-03.png)

vpc-d のルートテーブルにも同じように設定します。
送信先に VPC-c の Cidr `172.16.0.0/24`、ターゲットに tgw-attachment-d を選択します。

![07-04](../images/07-04.png)

### 疎通確認

EC2-c のセッションマネージャーから EC2-d のプライベート IP アドレスに curl で接続し、疎通できることを確認します。

![07-05](../images/07-05.png)


## CloudFormation で Transit Gateway と周辺リソースを作りたいとき

```
./cfn.sh deploy 03 
```

## 片付け

```
./cfn.sh delete
```



