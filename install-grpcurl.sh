#!/bin/bash 

set -ex 

cd /tmp/
curl -LO "lttps://github.com/fullstorydev/grpcurl/releases/download/v1.8.9/grpcurl_1.8.9_linux_x86_64.tar.gz"
tar xf grpcurl_1.8.9_linux_x86_64.tar.gz
mv grpcurl ~/bin/

if ! command -v grpcurl ; then 
    echo "Installatio of grpcurl failed"
    exit 1
else 
    echo "Installation of grpcurl succeeded"

set +ex 
