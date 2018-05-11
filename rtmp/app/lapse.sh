#!/bin/bash
# Usage: join_lapse_clips `date "+%Y-%m-%d"`

  DAY_BEGIN=7 # 7 a.m.

  ROOT_DIRECTORY=/root/picam/archive/lapse
  # Check if the folder exist
  cd $ROOT_DIRECTORY || exit 1

  date_format="+%Y-%m-%d"

  # Get the files of a day
  all_mp4_files=`ls -1rt *.mp4  2>/dev/null`

  target_day=$1
  # target_day="2018-05-10" # for dev
  target_day_next_day=`date -d "$target_day +1 day" $date_format`

  CLIP_LIST=()
  for mp4_file in $all_mp4_files; do
    # mp4_file="2018-05-09_12-20-00.mp4" # for dev
    the_day=`echo $mp4_file | cut -d'_' -f 1`
    hour_str=`echo $mp4_file | cut -d'_' -f 2 | cut -d'.' -f 1 | cut -d'-' -f 1`
    hour_num=$((10#$hour_str))
    is_target_file=false

    if [ "$the_day" = "$target_day" ]; then
      if (( $hour_num>=$DAY_BEGIN )); then
        is_target_file=true
      fi
    fi

    if [ "$the_day" = "$target_day_next_day" ]; then
      if (( $hour_num < $DAY_BEGIN )); then
        is_target_file=true
      fi
    fi

    if $is_target_file ; then
      CLIP_LIST=("${CLIP_LIST[@]}" $mp4_file)
    fi
  done

  if [ ${#CLIP_LIST[@]} = 0 ]; then
    echo "`date`: No lapse video clips to join for $target_day ..."
    exit 0
  fi

  for mp4_file in "${CLIP_LIST[@]}"; do
    echo "file $mp4_file"
  done > $target_day.txt

  # join files
  echo "`date`: Join lapse video clips for $target_day ..."
  ffmpeg -y -v quiet -f concat -i $target_day.txt -c copy output/$target_day.mp4
  rm $target_day.txt
  rm "${CLIP_LIST[@]}"
  echo "`date`: Done"
