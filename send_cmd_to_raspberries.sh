#!/bin/bash
list_of_hosts="192.168.0.40 \
               192.168.0.41 \
               192.168.0.42 \
               192.168.0.43"
while true;
do
  printf "Give command for sending to cluster of Raspberry Pi's:\n>"
  read cmd;
  for i in $list_of_hosts;
  do
    terminator --title="Host $i" --command="ssh -t pi@$i $cmd;echo DONE;sleep 3;" 
  done
done;
