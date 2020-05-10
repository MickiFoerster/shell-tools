#!/bin/bash

log_info() {
  [[ -n "$1" ]] && echo "$1"
}

cleanup() {
  if [ ${CHILD_PID} -ne 0 ]; then
    log_info "kill child process ${CHILD_PID}"
    kill -9 ${CHILD_PID}
  fi 
}

sighandler()
{
    log_info "signal INT, TERM, or QUIT received"
    cleanup
    exit 0
}

trap 'sighandler' QUIT
trap 'sighandler'  INT
trap 'sighandler' TERM

CHILD_PID=0

while true; do
  log_info "start child ..."
  /bin/sleep 60 &
  CHILD_PID=$!
  log_info "wait for child to finish"
  wait $!
  log_info "child has terminated"
  sleep 1
done

