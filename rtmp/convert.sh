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

# Do forever
while :
do
  ts_files_number=$(ls -1t ./*.ts | wc -l)
  echo "$ts_files_number ts files left."
  if [ $ts_files_number -gt 1 ]; then
    echo "Start converting..."
    latestfile=$(ls -1t ./*.ts | head -n2 | tail -n1 | sed -e 's/\.ts$//')
    nice --15 ffmpeg -i "$latestfile.ts" -acodec copy -vcodec copy -y "$latestfile.mp4"
    rm "$latestfile.ts"
  fi

  echo "Waiting for one minute..."
  sleep 1m
done
