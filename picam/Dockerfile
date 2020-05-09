FROM lasery/picam

USER root
RUN apt-get update -qy && apt-get install -qy --no-install-recommends \
      netcat

USER picam
COPY --chown=picam picam/hooks.sh /home/picam/hooks.sh

