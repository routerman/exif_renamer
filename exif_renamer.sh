#!/bin/bash

function exif_renamer() {
  if [[ ! -d "$1" ]]; then
    echo "[ERROR] not dir."
    return 1
  fi
  for file in $1/*; do
    echo ""
    echo "target: "$file

    if [[ ! -f "$file" ]]; then
      echo "not file. skipping.."
      continue
    fi

    base_name=`basename "$file"`
    if [[ ${base_name:0:2} = "20" ]]; then
      echo "already renamed. skipping.."
      base_name=${base_name:18}
      continue
    fi

    echo "base_name: "$base_name
    timestamp=`exiftool "$file" | grep -m 1 -e "^Create Date" | awk '{printf "%s_%s", $4, $5}'`
    echo "timestamp: "$timestamp
    if [[ ! $timestamp ]]; then
      echo `exiftool "$file"`
      echo "not media file. skipping.."
      continue
    fi

    dir_name=`dirname "$file"`
    #CMD="cp -ap ${file} ${dir_name}/${timestamp//\:/}_$base_name"
    CMD="mv \"${file}\" \"${dir_name}/${timestamp//\:/}_$base_name\""
    echo $CMD
    eval $CMD
  done
}

exif_renamer $1

