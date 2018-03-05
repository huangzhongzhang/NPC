FROM centos:6
MAINTAINER HZZ <huangzz.xyz>
WORKDIR /root
ENV TZ=Asia/Shanghai
COPY SQL/DDL.sql ./
COPY Script/Mysql/start_mysql.sh ./
COPY Centos-6.repo /etc/yum.repos.d/CentOS-Base.repo
RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    yum install -y mysql-server mysql;
VOLUME ["/etc/mysql", "/var/lib/mysql"]
EXPOSE 3306
ENTRYPOINT ["bash","start_mysql.sh"]