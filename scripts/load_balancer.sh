#! /bin/bash

LOAD_BALANCER="10.0.0.10"
MASTER_NODE="10.0.0.11"
NODE_NAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

# Install Haproxy
sudo apt update && sudo apt install -y haproxy

# Configure haproxy
cat <<EOF | tee -a /etc/haproxy/haproxy.cfg
frontend kubernetes-frontend
    bind 10.0.0.10:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server master-node01 10.0.0.11:6443 check fall 3 rise 2
    server master-node02 10.0.0.12:6443 check fall 3 rise 2
    server master-node03 10.0.0.13:6443 check fall 3 rise 2
EOF

sudo systemctl restart haproxy
