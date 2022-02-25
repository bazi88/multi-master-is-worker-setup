#! /bin/bash
LOAD_BALANCER="10.0.0.10"
MASTER_NODE="10.0.0.11"
NODE_NAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"
sudo kubeadm config images pull

INDEX_MASTER="${str:(-2)}"  
cat <<EOF>> /vagrant/configs/join.sh 
--apiserver-advertise-address=$INDEX_MASTER
EOF

/bin/bash /vagrant/configs/join.sh -v

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Tails this to worker node
sudo kubectl taint nodes --all node-role.kubernetes.io/master-