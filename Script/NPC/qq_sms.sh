#!/usr/bin/env bash
# qq群信息发送

cd $(dirname $0)
echo -e "\n$(date)\n";

# 发送的群名称
Gname=${1}

# login.pl中定义的host和port
API_ADDR=127.0.0.1
API_PORT=5011

if echo 'a'|telnet -e a $API_ADDR $API_PORT &> /dev/null
then
    # 处理下编码，用于合并告警内容的标题和内容，即$2和$3
    message=$(echo -e "${2}"|od -t x1 -A n -v -w10000 | tr " " %)

    # 获取GID
    GID=$(curl -s "http://$API_ADDR:$API_PORT/openqq/get_group_basic_info"|jq '.[]|{name,id}'|tr -d "{,}\""|grep -A 1 -B 1 "$Gname"|grep -v "$Gname"|awk '{print $2}'|bc)

    # 发送信息
    api_url="http://$API_ADDR:$API_PORT/openqq/send_group_message?id=$GID&content=$message"
    set -x
    curl $api_url
    set +x
else
    echo "\nOPEN-QQ服务未启动，跳过信息发送！\n"
fi
