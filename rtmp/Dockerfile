FROM resin/raspberry-pi-debian:stretch-20180228

RUN apt-get update && apt-get -y upgrade && \
  apt-get install --no-install-recommends -y \
    curl build-essential make gcc libpcre3 libpcre3-dev libpcre++-dev zlib1g-dev libbz2-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev libssl-dev libcurl4-openssl-dev

# http://nginx.org/en/download.html
ADD nginx-1.14.0.tar.gz /tmp/
# https://github.com/arut/nginx-rtmp-module/releases
ADD v1.2.1.tar.gz /tmp/

RUN cd /tmp/nginx-1.14.0 && ./configure --add-module=/tmp/nginx-rtmp-module-1.2.1
RUN cd /tmp/nginx-1.14.0 && make && make install

RUN apt-get update -qy && apt-get -qy install \
  build-essential git
# WORKDIR /root/
# RUN git clone https://github.com/FFmpeg/FFmpeg.git

# https://github.com/FFmpeg/FFmpeg/archive/n3.3.7.zip
ADD n3.3.7.tar.gz /root/
RUN mv /root/FFmpeg-n3.3.7 /root/FFmpeg
WORKDIR /root/FFmpeg
RUN apt-get install -qy libomxil-bellagio-dev

# Prepare FFmpeg building environment
# sudo tar -zcvf /home/pi/projects/picam/rtmp/lib/opt_vc.tar.gz /opt/vc
ADD ./lib/opt_vc.tar.gz /
RUN echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vmcs.conf
RUN ldconfig

RUN ./configure --arch=armel --target-os=linux --enable-mmal --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree
RUN make
RUN make install
