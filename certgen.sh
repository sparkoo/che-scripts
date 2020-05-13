#!/bin/bash

function certgen {
  if [ -z ${1} ]; then
    echo "need one domain param 'certgen <DOMAIN>'" 
    exit 1
  fi
  DOMAIN=${1}

  CA_CN=eclipse-che-signer
  OPENSSL_CNF=/etc/pki/tls/openssl.cnf

  openssl genrsa -out rootCA.key 4096

  openssl req -x509 \
    -new -nodes \
    -key rootCA.key \
    -sha256 \
    -days 1024 \
    -out rootCA.crt \
    -subj /CN=${CA_CN} \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat ${OPENSSL_CNF} \
        <(printf '[SAN]\nbasicConstraints=critical, CA:TRUE\nkeyUsage=keyCertSign, cRLSign, digitalSignature, keyEncipherment'))

  openssl genrsa -out domain.key 2048

  openssl req -new -sha256 \
    -key domain.key \
    -subj "/O=EclipseChe/CN=${DOMAIN}" \
    -reqexts SAN \
    -config <(cat ${OPENSSL_CNF} \
        <(printf "\n[SAN]\nsubjectAltName=DNS:${DOMAIN}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=keyCertSign, digitalSignature, keyEncipherment\nextendedKeyUsage=serverAuth")) \
    -out domain.csr

  openssl x509 \
    -req \
    -sha256 \
    -extfile <(printf "subjectAltName=DNS:${DOMAIN}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=keyCertSign, digitalSignature, keyEncipherment\nextendedKeyUsage=serverAuth") \
    -days 365 \
    -in domain.csr \
    -CA rootCA.crt \
    -CAkey rootCA.key \
    -CAcreateserial -out domain.crt
}