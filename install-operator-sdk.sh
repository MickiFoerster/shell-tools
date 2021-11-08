#!/bin/sh

set -e
go get -d github.com/operator-framework/operator-sdk
cd ${GOPATH}/src/github.com/operator-framework/operator-sdk
git checkout master
make tidy
make install


