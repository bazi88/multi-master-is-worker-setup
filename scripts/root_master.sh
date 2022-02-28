#! /bin/bash
LOAD_BALANCER="10.0.0.10"
MASTER_NODE="10.0.0.11"
NODE_NAME=$(hostname -s)
POD_CIDR="192..168.0.0/16"
sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

sudo kubeadm init  --control-plane-endpoint="$LOAD_BALANCER:6443" --upload-certs --apiserver-advertise-address=$MASTER_NODE --pod-network-cidr=$POD_CIDR
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Install Calico Network Plugin
curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml

# Install Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

# Install Kubernetes Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml


sudo systemctl restart systemd-resolved
sudo swapoff -a && sudo systemctl daemon-reload && sudo systemctl restart kubelet

# Tails this to worker node
# sudo kubectl taint nodes --all node-role.kubernetes.io/master-
