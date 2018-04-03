#!/usr/bin/env bash


# login.pl中定义的host和port
API_ADDR=127.0.0.1
API_PORT=5011

# 获取AIP信息
group_info=$(curl -s http://${API_ADDR}:${API_PORT}/openqq/get_group_info)

# 统计总共加入了多少个群
classes_count=$(echo ${group_info}|jq '.[]|{name}'|awk '{print $2}'|tr -d '"'|grep -v "^$"|wc -l)

for i in {0..$[${classes_count}-1]}
do
    # 获取组名
    class_name=$(echo ${group_info}|jq ".[${i}]|{name}"|awk '{print $2}'|tr -d '"'|grep -v "^$")

    # 获取组成员名称
    classmates=$(echo ${group_info}|jq ".[${i}]|.member|.[]|{card}"|awk '{print $2}'|tr -d '"'|grep -v "^$")

    # 获取最后一位童鞋的号数和名字
    last_classmates=$(echo "$classmates"|egrep "[[:digit:]]*组[[:digit:]]*号"|sort|tail -1)

    # 插入 Knowledge 表并刷新数据。
    mysql -h database -D NPC --user=npc --password="QXCTyPzWEa5rBDs2" --default-character-set=utf8 -s -e "
    INSERT REPLACE INTO KnowledgeBase (gname,\`key\`,value) VALUES ('${class_name}','学生编号','当前最后一位同学的编号为：${last_classmates}');
    COMMIT;
    " 2> /dev/null
done