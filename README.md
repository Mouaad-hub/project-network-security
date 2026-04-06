# 🔐 Network Security Project

A hands-on network security lab implementing SSL/TLS termination, VPN access, DMZ architecture, and firewall policies using **FortiGate**, **CentOS/Apache HTTPD**, and **OpenSSL**.

---

## 📋 Project Overview

This project demonstrates a complete secure network infrastructure including:

- Self-signed SSL/TLS certificate generation and deployment
- Apache HTTPD configured with HTTPS on CentOS
- FortiGate Virtual IPs (VIP) for HTTP/HTTPS port forwarding
- Firewall policies for VLANs, DMZ, VPN, and WAN access
- SSL VPN with split tunneling to internal VLANs and DMZ

---

## 🗺️ Network Architecture

```
Internet (WAN)
      |
   port3 (10.0.0.1)
      |
 [FortiGate Firewall]
      |
   port2 (DMZ) ──────── Web Server (192.168.1.2)
      |                  Apache HTTPD + SSL
   vlan10 (LAN)
   vlan20 (LAN)
      |
   SSL VPN (ssl.root)
```

---

## 🛠️ Components

| Component | Role |
|---|---|
| FortiGate | Firewall, VPN, NAT, VIP |
| CentOS Linux | Web server OS |
| Apache HTTPD | Web server |
| OpenSSL | Certificate generation |
| mod_ssl | Apache SSL module |

---

## 📁 Repository Structure

```
network-security-project/
├── README.md
├── configs/
│   ├── fortigate-vip.conf        # FortiGate VIP configuration
│   ├── fortigate-policy.conf     # FortiGate firewall policies
│   └── httpd-ssl.conf            # Apache SSL virtual host config
├── scripts/
│   ├── generate-cert.sh          # SSL certificate generation script
│   └── setup-httpd-ssl.sh        # Apache HTTPS setup script
└── diagrams/
    └── network-diagram.md        # Network topology description
```

---

## 🚀 Quick Start

### 1. Generate SSL Certificate (CentOS)

```bash
chmod +x scripts/generate-cert.sh
sudo ./scripts/generate-cert.sh
```

### 2. Configure Apache HTTPS

```bash
chmod +x scripts/setup-httpd-ssl.sh
sudo ./scripts/setup-httpd-ssl.sh
```

### 3. Apply FortiGate Config

Copy the contents of `configs/fortigate-vip.conf` and `configs/fortigate-policy.conf` into your FortiGate CLI.

---

## 🔒 Security Features

- ✅ TLS 1.2+ enforced (TLS 1.0/1.1 disabled)
- ✅ HTTP → HTTPS redirect
- ✅ Private key with strict permissions (600)
- ✅ SSL VPN for remote access
- ✅ DMZ isolation for web server
- ✅ VLAN segmentation (vlan10, vlan20)
- ✅ NAT enabled on outbound policies

---

## 📌 Firewall Policy Summary

| Policy | Source | Destination | Service | Action |
|---|---|---|---|---|
| vlans-com | vlan10, vlan20 | vlan10, vlan20 | ALL | ACCEPT |
| vlans-dmz | vlan10, vlan20 | DMZ (port2) | ALL | ACCEPT |
| dmz-net | DMZ (port2) | WAN (port3) | ALL | ACCEPT + NAT |
| vlans-net | vlan10, vlan20 | WAN (port3) | ALL | ACCEPT + NAT |
| wan-http | WAN (port3) | web-vip, web-vip-https | HTTP, HTTPS | ACCEPT |
| vpn-net | ssl.root | WAN (port3) | ALL | ACCEPT + NAT |
| vpn-vlan10 | ssl.root | vlan10 | ALL | ACCEPT |
| vpn-vlan20 | ssl.root | vlan20 | ALL | ACCEPT |
| vpn-dmz | ssl.root | DMZ (port2) | ALL | ACCEPT |

---

## 🧪 Testing

```bash
# Test HTTPS locally on web server
curl -k https://192.168.1.2

# Test HTTPS through FortiGate VIP
curl -k https://10.0.0.1

# Check Apache is listening on 443
ss -tlnp | grep 443

# Verify certificate details
openssl x509 -in /etc/pki/tls/certs/mycertificate.crt -text -noout
```

---

## 📎 Requirements

- FortiGate firewall (any supported version)
- CentOS 7/8/Stream
- Apache HTTPD + mod_ssl
- OpenSSL

---

## 👤 Author

**Mouaad** — Network Security Lab Project  
📍 Marrakesh, Morocco
