#!/bin/sh

# Replace ~/picam with your picam directory
cd /root/picam || exit 1

# Wait for rtmp service
sleep 30

# Start picam
./picam --time --width 640 --height 480 --videobitrate 500000 --fps 20 --noaudio --tcpout tcp://rtmp:8181 &
sleep 30

# Stop recording on Ctrl-C
trap on_sigint INT
on_sigint() {
  echo "Stop recording"
  touch hooks/stop_record
  exit 0
}

# Do forever
while :
do
  echo "Start recording"
  touch hooks/start_record || exit 1

  echo "Keep recording for ten minutes..."
  sleep 10m

  echo "Stop recording"
  touch hooks/stop_record || exit 1

  # Wait for recording to stop
  while [ `cat state/record` = "true" ]; do
    sleep 0.1
  done
done
