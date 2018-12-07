FROM daocloud.io/centos:6
MAINTAINER HZZ <huangzz.xyz>
WORKDIR /root
ENV TZ="Asia/Shanghai" \
    MOJO_WEBQQ_LOG_ENCODING="utf8" \
    QQ_ACCOUNT="" \
    QQ_PASSWD="" \
    SMTP_SERVER="smtp.qq.com" \
    SMTP_PORT="465" \
    SMTP_FROM="" \
    MAIL_TO="" \
    SMTP_USER="" \
    SMTP_PASSWD="" \
    MOJO_WEBQQ_VERSION="2.2.6"
COPY Script/NPC/* ./
RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    chmod 755 viewqr && \
    yum install -y epel-release wget && \
    yum install -y wget unzip perl-Crypt-OpenSSL-RSA perl-Crypt-OpenSSL-Bignum telnet bc jq gcc perl cpan curl crontabs openssl openssl-* mysql && \
    yum clean all && \
    wget -q https://github.com/sjdy521/Mojo-Webqq/archive/v$MOJO_WEBQQ_VERSION.zip && \
    unzip -qo v$MOJO_WEBQQ_VERSION.zip && \
    cd Mojo-Webqq-$MOJO_WEBQQ_VERSION && \
    curl http://share-10066126.cos.myqcloud.com/cpanm.pl|perl - App::cpanminus && \
    cpanm -nv Webqq::Encryption Mojo::IRC::Server::Chinese Mojo::SMTP::Client MIME::Lite Encode::Locale IO::Socket::SSL Digest::MD5 . && \
    cd .. && \
    rm -rf Mojo-Webqq-$MOJO_WEBQQ_VERSION v$MOJO_WEBQQ_VERSION.zip && \
    echo "*/5 * * * * root cd /root;bash set_crontab.sh &> set_crontab_exec.log" >> /etc/cron.d/setcrontab && \
    echo "*/5 * * * * root cd /root;bash -x set_knowledge.sh &> set_knowledge_exec.log" >> /etc/cron.d/setcrontab;
EXPOSE 5011
ENTRYPOINT ["bash","start_npc.sh"]
