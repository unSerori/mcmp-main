#!/bin/bash

# buスクリプトを定時時刻に設定するための設定値
cron_job="00 04 * * * bash $(pwd)/bu.sh"
# crontabにすでに同じジョブが設定されていないか確認
if ! crontab -l | grep -qF "$cron_job"; then # 固定文字列として扱い完全一致した行だけ出力を消して判定
    (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
fi

# いったん落として、
docker compose down
# ビルド&起動
docker compose up --build -d
