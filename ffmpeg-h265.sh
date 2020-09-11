#!/bin/bash
mkdir h265
for name in *.mp4; do
  ffmpeg -i "$name" -c:v libx265 -c:a copy -tag:v hvc1 "./h265/${name%.*}.mp4"
  echo "./h265/${name%.*}.mp4"
done
