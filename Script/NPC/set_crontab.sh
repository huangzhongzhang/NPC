#!/bin/bash
set -x;

cd $(dirname $0)

# 轮训并写入指定文件
rm -f crontab.txt;

######## 获取 crontab 信息开始 ########
# 获取ID
IDS=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.id FROM Crontab t
WHERE t.stat='1';
" 2> /dev/null)

for i in ${IDS}; do
	# 获取相关信息
	time=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.time FROM Crontab t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)

	command=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.command FROM Crontab t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)

    echo "${time} ${command}"|tee -a crontab.txt;
done
######## 获取 crontab 信息结束 ########

######## 获取通知信息开始 ########
# 获取ID
IDS=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.id FROM Information t
WHERE t.stat='1';
" 2> /dev/null)

for i in ${IDS}; do
	# 获取相关信息
	time=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.time FROM Information t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)
	gname=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.gname FROM Information t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)
	message=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.message FROM Information t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)

    echo "${time} bash $(pwd)/qq_sms.sh \"${gname}\" \"${message}\""|tee -a crontab.txt;
done
######## 获取通知信息结束 ########
crontab crontab.txt;
exit;
