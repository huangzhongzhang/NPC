FROM centos:7.0.1406
MAINTAINER HZZ <huangzz.xyz>
WORKDIR /root
USER root
ENV TZ="Asia/Shanghai" \
    MOJO_WEBQQ_LOG_ENCODING="utf8" \
    QQ_ACCOUNT="" \
    QQ_PASSWD="" \
    SMTP_SERVER="smtp.qq.com" \
    SMTP_PORT="465" \
    SMTP_FROM="" \
    MAIL_TO="" \
    SMTP_USER="" \
    SMTP_PASSWD=""
COPY Script/NPC/* ./
COPY CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    chmod 755 viewqr && \
    yum install -y epel-release && \
    yum -y --nogpgcheck install \
    bc \
    jq \
    make \
    gcc \
    crontabs \
    mysql \
    unzip \
    wget \
    tar \
    perl \
    perl-App-cpanminus \
    perl-Crypt-OpenSSL-Bignum \
    perl-Crypt-OpenSSL-RSA \
    perl-Compress-Raw-Zlib \
    perl-IO-Compress-Gzip \
    perl-Digest-MD5 \
    perl-Digest-SHA \
    perl-Time-Piece \
    perl-Time-Seconds \
    perl-Time-HiRes \
    perl-IO-Socket-SSL \
    perl-Encode-Locale \
    perl-Term-ANSIColor && \
    yum clean all && \
    cpanm -vn Mojo::SMTP::Client Mojo::IRC::Server::Chinese MIME::Lite Test::More Webqq::Encryption Mojolicious && \
    wget -q https://github.com/sjdy521/Mojo-Webqq/archive/master.zip -OMojo-Webqq.zip \
    && unzip -qo Mojo-Webqq.zip \
    && cd Mojo-Webqq-master \
    && cpanm . \
    && cd .. \
    && rm -rf Mojo-Webqq-master Mojo-Webqq.zip \
    && echo "*/5 * * * * root cd /root;bash set_crontab.sh &> set_crontab_exec.log" > /etc/cron.d/setcrontab;
EXPOSE 5011
ENTRYPOINT ["bash","start_npc.sh"]