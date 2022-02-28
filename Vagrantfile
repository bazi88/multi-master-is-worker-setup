NUM_MASTER_NODE=2
IP_NW="10.0.0."
IP_START=10
IP_MASTER_START=11

Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: <<-SHELL
        apt-get update -y
        echo "$IP_NW$((IP_MASTER_START))  master-node01" >> /etc/hosts
        echo "$IP_NW$((IP_MASTER_START+1))  master-node02" >> /etc/hosts
        echo "$IP_NW$((IP_MASTER_START+2))  master-node03" >> /etc/hosts
    SHELL

    config.vm.define "loadbalancer" do |loadbalancer|
        loadbalancer.vm.box = "bento/ubuntu-20.04"
        loadbalancer.vm.hostname = "loadbalancer"
        loadbalancer.vm.network "private_network", ip: IP_NW + "#{IP_START}"
        loadbalancer.vm.provider "virtualbox" do |vb|
            vb.name = "loadbalancer"
            vb.memory = 1024
            vb.cpus = 1
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end
        # loadbalancer.vm.provision "shell", path: "scripts/load_balancer.sh" 
    end



    # Kubernetes Slave Master Nodes
    (1..NUM_MASTER_NODE).each do |i|
        config.vm.define "master-node0#{i + 1}" do |masternode|
            masternode.vm.box = "bento/ubuntu-20.04"
            masternode.vm.hostname = "master-node0#{i + 1}"
            masternode.vm.network "private_network", ip: IP_NW + "#{IP_MASTER_START + i}"
            masternode.vm.provider "virtualbox" do |vb|
                vb.name = "master-node0#{i + 1}"
                vb.memory = 4096
                vb.cpus = 4
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            end
            # masternode.vm.provision "shell", path: "scripts/common.sh"
        end 
    end


    # Kubernetes Root Master Nodes
    config.vm.define "master-node01" do |masternode|
        masternode.vm.box = "bento/ubuntu-20.04"
        masternode.vm.hostname = "master-node01"
        masternode.vm.network "private_network", ip: IP_NW + "11"
        masternode.vm.provider "virtualbox" do |vb|
            vb.name = "master-node01"
            vb.memory = 4096
            vb.cpus = 4
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end
        # masternode.vm.provision "shell", path: "scripts/common.sh"
        # masternode.vm.provision "shell", path: "scripts/root_master.sh"
    end
end