#!/bin/bash

set -euo pipefail

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT
cd "${TMP}"

if [[ "${GOBIN}" == "" ]] ; then 
    echo "GOBIN is empty"
    exit 1
fi

GO111MODULE=on GOBIN=${GOBIN} go get github.com/what/package/you/want
