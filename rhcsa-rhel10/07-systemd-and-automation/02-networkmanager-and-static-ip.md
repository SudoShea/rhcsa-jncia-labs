# Lab 07.2: NetworkManager CLI (nmcli) & Static IP Configuration on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/07-systemd-and-network-services/02-networkmanager-and-static-ip.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Query network devices, link statuses, and active profiles using `nmcli`.
2. Create, modify, and manage NetworkManager connection profiles.
3. Configure static IPv4 addressing, subnet prefix lengths, default gateways, and DNS servers.
4. Manage static routing tables and domain search suffixes using `nmcli`.
5. Configure static hostnames using `hostnamectl` and manage connection activation lifecycles.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with a secondary or primary network interface (e.g. `<interface_name>` such as `eth0` or `enp1s0`).
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are commissioning a new enterprise RHEL 10 database server that currently receives a dynamic IP address via DHCP. To ensure persistent network identity and service availability, you must reconfigure the network interface `<interface_name>` to use a static IPv4 assignment (`<static_ip>/24`), gateway (`<gateway_ip>`), and primary DNS server (`<dns_ip>`). Furthermore, you must set the system static hostname to `<server_hostname>` and ensure all network configurations persist across system reboots.

---

## 📝 Lab Tasks

### Task 1: Device and Connection Profile Inspection
1. Display all detected physical and virtual network devices and their current link states using `nmcli device`.
2. Display all configured NetworkManager connection profiles and identify active connections using `nmcli connection show`.
3. Inspect the detailed IP settings and configuration parameters of the active connection profile bound to `<interface_name>`.

### Task 2: Creating and Configuring a Static IPv4 Connection
1. Create a new Ethernet connection profile named `<connection_name>` bound to network interface `<interface_name>`.
2. Configure `<connection_name>` with static IPv4 addressing:
   * **IP Address & CIDR Prefix:** `<static_ip>/24`
   * **Default Gateway:** `<gateway_ip>`
   * **DNS Servers:** `<dns_ip>`
   * **IPv4 Method:** `manual`
3. Configure the connection profile to activate automatically on boot (`connection.autoconnect yes`).
4. Activate the newly created connection profile `<connection_name>` using `nmcli connection up`.
5. Verify that the interface `<interface_name>` reflects the static IP allocation using `ip addr show` and `ip route`.

### Task 3: Hostname Management & Network Verification
1. Display the current system static hostname using `hostnamectl`.
2. Permanently set the static hostname to `<server_hostname>` using `hostnamectl set-hostname`.
3. Verify local hostname resolution by mapping `<server_hostname>` to `<static_ip>` in `/etc/hosts`.
4. Validate external IP reachability and local DNS name resolution using `ping` and `host` (or `dig`).

---

## 🔍 Verification & Self-Test

Run these commands to verify your NetworkManager configuration and routing table:

```bash
# 1. Verify active network connections and bound interface
nmcli connection show --active

# 2. Confirm IP address assignment and gateway route
ip addr show <interface_name>
ip route show

# 3. Verify persistent hostname configuration
hostnamectl status
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Inspection
```bash
# 1. List network devices and link statuses
nmcli device status

# 2. List connection profiles
nmcli connection show

# 3. Inspect detailed properties of an active connection profile
nmcli connection show "<connection_name>"
```
Task 2 Solutions: Static IP Configuration
```bash
# 1. Add a new Ethernet connection profile with static settings
sudo nmcli connection add type ethernet con-name "<connection_name>" ifname "<interface_name>" \
    ip4 "<static_ip>/24" gw4 "<gateway_ip>"

# 2. Configure DNS servers and manual IPv4 method
sudo nmcli connection modify "<connection_name>" \
    ipv4.dns "<dns_ip>" \
    ipv4.method manual \
    connection.autoconnect yes

# 3. Alternatively, modify an existing DHCP connection to use static addressing:
# sudo nmcli connection modify "<connection_name>" ipv4.addresses "<static_ip>/24"
# sudo nmcli connection modify "<connection_name>" ipv4.gateway "<gateway_ip>"
# sudo nmcli connection modify "<connection_name>" ipv4.dns "<dns_ip>"
# sudo nmcli connection modify "<connection_name>" ipv4.method manual

# 4. Activate the updated connection profile
sudo nmcli connection up "<connection_name>"

# 5. Confirm network interface address and default route
ip addr show "<interface_name>"
ip route
```
Task 3 Solutions: Hostname & Name Resolution
```bash
# 1. Display current hostname settings
hostnamectl

# 2. Set static FQDN hostname
sudo hostnamectl set-hostname "<server_hostname>"

# 3. Add local resolution entry in /etc/hosts
sudo cat << EOF | sudo tee -a /etc/hosts
<static_ip> <server_hostname>
EOF

# 4. Verify connectivity and DNS resolution
ping -c 3 <gateway_ip>
ping -c 3 <server_hostname>
```
