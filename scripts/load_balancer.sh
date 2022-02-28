#! /bin/bash

LOAD_BALANCER="10.0.0.10"
MASTER_NODE="10.0.0.11"
NODE_NAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

# Create the directory /etc/nginx.
sudo mkdir /etc/nginx

# Add and edit the file /etc/nginx/nginx.conf.
cat <<EOF | sudo tee /etc/nginx/nginx.conf
events { }

stream {
    upstream stream_backend {
        least_conn;
        # REPLACE WITH master1 IP
        server 10.0.0.11:6443;
        # REPLACE WITH master2 IP
        server 10.0.0.12:6443;
        # REPLACE WITH master3 IP
        server 10.0.0.12:6443;
    }
       
    server {
        listen        6443;
        proxy_pass    stream_backend;
        proxy_timeout 3s;
        proxy_connect_timeout 1s;
    }
}
EOF