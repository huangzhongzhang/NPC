#!/bin/bash
set -x;

# 设定字符编码
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 发送的群名称
Gname="${1}"

# 你login.pl中定义的host和port
API_ADDR="127.0.0.1:5011"

# 需要提取的类型（问题还是答案）
ask_type="${2}"

# 获取时间
today="$(date +%Y-%m-%d)"

# 获取问题和答案
question=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.question
FROM NPC.LinuxQuestion t
WHERE t.date = '${today}';
" 2> /dev/null)
answer=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.answer
FROM NPC.LinuxQuestion t
WHERE t.date = '${today}';
" 2> /dev/null)
status=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.stat
FROM NPC.LinuxQuestion t
WHERE t.date = '${today}';
" 2> /dev/null)

# 格式化信息
if [[ "${ask_type}" == "question" ]]
then
  message="每日一练（${today}）：\n问题：\n${question}"
elif [[ "${ask_type}" == "answer" ]]
then
  message="每日一练（${today}）：\n答案：\n${answer}"
fi

# 如果未找到，则输出指定信息
if [[ "${status}" == "" ]]; then
  message="今日练习未设置!"
fi

bash qq_sms.sh "${Gname}" "$message"

exit;
