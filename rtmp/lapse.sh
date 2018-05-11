#!/usr/bin/env bash
# Based on vmerge script in cam-tftp project
# How to run it:
# put all the files to raw folder
# run vmerge.sh, all genereated file will be put to transcoded folder
# cd data 
# ~/projects/cam-tftp/bin/vmerge.sh

# Check if the folder exist
cd /root/picam/archive/lapse || exit 1

# Get the files of a day
all_mp4_files=`ls -1rt *.mp4`

target_day="2018-05-11"
day_begin=7 # 7 a.m.
target_day_next_day=`date -d "$target_day +1 day" "+%Y-%m-%d"`
CLIP_LIST=()

# for mp4_file in `ls -1rt *.mp4`; do
for mp4_file in $all_mp4_files; do
  # mp4_file="2018-05-09_12-20-00.mp4" # for dev
  the_day=`echo $mp4_file | cut -d'_' -f 1`
  hour_str=`echo $mp4_file | cut -d'_' -f 2 | cut -d'.' -f 1 | cut -d'-' -f 1`
  hour_num=$((10#$hour_str))
  is_target_file=false

  if [ "$the_day" = "$target_day" ]; then
    if (( $hour_num>=$day_begin )); then
      is_target_file=true
    fi
  fi

  if [ "$the_day" = "$target_day_next_day" ]; then
    if (( $hour_num < $day_begin )); then
      is_target_file=true
    fi
  fi

  if $is_target_file ; then
    CLIP_LIST=("${CLIP_LIST[@]}" $mp4_file)
  fi
done

for mp4_file in "${CLIP_LIST[@]}"; do
  echo "file $mp4_file"
done > $target_day.txt

# join files
echo "join files ..."
ffmpeg -y -v quiet -f concat -i $target_day.txt -c copy output/$target_day.mp4
rm $target_day.txt
rm "${CLIP_LIST[@]}"
