#!/bin/sh
openssl req \
 -x509 \
 -newkey rsa:2048 \
 -keyout cert-key.pem \
 -out cert.pem \
 -days 365 \
 -nodes \
 -sha256 \
 -subj "/C=US/ST=Oregon/L=Portland/O=Company Name/OU=Org/CN=www.example.com"

