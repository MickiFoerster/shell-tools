#!/bin/bash 

# 
# header 
# {
#  "typ":"JWT",
#  "alg":"HS256",
#  "kid":"0001"
# }
#
# payload: 
# {
#  "name":"Quotation System",
#  "sub":"quotes",
#  "iss":"My API Gateway"
# }

echo -n '{"typ":"JWT","alg":"HS256","kid":"0001"}' | base64 | tr '+/' '-_' | tr -d '='
# eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEifQ
echo -n '{"name":"Quotation System","sub":"quotes","iss":"My API Gateway"}' | base64 | tr '+/' '-_' | tr -d '='
# eyJuYW1lIjoiUXVvdGF0aW9uIFN5c3RlbSIsInN1YiI6InF1b3RlcyIsImlzcyI6Ik15IEFQSSBHYXRld2F5In0

HEADER_PAYLOAD=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEifQ.eyJuYW1lIjoiUXVvdGF0aW9uIFN5c3RlbSIsInN1YiI6InF1b3RlcyIsImlzcyI6Ik15IEFQSSBHYXRld2F5In0

# Sign header+payload with symmetric key 'fantasticjwt'
echo -n $HEADER_PAYLOAD | openssl dgst -binary -sha256 -hmac fantasticjwt | base64 | tr '+/' '-_' | tr -d '='
# ggVOHYnVFB8GVPE-VOIo3jD71gTkLffAY0hQOGXPL2I
#
# sign with RSA private key:
# echo -n "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJFUzI1NmluT1RBIiwibmFtZSI6IkpvaG4gRG9lIn0" | \
#   openssl dgst -sha256 -binary -sign jwtRSA256-private.pem  | \
#   openssl enc -base64 | 
#   tr -d '\n=' | tr -- '+/' '-_'

# Bring everything together:
echo $HEADER_PAYLOAD.ggVOHYnVFB8GVPE-VOIo3jD71gTkLffAY0hQOGXPL2I > quotes.jwt

# Access your secured API:
# curl -H "Authorization: Bearer `cat quotes.jwt`"
