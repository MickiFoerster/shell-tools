#!/bin/bash

d=$HOME/git/github
if [[ -d $d ]]; then
    cd $d
    git clone https://github.com/iovisor/bcc.git
    git clone https://github.com/iovisor/bpftrace
    cd -
fi

