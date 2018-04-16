FROM resin/raspberry-pi-debian:stretch-20180228

RUN apt-get update && apt-get -y upgrade && \
  apt-get install --no-install-recommends -y \
    libharfbuzz0b libfontconfig1
RUN apt-get install --no-install-recommends -y wget

COPY make_dirs.sh /home/pi/make_dirs.sh
COPY install.sh /home/pi/install.sh

WORKDIR /home/pi/

RUN cd /home/pi/ && ./make_dirs.sh
RUN cd /home/pi/ && ./install.sh
