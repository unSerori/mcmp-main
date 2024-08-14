# base image
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# 作業ディレクトリの設定
WORKDIR /root/mcmp-slave

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y curl

# MultiPaperのdl
ARG MULTIPAPER_SLAVE_URL
RUN curl -o multipaper.jar ${MULTIPAPER_SLAVE_URL}

# スレーブのデフォルトポートの公開 Minecraftのデフォルトポートで、プロキシされたプレイヤーはここに接続される
EXPOSE 25566

# 起動時に鯖実行
CMD ["java", "-DmultipaperMasterAddress=mcmp-master-srv:35353", "-Xmx512M", "-Xms128M", "-jar", "multipaper.jar"]