#!/bin/bash

function build_clip_list() {
  all_mp4_files="$1"
  for mp4_file in $all_mp4_files; do
    # mp4_file="2018-05-09_12-20-00.mp4" # for dev
    local the_day=`echo $mp4_file | cut -d'_' -f 1`
    local hour_str=`echo $mp4_file | cut -d'_' -f 2 | cut -d'.' -f 1 | cut -d'-' -f 1`
    local hour_num=$((10#$hour_str))
    local is_target_file=false

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
}

  [[ "${DEBUG_MODE}" == "true" ]] && ffmpeglog="debug" || ffmpeglog="error"

  DAY_BEGIN=7 # i.e. 7 a.m.

  ROOT_DIRECTORY=/root/picam/archive/lapse

  # Check if the folder exist
  cd $ROOT_DIRECTORY || exit 1

  date_format="+%Y-%m-%d"

  # Get the files of a day
  all_mp4_files=`ls -1 *.mp4  2>/dev/null`

  target_day=$1
  # target_day="2018-05-10" # for dev
  target_day_next_day=`date -d "$target_day +1 day" $date_format`

  CLIP_LIST=()
  build_clip_list "${all_mp4_files}"

  if [ ${#CLIP_LIST[@]} = 0 ]; then
    echo "`date`: No lapse video clips to join for $target_day ..."
    exit 0
  fi

  for mp4_file in "${CLIP_LIST[@]}"; do
    echo "file $mp4_file"
  done > $target_day.txt

  cat $target_day.txt

  # join files
  echo "`date`: Join lapse video clips for $target_day ..."
  if [ -f output/$target_day.mp4 ]; then # if there are more of the day clip come out after last joint
    echo "Find more clips of the day. Trying to join with existing lapse video"
    mv output/$target_day.mp4 output/$target_day.tmp.mp4
    sed -i "1s/^/file output\/$target_day.tmp.mp4\n/" $target_day.txt
    nice -15 ffmpeg -y -v $ffmpeglog -f concat -i $target_day.txt -c copy output/$target_day.mp4
    rm output/$target_day.tmp.mp4
  else
    nice -15 ffmpeg -y -v $ffmpeglog -f concat -i $target_day.txt -c copy output/$target_day.mp4
  fi

  # clean up temp files
  mv $target_day.txt ./recycle/
  mv "${CLIP_LIST[@]}" ./recycle/

  echo "`date`: Done"
