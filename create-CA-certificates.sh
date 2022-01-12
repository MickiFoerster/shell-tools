#!/bin/bash

# Create private key for CA
openssl genrsa -out ca.key 8192

# Create CSR using the private key
openssl req -new -key ca.key -subj "/CN=my-CA" -out ca.csr

# Self sign the csr using its own private key
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial  -out ca.crt -days 3650
