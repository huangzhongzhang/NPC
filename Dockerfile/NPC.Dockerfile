FROM centos:6
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
    MOJO_WEBQQ_VERSION="2.1.9"
COPY Script/NPC/* ./
COPY Centos-6.repo /etc/yum.repos.d/CentOS-Base.repo
RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    chmod 755 viewqr && \
    yum install -y epel-release && \
    yum install -y unzip wget perl-Crypt-OpenSSL-RSA perl-Crypt-OpenSSL-Bignum telnet gcc perl cpan curl crontabs openssl openssl-* mysql && \
    yum clean all && \
    wget -q https://github.com/sjdy521/Mojo-Webqq/archive/v$MOJO_WEBQQ_VERSION.zip && \
    unzip -qo v$MOJO_WEBQQ_VERSION.zip && \
    cd Mojo-Webqq-$MOJO_WEBQQ_VERSION && \
    curl http://share-10066126.cos.myqcloud.com/cpanm.pl|perl - App::cpanminus && \
    cpanm -nv Webqq::Encryption Mojo::IRC::Server::Chinese Mojo::SMTP::Client MIME::Lite Encode::Locale IO::Socket::SSL Digest::MD5 . && \
    cd .. && \
    rm -rf Mojo-Webqq-$MOJO_WEBQQ_VERSION Mojo-Webqq-$MOJO_WEBQQ_VERSION.zip && \
    echo "*/5 * * * * root cd /root;bash set_crontab.sh &> set_crontab_exec.log" > /etc/cron.d/setcrontab;
EXPOSE 5011
ENTRYPOINT ["bash","start_npc.sh"]