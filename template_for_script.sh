#!/bin/bash

PROGNAME=${0##*/}
OPTION1=0
OPTION2=0
CHILD_PID=0

trap 'sighandler' QUIT
trap 'sighandler'  INT
trap 'sighandler' TERM

function sighandler() {
    log_info "signal INT, TERM, or QUIT received"
    cleanup
    exit 0
}

function init() {
    echo "in init() you should check prerequisites"
}

function usage() {
    cat <<EOM
Usage: ${PROGNAME} [--option1|-O1] [--option2|-O2]
Description what your script do.
  -O1, --option1               Description what option1 is good for
  -O2, --option2               Description what option2 is good for
  -h, --help                   display this help and exit
EOM
}

# logInfo() logs an information to stdout and log file
function logInfo() {
    printf "\e[1;32mINFO:$PROGNAME: $1\e[0;0m\n"
}

# logFatal() logs an error message and exits script
function logFatal() {
    printf "\e[1;31mERROR:$PROGNAME: $1\e[0;0m\n"
    exit 1
}

function cleanup() {
  if [ ${CHILD_PID} -ne 0 ]; then
    log_info "kill child process ${CHILD_PID}"
    kill -9 ${CHILD_PID}
  fi 
}

init

while [[ "$1" != "" ]]; do
    case $1 in
        -O1 | --option1 )
            shift
            OPTION1=1
            ;;
        -O2 | --option2 )
            shift
            OPTION2=1
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            exit 1
    esac
    shift
done

while true; do
  log_info "start child ..."
  /bin/sleep 60 &
  CHILD_PID=$!
  log_info "wait for child to finish"
  wait $!
  log_info "child has terminated"
  sleep 1
done

cleanup
