# base image
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# 作業ディレクトリの設定
WORKDIR /root/velocity

# 必要なパッケージのインストール
RUN apt-get update \
    && apt-get install -y git \
    && apt-get install avahi-utils -y

# velocityのDLとビルド
ARG PROXY_REPOSITORY_URL
RUN git clone ${PROXY_REPOSITORY_URL} \
    && cd Velocity \
    && VERSION=$(grep '^version=' gradle.properties | cut -d'=' -f2) \
    && echo ${VERSION} >> hoge.txt \
    && ./gradlew build \
    && cp ./proxy/build/libs/velocity-proxy-${VERSION}-all.jar /root/velocity/velocity.jar

# プロキシのデフォルトポートの公開 ここにプレイヤーが接続しプロキシされる
EXPOSE 25565

# 起動コマンド
CMD [ "java", "-Xmx512M", "-Xms512M", "-jar", "velocity.jar" ]
