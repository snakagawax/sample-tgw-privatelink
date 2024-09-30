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

![01-04](../images/01-04.png)

アタッチメントCを作成

![01-04-c](../images/01-04-c.png)

同じようにdを作成

![01-04-d](../images/01-04-d.png)

![01-04-n](../images/01-04-n.png)



### Transit Gateway ルートテーブルを作成

![05](../images/05.png)

![05-1](../images/05-1.png)

![05-2](../images/05-2.png)

### Transit Gateway ルートテーブル更新

![05-3](../images/05-3.png)

![05-4](../images/05-4.png)

![05-5](../images/05-5.png)

### Transit Gateway ルートテーブル関連付け

![06-01](../images/06-01.png)

![06-02](../images/06-02.png)

![06-03](../images/06-03.png)

![06-04](../images/06-04.png)

### VPC ルートテーブルを更新

![07-01](../images/07-01.png)

![07-02](../images/07-02.png)

![07-03](../images/07-03.png)

![07-04](../images/07-04.png)

### 疎通確認

EC2-c のセッションマネージャーからEC2-dのプライベートIPアドレスにcurlで接続し、疎通できることを確認する。

![07-05](../images/07-05.png)


## CloudFormation で Transit Gatewayを作りたいとき

```
./cfn.sh deploy 03 
```

## 片付け

```
./cfn.sh delete
```



