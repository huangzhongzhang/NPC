#!/bin/bash
set -ex;

# 启动容器中的mysql
/etc/init.d/mysqld start;
# 配置mysql初始数据库
mysql --default-character-set=utf8 -e "source DDL.sql;";
mysql --default-character-set=utf8 -e "grant all privileges on NPC.* to 'npc'@'%' identified by 'QXCTyPzWEa5rBDs2' WITH GRANT OPTION;";
mysql --default-character-set=utf8 -e "grant all privileges on NPC.* to 'npc'@'localhost' identified by 'QXCTyPzWEa5rBDs2' WITH GRANT OPTION;";
mysql -u npc -pQXCTyPzWEa5rBDs2 -D NPC --default-character-set=utf8 -e "show tables;"
/etc/init.d/mysqld stop;

/usr/bin/mysqld_safe;