#!/bin/sh -x

set -e

rm -rf ca.conf ca *.pem
cat <<EOM >ca.conf
[ ca ]
default_ca = ca_default

[ ca_default ]
dir = ./ca
certs = \$dir
new_certs_dir = \$dir/ca.db.certs
database = \$dir/ca.db.index
serial = \$dir/ca.db.serial
RANDFILE = \$dir/ca.db.rand
certificate = \$dir/ca.crt
private_key = \$dir/ca.key
default_days = 365
default_crl_days = 30
default_md = sha256
preserve = no
policy = generic_policy

[ generic_policy ]
countryName = optional
stateOrProvinceName = optional
localityName = optional
organizationName = optional
organizationalUnitName = optional
commonName = optional
emailAddress = optional
EOM

mkdir -p ca 
cd ca
    mkdir -p ca.db.certs
    touch ca.db.index
    openssl rand -hex 16 > ca.db.serial
cd -

CA_KEY=ca/ca.key
CA_CERT=ca/ca.crt
KEY_FILE=server-key.pem
REQUEST_FILE=server-req.pem
SERVER_CERT=server-crt.pem
openssl genrsa -aes256 -out ${CA_KEY} 2048
openssl req -new -x509 -days 3650 -key ${CA_KEY} -out ${CA_CERT}
openssl genrsa -out ${KEY_FILE} 2048
openssl req -new -key ${KEY_FILE} -out ${REQUEST_FILE}
openssl ca -config ca.conf -out ${SERVER_CERT} -in ${REQUEST_FILE} -md sha256
set +e
set +x
echo
echo "You need the following files:"
echo "CA certificate:     ${CA_CERT}"
echo "server key file:    ${KEY_FILE}"
echo "server certificate: ${SERVER_CERT}"
echo 


