#!/bin/bash
USERNAME=$1
PASSWORD=$2
echo There were $# parameters passed
#Requires openssl
if [ -z "$1" ]
then
        echo "Param \$USERNAME not passed correctly"
        USERNAME=administrator
        echo "Default name is $USERNAME"
fi 
CPATH=self_signed_certs
echo "Mapping Key to: $USERNAME"
rm -rf ./$CPATH 
mkdir ./$CPATH

cat > openssl.conf << EOL
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:$USERNAME@localhost
EOL

export OPENSSL_CONF=openssl.conf
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out cert.pem -outform PEM -keyout cert_key.pem -subj "/CN=$USERNAME" -extensions v3_req_client

rm openssl.conf
mv cert.pem ./$CPATH
mv cert_key.pem ./$CPATH

if [ -n "$2" ]
then
        echo "Password param passed. Creating credential file with $USERNAME and $PASSWORD"
        #remove any old credential file if exists
        rm -f creds.txt
        #create credential file and append values for powershell automation
        touch creds.txt 
        echo "$USERNAME" >> creds.txt
        echo "$PASSWORD" >> creds.txt
else
        echo "No password passed."
        echo "Default password will be 12qwaszx!@QWASZX"
        echo "$USERNAME" >> creds.txt
        echo "12qwaszx!@QWASZX" >> creds.txt
fi
mv creds.txt ./$CPATH
echo "Files created in ./self_signed_certs"

