#!/bin/bash
# source: https://www.scottbrady91.com/openssl/creating-elliptical-curve-keys-using-openssl

# find your curve
openssl ecparam -list_curves

# generate a private key for a curve
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem

# generate corresponding public key
openssl ec -in private-key.pem -pubout -out public-key.pem

# show both keys
openssl pkey -in private-key.pem -text
openssl pkey -pubin -in public-key.pem -text

# optional: create a self-signed certificate
openssl req -new -x509 -key private-key.pem -out cert.pem -days 360

# optional: convert pem to pfx
openssl pkcs12 -export -inkey private-key.pem -in cert.pem -out cert.pfx


