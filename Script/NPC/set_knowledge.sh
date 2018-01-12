#!/bin/bash
set -x;

cd $(dirname $0)

# 获取ID
IDS=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.id FROM KnowledgeBase t
WHERE t.stat='1';
" 2> /dev/null)

# 轮训并写入指定文件
for i in ${IDS}; do
	# 获取相关信息
	gname=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.gname FROM KnowledgeBase t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)
	key=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.key FROM KnowledgeBase t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)
	value=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
	SELECT t.value FROM KnowledgeBase t
	WHERE t.stat='1'
	AND t.id='$i';
	" 2> /dev/null)
    echo "${gname} # ${key} # ${value}"|tee -a .KnowledgeBase.txt;
done
mv .KnowledgeBase.txt KnowledgeBase.txt;
cd - > /dev/null;
exit;
