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
    # 处理 message 格式
    message=$(echo -e "${2}"|od -t x1 -A n -v -w10000 | tr " " %)
    # 发送信息
    api_url="http://$API_ADDR:$API_PORT/openqq/send_group_message?name=${Gname}&content=${message}&async=1"
    set -x
    curl $api_url
    set +x
else
    echo -e "\nOPEN-QQ服务未启动，跳过信息发送！\n"
fi
