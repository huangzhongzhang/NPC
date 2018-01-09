#!/usr/bin/env bash
set -x;

# 获取未插入 Knowledge 表的 id
ids=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
SELECT t.id
FROM NPC.LinuxQuestion t
WHERE t.stat = '0';
" 2> /dev/null)

for i in $ids
do
    # 获取日期
    today=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
    SELECT t.date
    FROM NPC.LinuxQuestion t
    WHERE t.id = '${i}';
    " 2> /dev/null)

    # 获取问题
    question=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
    SELECT t.question
    FROM NPC.LinuxQuestion t
    WHERE t.id = '${i}';
    " 2> /dev/null)

    # 获取答案
    answer=$(mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
    SELECT t.answer
    FROM NPC.LinuxQuestion t
    WHERE t.id = '${i}';
    " 2> /dev/null)

    # 插入 Knowledge 表并刷新数据。
    mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
    INSERT INTO KnowledgeBase_51CTO (gname,\`key\`,value) VALUES ('__全局__','练习回顾：${today}','每日一练（${today}）：\n问题：\n${question}\n\n答案：\n${answer}');
    UPDATE NPC.LinuxQuestion t
    SET t.stat='1'
    WHERE t.id = '${i}';
    COMMIT;
    " 2> /dev/null
done