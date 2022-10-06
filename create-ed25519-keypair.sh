#!/bin/bash

openssl genpkey -algorithm ed25519 -outform PEM -out ed25519-private.pem
openssl pkey -in private.pem -pubout -outform PEM -out ed25519-public.pem
