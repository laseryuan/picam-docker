#!/bin/sh
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

picam_is_alive() {
  pgrep -x picam
}

restart_picam() {
  echo "Picam is dead. Restarting picam ..."
  echo "picam $(cat ~/picam_param) &"
  picam $(cat ~/picam_param) &
  sleep 5
}

health_check() {
  while ! picam_is_alive; do
    echo "Picam is dead."
    restart_picam
  done
}

start_record() {
  echo "Start recording"
  touch hooks/start_record || exit 1
  sleep 5
  if [ `cat state/record` = "false" ]; then
    echo "Record stop working. Kill picam and restart ..."
    kill -9 $(pidof picam)
    restart_picam
    start_record
  fi
}

# Set global recordbuf to 30
echo 30 > hooks/set_recordbuf

# Do forever
while :
do
  health_check

  start_record

  echo "Keep recording for about ten minutes..."
  wait_for_about_ten_minutes

  echo "Stop recording"
  touch hooks/stop_record || exit 1

  # Wait for recording to stop
  sleep 5
  # while [ `cat state/record` = "true" ]; do
    # echo "Waiting for recorder to stop ..."
    # sleep 5
  # done
done
