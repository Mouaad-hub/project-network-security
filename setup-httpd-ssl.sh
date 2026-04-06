#!/bin/bash
# setup-httpd-ssl.sh
# Configures Apache HTTPD with HTTPS on CentOS

echo "=== Apache HTTPS Setup ==="

# Install required packages
echo "[*] Installing httpd and mod_ssl..."
yum install -y httpd mod_ssl

# Copy SSL config
echo "[*] Applying SSL virtual host config..."
cp ../configs/httpd-ssl.conf /etc/httpd/conf.d/ssl.conf

# Test Apache configuration
echo "[*] Testing Apache configuration..."
apachectl configtest

if [ $? -eq 0 ]; then
    echo "[✓] Configuration OK"

    # Enable and restart Apache
    echo "[*] Enabling and restarting Apache..."
    systemctl enable httpd
    systemctl restart httpd

    # Open firewall ports
    echo "[*] Opening firewall ports..."
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    firewall-cmd --reload

    echo ""
    echo "[✓] Apache HTTPS setup complete!"
    echo "[*] Testing HTTPS connection..."
    curl -k https://localhost
else
    echo "[✗] Configuration error. Please check /etc/httpd/conf.d/ssl.conf"
    exit 1
fi
