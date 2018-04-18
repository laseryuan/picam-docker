FROM resin/raspberry-pi-debian:stretch-20180228

RUN apt-get update && apt-get -y upgrade && \
  apt-get install --no-install-recommends -y \
    libharfbuzz0b libfontconfig1
RUN apt-get install --no-install-recommends -y wget

RUN apt-get install --no-install-recommends -y \
      libraspberrypi0 `# Solve libbrcmGLESv2.so dependency issue` \
      libasound2-dev libssl-dev `# Solve libasound dependency issue`

COPY install.sh /home/pi/install.sh
RUN cd /home/pi/ && ./install.sh

WORKDIR /root/picam
