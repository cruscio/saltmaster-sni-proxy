#! /usr/bin/env bash

#Create (and/or clean up) TLS directory"
mkdir -p ./tls
rm -rf ./tls/* 
cd ./tls

country=US
state=Denial
locality=InaBox
organization=saltnet
organizationalunit=dev
email=donotreply@saltnet.tls
domain=saltnet.tls

# Create the CA Key and Certificate for signing Client Certs
openssl genrsa -out saltnet_ca.key 2048
openssl req -new -x509 -days 365 -key saltnet_ca.key -out saltnet_ca.crt \
  -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$domain/emailAddress=$email"

# Create the Server Certificate
openssl genrsa -out master.key 1024
openssl req -new -key master.key -out master.csr \
  -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=master.$domain/emailAddress=$email"
openssl x509 -req -days 365 -in master.csr -CA saltnet_ca.crt -CAkey saltnet_ca.key -set_serial 01 -out master.crt
openssl verify -purpose sslserver -CAfile saltnet_ca.crt master.crt
cat master.crt saltnet_ca.crt > master_fullchain.crt

# Create the Client Certificate
openssl genrsa -out minion.key 1024
openssl req -new -key minion.key -out minion.csr \
  -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=minion.$domain/emailAddress=$email"
openssl x509 -req -days 365 -in minion.csr -CA saltnet_ca.crt -CAkey saltnet_ca.key -set_serial 01 -out minion.crt
openssl verify -purpose sslclient -CAfile saltnet_ca.crt minion.crt


#Thanks to https://gist.github.com/komuw/076231fd9b10bb73e40f
#      and https://gist.github.com/jmhertlein/22a6d678d01cb7ca529e