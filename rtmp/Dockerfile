FROM lasery/ffmpeg as ffmpeg

# Update shared libraries for ffmpeg
RUN mkdir -p /usr/local/lib/ffmpeg
RUN ldd `which ffmpeg` | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /usr/local/lib/ffmpeg/

FROM lasery/nginx:rtmp-1.2.1 AS nginx

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
