FROM centos:7

MAINTAINER HZZ <huangzz.xyz>

WORKDIR /root

ENV TZ="Asia/Shanghai" \
    MOJO_WEBQQ_LOG_ENCODING="utf8" \
    SMTP_SERVER="smtp.qq.com" \
    SMTP_PORT="465" \
    SMTP_FROM="" \
    MAIL_TO="" \
    SMTP_USER="" \
    SMTP_PASSWD="" \
    QQ_PASSWD=""

COPY Script/NPC/* ./
COPY CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo

RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    chmod 755 viewqr && \
    yum install -y epel-release && \
    yum install -y perl-Crypt-OpenSSL-RSA perl-Crypt-OpenSSL-Bignum bc jq gcc perl cpan curl crontabs openssl openssl-* mysql && \
    curl http://share-10066126.cos.myqcloud.com/cpanm.pl|perl - App::cpanminus && \
    cpanm -vn Webqq::Encryption Mojo::IRC::Server::Chinese Mojo::SMTP::Client MIME::Lite Encode::Locale IO::Socket::SSL Mojo::Webqq && \
    echo "*/5 * * * * root cd /root;bash set_crontab.sh &> set_crontab_exec.log" > /etc/cron.d/setcrontab;

EXPOSE 5011

ENTRYPOINT ["bash","start_npc.sh"]