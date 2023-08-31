#!/bin/bash


# for P-256 EC key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out P-256-private.pem

# for P-384 EC key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -out P-384-private.pem

# for P-521 EC key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-521 -out P-521-private.pem

# for secp256k1 EC key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp256k1 -out secp256k1-private.pem

# for X25519 ECX key
openssl genpkey -algorithm X25519 -out X25519-private.pem

# for X448 ECX key
openssl genpkey -algorithm X448 -out X448-private.pem

# Generate a public key from the private key.
for i in *-private.pem; do 
    openssl pkey -in "$i" -pubout -out $(basename "$i" private.pem)public.pem
done
