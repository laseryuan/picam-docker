FROM lasery/ffmpeg as ffmpeg

# Update shared libraries for ffmpeg
RUN mkdir -p /usr/local/lib/ffmpeg
RUN ldd `which ffmpeg` | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /usr/local/lib/ffmpeg/

FROM balenalib/raspberry-pi-debian:stretch-20200405 AS nginx

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get -y update && apt-get install --no-install-recommends -y \
    curl build-essential make gcc libpcre3 libpcre3-dev libpcre++-dev zlib1g-dev libbz2-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev libssl-dev libcurl4-openssl-dev

# http://nginx.org/en/download.html
ADD rtmp/nginx-1.14.0.tar.gz /tmp/
# https://github.com/arut/nginx-rtmp-module/releases
ADD rtmp/v1.2.1.tar.gz /tmp/

RUN cd /tmp/nginx-1.14.0 && ./configure --add-module=/tmp/nginx-rtmp-module-1.2.1
RUN cd /tmp/nginx-1.14.0 && make && make install

# Archive all shared libraries for nginx
RUN mkdir -p /usr/local/lib/nginx
RUN ldd /usr/local/nginx/sbin/nginx | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /usr/local/lib/nginx/

# Final stage
FROM balenalib/raspberry-pi-debian:stretch-20200405

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

COPY --from=ffmpeg /usr/local/bin/ffmpeg /usr/local/bin/
COPY --from=ffmpeg /usr/local/lib/ffmpeg /usr/local/lib/

COPY --from=nginx /usr/local/nginx /usr/local/nginx
COPY --from=nginx /usr/local/lib/nginx /usr/local/lib/

RUN ldconfig # fix constantly exit ffmpeg

# Sanity Test
RUN /usr/local/nginx/sbin/nginx -h && ffmpeg -version
