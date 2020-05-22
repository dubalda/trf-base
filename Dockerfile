# LICENSE UPL 1.0
#
# Copyright (c) 2014-2015 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
#
# Dockerfile template for Oracle Instant Client
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ==================================
#
# From http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#  Download the following RPMs:
#    - oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
#    - oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
#    - oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm
#    - oracle-instantclient12.2-jdbc-12.2.0.1.0-1.x86_64.rpm
#    - oracle-instantclient12.2-tools-12.2.0.1.0-1.x86_64.rpm
#
#  And this one:
#    - jdk-8u211-linux-x64.rpm
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t oracle/instantclient:12.2.0.1 .
#
#
FROM oraclelinux:7-slim

ADD oracle-instantclient*.rpm* /tmp/
ADD jdk-8u211-linux-x64.rpm* /tmp/

RUN  pwd && \
     whoami && \
     ls -lh /tmp/ && \
     cat /tmp/jdk-8u211-linux-x64.rpm.parta* > /tmp/jdk-8u211-linux-x64.rpm && \
     rm /tmp/jdk-8u211-linux-x64.rpm.parta* && \
     cat /tmp/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm.parta* > /tmp/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
     rm /tmp/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm.parta* && \
     ls -lh && \
     yum -y install /tmp/oracle-instantclient*.rpm && \
     rm -rf /var/cache/yum && \
     rm -f /tmp/oracle-instantclient*.rpm && \
     echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient12.2.conf && \
     ldconfig && \
     yum -y install /tmp/jdk-8u211-linux-x64.rpm && \
     rm -rf /var/cache/yum && \
     rm -f /tmp/jdk-8u211-linux-x64.rpm && \
     echo  $'\n\
[nginx]\n\
name=nginx repo\n\
baseurl=http://nginx.org/packages/rhel/7/\$basearch/\n\
gpgcheck=0\n\
enabled=1\n'\
     > /etc/yum.repos.d/nginx.repo && \
     cat /etc/yum.repos.d/nginx.repo && \
     yum -y install mc curl vi nginx gettext cifs-utils mailx && \
     rm -rf /var/cache/yum && \
     ls /etc/ && \
     ls /etc/nginx/ && \
     sed -i 's/usr\/share\/nginx\/html/VTBTARIFF; autoindex on/' /etc/nginx/conf.d/default.conf && \
     cat /etc/nginx/conf.d/default.conf && \
     mkdir /VTBTARIFF

ENV PATH=$PATH:/usr/lib/oracle/12.2/client64/bin

CMD ["nginx", "-g", "daemon off;"]

