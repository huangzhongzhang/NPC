#!/bin/bash
set -x;

# 启动容器中的crontab和mysql
/etc/init.d/crond start;

cd /tmp
rm -f mojo_webqq_* nohup.out
QQ_PASSWD_MD5=$(echo -n "$QQ_PASSWD"|md5sum|awk '{print $1}')
nohup perl /root/login.pl $SMTP_SERVER $SMTP_PORT $SMTP_FROM $MAIL_TO $SMTP_USER $SMTP_PASSWD $QQ_PASSWD_MD5 &
sleep 10
/root/viewqr /tmp/mojo_webqq_qrcode_default.png
tail -f nohup.out