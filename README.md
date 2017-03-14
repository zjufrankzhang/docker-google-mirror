跑在 docker 里的 google 镜像
------

简单两步获得 Google 镜像，需要使用letsencrypt加密
示例使用ubuntu16.04系统命令，将所有的example.yourdormain.com替换为你的域名
因为需要使用letsencrypt自动配置证书，所以没有监听80端口，有需要的可以自行修改配置文件

第一步
------
安装letsencrypt，并手工生成dhparam
```
sudo apt-get install letsencrypt
letsencrypt certonly --standalone -d example.yourdormain.com
openssl dhparam 2048 -out /etc/letsencrypt/live/example.yourdormain.com/dhparam.pem
```
第二步
------
运行docker
```
docker pull frankzhang/docker-google-mirror
docker run -d -p 443:443/tcp --name google-mirror --restart=always -v /etc/letsencrypt/live/example.yourdormain.com/fullchain.pem:/etc/ssl/certs/fullchain.pem:ro -v /etc/letsencrypt/live/example.yourdormain.com/privkey.pem:/etc/ssl/private/privkey.pem:ro  -v /etc/letsencrypt/live/example.yourdormain.com/dhparam.pem:/etc/ssl/certs/dhparam.pem:ro google-mirror
```
也可以自行build docker container
------
注意提前准备好相应的证书文件
```
git clone https://github.com/zjufrankzhang/docker-google-mirror
cd docker-google-mirror
docker build -t google-mirror .
docker run -d -p 443:443 google-mirror
```

致谢
------

其实这只是强大的[Google Filter Module](https://github.com/cuber/ngx_http_google_filter_module)的一个容器而已啦
