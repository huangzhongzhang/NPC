FROM centos:6
MAINTAINER HZZ <huangzz.xyz>
WORKDIR /root
ENV TZ=Asia/Shanghai
COPY SQL/DDL.sql ./
COPY Script/Mysql/start_mysql.sh ./
RUN \
    yum install -y wget && \
    rm /etc/yum.repos.d/* && \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo && \
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo && \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    yum install -y mysql-server mysql && \
    yum clean all;
VOLUME ["/etc/mysql", "/var/lib/mysql"]
EXPOSE 3306
ENTRYPOINT ["bash","start_mysql.sh"]