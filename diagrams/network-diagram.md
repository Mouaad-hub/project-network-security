# Network Topology Diagram

## Overview

```
                        ┌─────────────────┐
                        │    INTERNET      │
                        │   (WAN / Cloud)  │
                        └────────┬─────────┘
                                 │
                          10.0.0.1 (port3)
                                 │
                    ┌────────────▼────────────┐
                    │                         │
                    │    FortiGate Firewall    │
                    │                         │
                    │  VIP: 10.0.0.1:80  ──► 192.168.1.2:80   │
                    │  VIP: 10.0.0.1:443 ──► 192.168.1.2:443  │
                    │                         │
                    └──┬──────────┬───────────┘
                       │          │
              port2 (DMZ)      vlan10 / vlan20
              192.168.1.x      192.168.10.x / 192.168.10.x
                       │          │
          ┌────────────▼──┐   ┌───▼──────────────┐
          │  DMZ Network  │   │   LAN Networks    │
          │               │   │                   │
          │  ┌──────────┐ │   │  ┌────────────┐  │
          │  │Web Server│ │   │  │  VLAN 10   │  │
          │  │192.168.1.2│ │  │  │  Clients   │  │
          │  │  Apache  │ │   │  └────────────┘  │
          │  │  HTTPD   │ │   │  ┌────────────┐  │
          │  │  + SSL   │ │   │  │  VLAN 20   │  │
          │  └──────────┘ │   │  │  Clients   │  │
          └───────────────┘   │  └────────────┘  │
                       ▲      └──────────────────┘
                       │        ▲
                       │        │
                    ┌──┴────────┴─────┐
                    │   SSL VPN       │
                    │  (ssl.root)     │
                    │  Remote Users   │
                    └─────────────────┘
```

---

## Interface Mapping

| Interface | Zone | Subnet | Description |
|---|---|---|---|
| port3 | WAN | 10.0.0.1 | Internet-facing interface |
| port2 | DMZ | 192.168.1.x | DMZ for web server |
| vlan10 | LAN | 192.168.10.x | Internal LAN - VLAN 10 |
| vlan20 | LAN | 192.168.20.x | Internal LAN - VLAN 20 |
| ssl.root | VPN | SSLVPN pool | SSL VPN tunnel interface |

---

## Traffic Flows

### 1. External User → Web Server (HTTP/HTTPS)
```
Internet → port3 (10.0.0.1) → VIP NAT → port2 → Web Server (192.168.1.2)
Policy: wan-http | Services: HTTP, HTTPS
```

### 2. LAN Users → Internet
```
vlan10/vlan20 → port3 (WAN) with NAT
Policy: vlans-net
```

### 3. LAN Users → DMZ
```
vlan10/vlan20 → port2 (DMZ)
Policy: vlans-dmz
```

### 4. VPN Users → Internal Resources
```
ssl.root → vlan10     (Policy: vpn-vlan10)
ssl.root → vlan20     (Policy: vpn-vlan20)
ssl.root → port2/DMZ  (Policy: vpn-dmz)
ssl.root → port3/WAN  (Policy: vpn-net, with NAT)
```

### 5. DMZ → Internet
```
port2 (DMZ) → port3 (WAN) with NAT
Policy: dmz-net
```
