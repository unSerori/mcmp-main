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
    PROXY_REPOSITORY_URL=velocityのリポジトリhttpsリンク
    ```

## バックアップについて

デフォルトではbu_storageディレクトリにバックアップを取る  
ただ、これではストレージ自体が死んだとき（主に物理）に意味をなさない  
そのためusbメモリを差してマウントした  

### usbメモリマウント手順

すでに作業用PCでFAT32やNTFSにフォーマット済みのてい  
もしできてないなら大まかに以下のようにフォーマットする

```bash
# デバイス識別子の確認
sudo fdisk -l

# パーティションの作成
sudo fdisk /dev/デバイス識別子

# バーティションのフォーマット
sudo フォーマット形式 /dev/デバイス識別子

# フォーマット形式
# ext4: mkfs.ext4: linux専用
# FAT32: mkfs.vfat: windows, linux, mac利用可能
# exFAT: mkfs.exfat: FAT32よりもファイルサイズ制限が緩い
# NTFS: mkfs.ntfs: windows

```

```bash
# マウント先のディレクトリを作成
mkdir -p ./bu_strage

# uid, gidを確認
id mcmp

# デバイス識別子の確認
lsblk

# マウント 適宜uid, gid, dev/*, ~/*
sudo mount -o owner,uid=<uid>,gid=<gid> /dev/<デバイス識別子> /home/mcmp/mcmp-main/bu_storage

# 自動マウント
# デバイス識別子からuuidとtypeを取得
lsblk -f | grep <デバイス識別子>
# /etc/fstabに下記を追加
UUID=<uuid> /<マウント先ディレクトリ> <形式（FSTYPE）> defaults,uid=<uid>,gid=<gid> 0 0

# アンマウントする場合
sudo umount /dev/<デバイス識別子> /home/mcmp/mcmp-main/bu_storage
```

## サーバーの公開

ポート開放かtailscaleでシェアするのが楽だと感じた  
ただ、ポート開放だと施設のネットワーク構成よってはダメになるかもしれないからtailscaleでVPN建てて、デバイスをシェアして接続してもらうのがいいと思う

### tailscale導入のメリット

- VPNを作成するから、ポート開放しなくていい
- プライベートだから、ほかの人が入ってこれない
- ローカルのデバイス名でアクセスできるから、グローバルIPの変更があってもサーバー設定を更新しなくていい

### mainでのtailscale導入手順

1. tailscaleの垢登録: [登録サイト](https://login.tailscale.com/start)
2. 登録の後そのまま進めば各OSごとのインストール手順があるので従う
3. [管理コンソール](https://login.tailscale.com/admin/machines)でマシンのシェアリンクを取得してプレイヤーに共有

### 参加プレイヤーのtailscale導入手順

1. tailscaleの垢登録: [登録サイト](https://login.tailscale.com/start)
2. 登録の後そのまま進めば各OSごとのインストール手順があるので従う
3. main管理者から`share用のリンク`をもらってアクセス、適用する
4. [管理コンソール](https://login.tailscale.com/admin/machines)に追加されたmainサーバーのアドレスをコピーしてゲーム内のアドレス入力欄に入力して参加

## マイクラ鯖起動

初回起動

```bash
# SSHで入った後以下実行でビルド&再起動
bash update.sh
```

2回目以降

```bash
# SSHで入った後以下実行でコンテナーup
bash start.sh
```

## サーバー停止

```bash
# サーバーシャットダウン
bash stop.sh
```

## サーバー更新 TODO: 

### 新しいバージョンがリリースされた場合の更新方法

諸情報を更新してスクリプト実行

- .env内のMULTIPAPER_MASTER_URLを更新
- .env内のMULTIPAPER_SLAVE_URLを更新
- .env内のBASE_IMAGEを適切なJKDイメージに変更
- .env内のPROXY_REPOSITORY_URLを適切なプロキシサーバーリポジトリに変更:だたしこの項目が変わることはおそらくなく、想定していない

```bash
# 再ビルド&再起動
bash update.sh
```
