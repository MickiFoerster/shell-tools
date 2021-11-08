#!/bin/sh
if [ ! -f "$1" ];
then
  echo "syntax error: $0 <file to be removed>";
  exit 1;
fi
#echo Overwriting file content with random bytes ...
#tmp_rnd_file=/tmp/rnd_$RANDOM_$RANDOM
#dd if=/dev/urandom of=$tmp_rnd_file bs=1 count=`stat -c "%s" "$1"`
#cat $tmp_rnd_file | base64 > "$1" && rm $tmp_rnd_file 
NUM_BYTES=`stat -c "%s" "$1"`
openssl rand ${NUM_BYTES} > "$1" && rm -f "$1";
