#!/bin/bash

# Configuration variables
SSL_DIR="/etc/nginx/ssl"
CA_NAME="athena"
SERVER_NAME="athena.local"
DAYS=365
COUNTRY="US"
STATE="Tennessee"
LOCALITY="Johnson City"
ORGANIZATION="chandler-scott"
OU="chandler-scott"
SAN_CONFIG="${SSL_DIR}/san.cnf"

# Create SSL directory
sudo mkdir -p $SSL_DIR
cd $SSL_DIR

# Create SAN configuration file
cat <<EOF | sudo tee $SAN_CONFIG
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[ dn ]
C = $COUNTRY
ST = $STATE
L = $LOCALITY
O = $ORGANIZATION
CN = $SERVER_NAME

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $SERVER_NAME
EOF

# Step 1: Generate a self-signed certificate for the server
echo "Generating a self-signed certificate for the server..."
sudo openssl req -x509 -nodes -newkey rsa:2048 -days $DAYS \
-keyout ${SERVER_NAME}.key -out ${SERVER_NAME}.crt \
-config $SAN_CONFIG -extensions req_ext \
-subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$SERVER_NAME/OU=$OU"

# Optional: Setup your own CA and sign server certificates
read -p "Do you want to setup your own CA and sign the server certificate with it? (y/n): " SETUP_CA

if [[ $SETUP_CA == "y" ]]; then
    # Step 2: Create the Root CA (Only if needed)
    echo "Creating the Root CA..."
    sudo openssl genrsa -out ${CA_NAME}.key 2048
    sudo openssl req -x509 -new -nodes -key ${CA_NAME}.key -sha256 -days 1024 -out ${CA_NAME}.pem \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$CA_NAME"

    # Step 3: Create server key and CSR
    echo "Creating server key and CSR..."
    sudo openssl genrsa -out ${SERVER_NAME}.key 2048
    sudo openssl req -new -key ${SERVER_NAME}.key -out ${SERVER_NAME}.csr \
    -config $SAN_CONFIG -extensions req_ext

    # Step 4: Sign the server certificate with the CA
    echo "Signing the server certificate with the CA..."
    sudo openssl x509 -req -in ${SERVER_NAME}.csr -CA ${CA_NAME}.pem -CAkey ${CA_NAME}.key -CAcreateserial -out ${SERVER_NAME}.crt -days $DAYS -sha256 \
    -extfile $SAN_CONFIG -extensions req_ext

    echo "Server certificate signed by your CA has been created."
else
    echo "Self-signed server certificate has been created."
fi

sudo systemctl reload nginx

echo "All done. Certificates are in $SSL_DIR."

