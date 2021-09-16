FROM centos:7
MAINTAINER PomanTeng <1807479153@qq.com> <WeChat 1807479153>
#拷贝本地源到镜像中
COPY CentOS-Base.repo  /etc/yum.repos.d/
#安装基础管理命令
RUN yum install -y gcc gcc-c++ make \
    openssl-devel pcre-devel gd-devel \
    iproute net-tools wget && \
    yum clean all && \
    rm -rf /var/cache/yum/*
#下载源码nginx包并编译安装
RUN wget http://nginx.org/download/nginx-1.15.5.tar.gz && \
    tar zxf nginx-1.15.5.tar.gz && \
    cd nginx-1.15.5 &&\
    ./configure --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module && \
    make -j 4 && make install && \
    rm -rf /usr/local/nginx/html/* && \
    echo "ok" >> /usr/local/nginx/html/status.html && \
    cd / && rm -rf nginx-1.12.2* && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#声明环境变量
ENV PATH $PATH:/usr/local/nginx/sbin
#拷贝项目nginx配置
#COPY nginx.conf /usr/local/nginx/conf/nginx.conf
#设置工作目录
WORKDIR /usr/local/nginx
#指定端口
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
