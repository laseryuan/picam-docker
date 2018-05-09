#!/usr/bin/env bash
# Based on vmerge script in cam-tftp project
# How to run it:
# put all the files to raw folder
# run vmerge.sh, all genereated file will be put to transcoded folder
# cd data 
# ~/projects/cam-tftp/bin/vmerge.sh

# Check if the folder exist
cd /root/picam/archive/ || exit 1

# Get the files of a day
all_mp4_files=`ls -1rt *.mp4`

target_day="2018-05-08"
day_begin=7 # 7 a.m.
target_day_next_day=`date -d "$target_day +1 day" "+%Y-%m-%d"`
ARRAY=()

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
    ARRAY=("${ARRAY[@]}" $mp4_file)
  fi
done

echo "Compiling: ${ARRAY[@]}"

for mp4_file in "${ARRAY[@]}"; do
  echo $mp4_file
done


PATH=~/projects/cam-tftp/bin/:$PATH
root_path=`[ $# -eq 0  ] &&  echo  $PWD || echo $1`
echo $root_path

cd $root_path/raw
for folder_path in */; do
  folder=`basename $folder_path`
  target=$root_path/transcoded/$folder

  # clear target folder if it exists
  if [ -d "$target" ]; then
    rm -r $target
  fi

  # create target folder
  mkdir -pv $target/clips

  # convert files
  cd $root_path/raw/$folder
  for f in $(ls *.avi); do
    file=`sed "s/\(Rec[0-9]*\)_[0-9]\{8\}\([0-9]\{2\}\)\([0-9]\{2\}\).*$/\1_\2_\3.mp4/" <<< $f`
    echo $root_path/raw/$folder/$f
    echo $root_path/transcoded/$folder/clips/$file
    ffmpeg -i $root_path/raw/$folder/$f -c:v libx264 -preset ultrafast -crf 28 -c:a libfdk_aac -vf scale=-2:180,format=yuv420p $root_path/transcoded/$folder/clips/$file
  done

  # remove failure files
  echo "removing failure files ..."
  cd $root_path/transcoded/$folder/clips
  counter=0
  for f in $(ls *.mp4)
  do
    minimumsize=500000 # 500k
    actualsize=$(wc -c <"$f")
    if [ $actualsize -le $minimumsize ]; then
      echo size $actualsize is under $minimumsize bytes
      rm -f $f
      let counter+=1
    fi
  done
  echo "$counter files are removed"

  # join files
  echo "join files ..."
  cd $root_path/transcoded/$folder/clips
  ffmpeg -f concat -safe 0 -i <(for f in *.mp4; do echo "file '$PWD/$f'"; done) -c copy $root_path/transcoded/$folder/$folder.mp4

  # make short video
  echo "making short video ..."
  cd $root_path/transcoded/$folder
  ffmpeg -i $folder.mp4 -filter:v "setpts=0.003*PTS" -an $folder-snap.mp4

  # make video contact sheet
  echo "convet to image ..."
  cd $root_path/transcoded/$folder
  vcs -c 12 $folder.mp4 -o $folder.png
  vcs -c 12 -i 1m $folder.mp4 -o $folder-big.png
done
