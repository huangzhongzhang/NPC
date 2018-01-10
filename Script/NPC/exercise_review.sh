#!/bin/bash
set -x;

yestoday=$(date -d '-1 day' +%Y-%m-%d)

# 发送的群名称
# 群名称不能带空格！
Gname="${1}"

message="练习回顾：${yestoday}"

for x in ${Gname}
do
    bash qq_sms.sh "${x}" "${message}";
    sleep 5;
done
