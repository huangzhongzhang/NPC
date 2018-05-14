#!/usr/bin/env bash
set -ex;

# 构建镜像
cd ./Dockerfile/;
docker build -t hzz1989/npc_database -f Mysql.Dockerfile ../;
docker build -t hzz1989/npc -f NPC.Dockerfile ../;
docker image prune -f;
cd -;

# 上传镜像或运行容器
if [[ "$1" == "deploy" ]]; then
    docker push hzz1989/npc_database;
    docker push hzz1989/npc;
elif [[ "$1" == "run" ]]; then
    # 运行数据库容器
    docker run -d --name NPC_DATABASE \
    -p 3306:3306 \
    -v /etc/mysql:/etc/mysql \
    -v /var/lib/mysql:/var/lib/mysql \
    hzz1989/npc_database;

    # 运行NPC容器
    docker run -t --name NPC \
    -p 5011:5011 \
    --link NPC_DATABASE:database \
    -e QQ_ACCOUNT="2774984XXX" \
    -e QQ_PASSWD="ABCD" \
    hzz1989/npc;

    # 查看日志
    docker logs --tail 100 --follow NPC;
fi
