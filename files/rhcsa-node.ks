# RHEL 10 Hands-Off Lab Provisioning Kickstart
text
reboot

# System Language and Region Setup
lang en_AU.UTF-8
keyboard us
timezone Australia/Adelaide --utc

# Network Configuration
network --bootproto=dhcp --device=link --activate --hostname=rhcsa-node1.lab.local

# Authentication Settings
rootpw --plaintext redhat
user --name=sclark --groups=wheel --plaintext --password=Jackass01!

# Disk Partitioning (Automated LVM on default disk)
zerombr
clearpart --all --initlabel
autopart --type=lvm

# Package Selection
%packages
@minimal
@container-management
%end

# Post-installation Configuration
%post
# Allow root SSH password logins for Ansible lab exercises
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config.d/01-permitrootlogin.conf 2>/dev/null || true
%end
