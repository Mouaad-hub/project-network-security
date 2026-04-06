#!/bin/bash
# generate-cert.sh
# Generates a self-signed SSL certificate for Apache HTTPD

echo "=== SSL Certificate Generator ==="

# Variables - change these as needed
COUNTRY="MA"
STATE="Marrakesh"
CITY="Marrakesh"
ORG="MyOrganization"
OU="IT"
CN="192.168.1.2"   # Change to your domain or IP
DAYS=365
KEY_FILE="mykey.key"
CERT_FILE="mycert.crt"

# Generate private key and self-signed certificate
echo "[*] Generating private key and certificate..."
openssl req -x509 -nodes -days $DAYS -newkey rsa:2048 \
  -keyout $KEY_FILE \
  -out $CERT_FILE \
  -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/OU=$OU/CN=$CN"

# Copy to appropriate directories
echo "[*] Copying certificate files..."
cp $CERT_FILE /etc/pki/tls/certs/
cp $KEY_FILE /etc/pki/tls/private/

# Set secure permissions
echo "[*] Setting permissions..."
chmod 644 /etc/pki/tls/certs/$CERT_FILE
chmod 600 /etc/pki/tls/private/$KEY_FILE
chown root:root /etc/pki/tls/private/$KEY_FILE

echo "[✓] Certificate generated successfully!"
echo "    Certificate : /etc/pki/tls/certs/$CERT_FILE"
echo "    Private Key : /etc/pki/tls/private/$KEY_FILE"
echo ""
echo "[*] Certificate details:"
openssl x509 -in /etc/pki/tls/certs/$CERT_FILE -noout -dates
