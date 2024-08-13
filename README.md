# mcmp-main

## 概要

MultiPaperを使って負荷分散マイクラサーバを立てる。  
MultiPaperはworldデータの保持とロードバランサーを行うMasterと実際のサーバ処理を行うslaveがある。これはメインで動作するサーバーリポジトリ。  

今回は[ラズパイ](./raspi.md)にmasterとロードバランサーと常時起動用のslaveをインストールし、自分がプレイヤーとして参加する際などwin10PCを起動している間は[sub](https://github.com/unSerori/mcmp-sub)として負荷分散に参加し負荷を受け持つ。  

## 環境構築

1. Linux上の環境を整える。[ラズパイでの環境構築](./raspi.md)
2. mcmp-project-masterをクローン

    ```bash
    # clone
    cd /home/mcmp
    git clone git@github.com:unSerori/mcmp-main.git
    ```

3. リモートvscodeに拡張機能を入れる

    ```bash
    # 拡張機能をインポート
    cat vscode-ext.txt | while read line; do code --install-extension $line; done
    ```

4. .envファイルをコピーまたは作成

    ```env:.env TODO: 
    BASE_IMAGE=jkdのベースイメージ。ここではeclipse-temurin:x.y.z_a-jdkを使用。
    MULTIPAPER_MASTER_URL=multipaper-master-x.y.z-all.jarのDLリンク
    MULTIPAPER_SLAVE_URL=multipaper-x.y.z-a.jarのDLリンク

    ```

## サーバーアップデート TODO: 

新しいバージョンがリリースされた場合の更新方法

- .env内のMULTIPAPER_MASTER_URLを更新
- .env内のMULTIPAPER_SLAVE_URLを更新
- .env内のBASE_IMAGEを適切なJKDイメージに変更

```bash
# 再ビルド&再起動
docker compose build && docker compose up -d

# (詳細なログはbuildコマンドに以下を追加)
--progress=plain
```

## マイクラ鯖起動

```bash
# SSHで入った後以下実行でコンテナーup
docker compose up -d

# サーバーシャットダウン
```
