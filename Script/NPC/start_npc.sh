#!/bin/bash
set -x;

# 启动容器中的crontab
/etc/init.d/crond start;

# 转换密码格式
QQ_PASSWD_MD5=$(echo -n "$QQ_PASSWD"|md5sum|awk '{print $1}')

# 初始化重启次数
restart_count=0

# 设定重启次数
restart_total=10

while true
do
    cd /root
    process_string=$(ps -ef|grep login.pl|grep -v grep)
    if [[ -z "$process_string" ]]; then
        set -x
        rm -rf /tmp/mojo_webqq_*
        nohup perl login.pl $QQ_ACCOUNT $QQ_PASSWD_MD5 $SMTP_SERVER $SMTP_PORT $SMTP_FROM $MAIL_TO $SMTP_USER $SMTP_PASSWD &
        set +x
        echo "$(date) Mojo-Webqq进程已启动！"
        sleep 10
        ./viewqr /tmp/mojo_webqq_qrcode_$QQ_ACCOUNT.png
    fi
    for (( i=300;i>=1;i-- ))
    do
        echo "$i"
        sleep 1
    done
    if [[ $(tail -10 /tmp/nohup.out|grep '二维码'|wc -l) -gt 1 && $restart_count -lt $restart_total ]];then
        set -x
        echo "$process_string"|awk '{print $2}'|xargs kill -9;
        echo "$(date) Mojo-Webqq进程已杀死！"
        sleep 5
        nohup perl login.pl $QQ_ACCOUNT $QQ_PASSWD_MD5 $SMTP_SERVER $SMTP_PORT $SMTP_FROM $MAIL_TO $SMTP_USER $SMTP_PASSWD &
        set +x
        echo "$(date) Mojo-Webqq进程已启动！"
        sleep 10
        ./viewqr /tmp/mojo_webqq_qrcode_$QQ_ACCOUNT.png
        let restart_count++
        echo "$(date) 第 $restart_count 次重启完成！"
        echo -e "\n"
    else
        echo "超出重启次数限制，退出程序！"
        exit 1;
    fi
done