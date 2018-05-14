#!/usr/bin/env bash

process_string=$(ps -ef|grep login.pl|grep -v grep)

if [[ "$(tail -1 /tmp/nohup.out|grep '二维码'|wc -l)" == "1" ]];then
    echo "$process_string"|awk '{print $2}'|xargs kill -9;
    echo "$(date) Mojo-Webqq进程已杀死！"
    sleep 5
    cd /tmp
    rm -f mojo_webqq_*
    nohup perl $(echo ${process_string#*perl}) &
    echo "$(date) Mojo-Webqq进程已启动！"
fi