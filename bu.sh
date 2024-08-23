#!/bin/bash

# setting variable
time=3 # s
msg="§7§mなるよじ"
header_msg_en="§a§n§lAutomatic announcement by §9§n§l§oMAIN-MASTER§r§a§n§l."
header_msg_jp="§9§n§l§oMAIN-MASTER§a§n§lによる自動アナウンス。"
bu_alart_msg_en="§3After §c"$time"§3 seconds, it will §6kick§3 in to initiate the §1backup§3 and associated §2reboot§3." 
bu_alart_msg_jp="§c"$time"§3秒後に§1バックアップ§3とそれに伴う§2再起動§3が始まるため§6キック§3されます。"
disconnection_msg_en="§cThe server will be automatically shut down and kicked shortly."
disconnection_msg_jp="§cサーバーは自動的にシャットダウンされ、まもなくキックされます。"

# shell log msg
echo "Start bu world data..."

# buフォルダ名を作成
bu_fol_datetime="world_bu_data_$(date +%Y%m%d%H%M%S)"

# 保存先ディレクトリを作成
mkdir -p "bu_storage/${bu_fol_datetime}"

# ゲームサーバー内のプレイヤーにmsgを送る
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${msg}"
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${header_msg_en}"
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${header_msg_jp}"
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${bu_alart_msg_en}"
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${bu_alart_msg_jp}"

# 切断前のmsg
sleep ${time} # 待機時間
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${disconnection_msg_en}"
docker exec -it mcmp-slave mcrcon -H localhost -P 25555 -p password "say ${disconnection_msg_jp}"
sleep 1

# サーバー停止
bash stop.sh

# copy
echo "Copying started..."
cp -r ./mcmp-master/world*/ ./bu_storage/${bu_fol_datetime}
echo "Copying completed."

# サーバー起動
bash start.sh
