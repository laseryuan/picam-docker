#!/bin/sh
# Start nginx server
/usr/local/nginx/sbin/nginx

# Check if the folder exist
cd /root/picam/archive/ || exit 1

# Stop converting on Ctrl-C
trap on_sigint INT
on_sigint() {
  echo "Stop converting"
  exit 0
}

check_disk_usage() {
  while :
  do
    echo "Check disk capacity..."
    used_percentage=$(df --output=pcent / | tr -dc '0-9')
    if [ $used_percentage -gt 95 ]; then
      echo "Disk usage: $used_percentage%, trying to trim files ..."
      latestfile=$(ls -1rt *.mp4 | head -n1)
      rm "$latestfile"
    else
      echo "Pass"
      break
    fi

    echo "Waiting for 10 seconds and check disk usage again..."
    sleep 10
  done
}

# Do forever
while :
do
  check_disk_usage

  ts_files_number=$(ls -1t ./*.ts | wc -l)
  echo "$ts_files_number ts files left."

  if [ $ts_files_number -gt 1 ]; then
    echo "Start converting..."
    latestfile=$(ls -1t ./*.ts | head -n2 | tail -n1 | sed -e 's/\.ts$//')
    nice --15 ffmpeg -i "$latestfile.ts" -acodec copy -vcodec copy -y "$latestfile.mp4"
    rm "$latestfile.ts"
  fi

  echo "Waiting for one minutes to see if any more ts file need to be convert..."
  sleep 1m
done
