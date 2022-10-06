#!/bin/bash

PRIV_FILE=ed25519-private.pem
PUB_FILE=ed25519-public.pem
openssl genpkey -algorithm ed25519 -outform PEM -out ${PRIV_FILE} 
openssl pkey -in ${PRIV_FILE} -pubout -outform PEM -out ${PUB_FILE}
