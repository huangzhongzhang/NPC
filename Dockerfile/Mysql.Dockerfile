FROM centos:7

MAINTAINER HZZ <huangzz.xyz>

WORKDIR /root

ENV TZ=Asia/Shanghai

COPY SQL/DDL.sql /root/
COPY Script/Mysql/start_mysql.sh /root/
COPY CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo

RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    yum install -y mariadb-server mariadb;

VOLUME ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["bash","start_mysql.sh"]