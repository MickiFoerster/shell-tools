#!/bin/sh

if [ -z "$1" -o -z "$2" ]; then
    echo "syntax error: $0 <private key for authentication> <host>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echot "error: private key file does not exist"
    exit 1
fi

ssh -o "IdentitiesOnly=yes" -i $1 $2
