#!/bin/bash

# Update system and install necessary packages
apt-get update -y && apt-get upgrade -y
apt-get install -y curl vim htop net-tools

# 1. Increase file descriptor limits (ulimit)
# This helps handle a larger number of simultaneous file handles and connections.
echo "fs.file-max = 1000000" >> /etc/sysctl.conf
sysctl -p
echo "root soft nofile 500000" >> /etc/security/limits.conf
echo "root hard nofile 1000000" >> /etc/security/limits.conf
echo "* soft nofile 500000" >> /etc/security/limits.conf
echo "* hard nofile 1000000" >> /etc/security/limits.conf

# Apply the changes for the current shell session
ulimit -n 500000

# 2. Optimize network performance by adjusting TCP settings
# These settings help to reduce congestion and allow the system to handle a large number of web requests.

# Increase the maximum number of connection requests waiting in the queue
echo "net.core.somaxconn = 65535" >> /etc/sysctl.conf

# Increase the maximum number of pending connection requests that can be queued
echo "net.ipv4.tcp_max_syn_backlog = 4096" | sudo tee -a /etc/sysctl.conf

# Increase the maximum number of open ports
echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf

# Enable TCP SYN cookies to prevent SYN flood attacks
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf

# Set the maximum receive/send buffer size
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf

# Set the default and maximum size of the TCP read buffer
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >> /etc/sysctl.conf

# Set the default and maximum size of the TCP write buffer
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >> /etc/sysctl.conf

# Reducing the TIME_WAIT duration
echo "net.ipv4.tcp_fin_timeout = 15" | sudo tee -a /etc/sysctl.conf

# Adjust the TCP keepalive parameters to drop dead connections faster
echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 60" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 10" >> /etc/sysctl.conf

echo "net.ipv4.tcp_fastopen = 3" | sudo tee -a /etc/sysctl.conf

# 3. Enable IP forwarding (for servers handling traffic between networks)
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Apply the new TCP settings
sysctl -p
