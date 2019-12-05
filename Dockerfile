FROM alpine:3.10.3
MAINTAINER Frank Zhang <zjufrankzhang@gmail.com>

ENV NGINX_VER 1.17.6

RUN apk add --update git openssl-dev pcre-dev zlib-dev wget build-base && \
    mkdir src && cd src && \
    wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz && \
    tar xzf nginx-${NGINX_VER}.tar.gz && \
    git clone https://github.com/cuber/ngx_http_google_filter_module && \
    git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module && \
    cd nginx-${NGINX_VER} && \
    ./configure --prefix=/opt/nginx \
        --with-http_ssl_module \
	    --with-http_v2_module \
        --add-dynamic-module=../ngx_http_google_filter_module \
        --add-module=../ngx_http_substitutions_filter_module && \
    make && make install && \
    apk del git build-base && \
    rm -rf /src && \
    rm -rf /var/cache/apk/*

#ADD nginx.conf /opt/nginx/conf/nginx.conf
#如果需要https支持则注释上一行并解注释下两行
#ADD nginx-https.conf /opt/nginx/conf/nginx.conf
ADD nginx-https-withpassword.conf /opt/nginx/conf/nginx.conf
ADD htpasswd /opt/nginx/conf/htpasswd
#ADD chained.pem /etc/ssl/certs/
#ADD domain.key /etc/ssl/private/
#ADD dhparam.pem /etc/ssl/certs/

EXPOSE 443
CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
