# base image
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# 作業ディレクトリの設定
WORKDIR /root/mc-server

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y curl

# MultiPaperのdl
ARG MULTIPAPER_MASTER_URL
RUN curl -o multipaper-master.jar ${MULTIPAPER_MASTER_URL}

# マスターのデフォルトポートの公開 ここにスレーブが接続
EXPOSE 35353
# プロキシのデフォルトポートの公開 ここにプレイヤーが接続しプロキシされる
EXPOSE 25565

# 起動時に鯖実行
CMD ["java", "-Xmx512M", "-Xms128M", "-jar", "multipaper-master.jar", "35353", "25565"]