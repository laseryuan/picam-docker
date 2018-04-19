FROM resin/raspberry-pi-debian:stretch-20180228

RUN apt-get update && apt-get -y upgrade

# https://github.com/fatedier/frp/releases/download/v0.16.1/frp_0.16.1_linux_arm.tar.gz
ADD frp_0.16.1_linux_arm.tar.gz /tmp/
RUN mv /tmp/frp_0.16.1_linux_arm /root/frp

# RUN apt-get update && apt-get -y upgrade && \
  # apt-get install --no-install-recommends -y \
    # curl build-essential make gcc libpcre3 libpcre3-dev libpcre++-dev zlib1g-dev libbz2-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev libssl-dev libcurl4-openssl-dev

# # http://nginx.org/en/download.html
# ADD nginx-1.14.0.tar.gz /tmp/
# # https://github.com/arut/nginx-rtmp-module/releases
# ADD v1.2.1.tar.gz /tmp/

# RUN cd /tmp/nginx-1.14.0 && ./configure --add-module=/tmp/nginx-rtmp-module-1.2.1
# RUN cd /tmp/nginx-1.14.0 && make && make install

