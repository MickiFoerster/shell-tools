#!/bin/bash

if [[ -z "$1" ]]; then
    echo "error: No DNS or IP addresses for alternative names were found. Give them as parameter"
    exit 1
fi

if [[ ! -f ca.key || ! -f ca.crt ]]; then
    echo "error: could not find certificate authority files ca.key or ca.crt"
    echo "Maybe you want to call create-CA-certificates.sh first."
    exit 1
fi

cfg=/tmp/openssl.cnf
cat > ${cfg} <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
EOF

ip_counter=1
dns_counter=1
for var in "$@"
do
    if [[ ${var:0:1} == [0-9] ]]; then
        echo "IP.${ip_counter} = $var" >> ${cfg}
        let ip_counter=${ip_counter}+1
    else
        echo "DNS.${dns_counter} = $var" >> ${cfg}
        let dns_counter=${dns_counter}+1
    fi
done

openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=server" -out server.csr -config ${cfg}
openssl x509 -req \
             -in server.csr \
             -CA ca.crt -CAkey ca.key -CAcreateserial \
             -out server.crt \
             -extensions v3_req \
             -extfile ${cfg} \
             -days 365
