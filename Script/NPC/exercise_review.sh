#!/bin/bash
set -x;

yestoday=$(date -d '-1 day' +%Y-%m-%d)

# 发送的群名称
Gname=${1}

message="练习回顾：${yestoday}"

for x in ${Gname}; do
    ./qq_sms.sh "$x" "$message"
done
