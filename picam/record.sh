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

wait_for_about_ten_minutes() {
  date_format='+%Y-%m-%dT%H:%M:00'
  ten_nimutes_later=$(date -d '+10 minute' $date_format)
  ten_nimutes_later=$(date -d '+10 minute' '+%Y-%m-%dT%H:%M:00')
  echo "ten minutes later: $ten_nimutes_later"
  minutes=$(date -d $ten_nimutes_later '+%-M')
  minutes_mod=$(($minutes % 10))
  minutes_round=$(( minutes - minutes_mod))
  end_at=$(date -d $(date -d $ten_nimutes_later "+%Y-%m-%dT%H:$minutes_round:00") $date_format)
  echo "end at $end_at"
  wait_for=$(($(date -d $end_at "+%s") - $(date "+%s")))
  echo sleep $wait_for seconds
  sleep $wait_for
}

# Do forever
while :
do
  echo "Start recording"
  touch hooks/start_record || exit 1

  echo "Keep recording for about ten minutes..."
  wait_for_about_ten_minutes

  echo "Stop recording"
  touch hooks/stop_record || exit 1

  # Wait for recording to stop
  while [ `cat state/record` = "true" ]; do
    sleep 0.1
  done
done
