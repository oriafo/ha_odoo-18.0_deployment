resource "aws_instance" "jumper_box" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet1.id
  key_name              = var.key_pair
  vpc_security_group_ids = [aws_security_group.jumper_box_sg.id]
  tags = {
    Name = "jumper-box-${var.environment_name}-1"
  }
}


# resource "aws_instance" "k8_control_plane" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.private_subnet1.id 
#   key_name              = var.key_pair
#   vpc_security_group_ids = [aws_security_group.k8_master_sg.id]
#   depends_on              = [aws_nat_gateway.custom_ngwl11, aws_nat_gateway.custom_ngwl12]
  
  
#   user_data = base64encode(<<EOP
# #!/bin/bash -xe

# exec > /tmp/k8_control_output.log 2>&1 
# sudo apt-get update -y


# set -euxo pipefail

# # Kubernetes Variable Declaration
# KUBERNETES_VERSION="v1.30"
# CRIO_VERSION="v1.30"
# KUBERNETES_INSTALL_VERSION="1.30.0-1.1"

# # Disable swap
# sudo swapoff -a

# # Keeps the swap off during reboot
# (crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
# sudo apt-get update -y

# # Create the .conf file to load the modules at bootup
# cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf 
# overlay
# br_netfilter
# EOF

# sudo modprobe overlay
# sudo modprobe br_netfilter

# # Sysctl params required by setup, params persist across reboots
# cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-iptables  = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# net.ipv4.ip_forward                 = 1
# EOF

# # Apply sysctl params without reboot
# sudo sysctl --system

# sudo apt-get update -y
# sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# # Install CRI-O Runtime
# sudo apt-get update -y
# sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates

# curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
#     sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

# echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
#     sudo tee /etc/apt/sources.list.d/cri-o.list

# sudo apt-get update -y
# sudo apt-get install -y cri-o

# sudo systemctl daemon-reload
# sudo systemctl enable crio --now
# sudo systemctl start crio.service

# echo "CRI runtime installed successfully"

# # Install kubelet, kubectl, and kubeadm
# curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
#   sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
#   sudo tee /etc/apt/sources.list.d/kubernetes.list

# sudo apt-get update -y
# sudo apt-get install -y kubelet="$KUBERNETES_INSTALL_VERSION" kubectl="$KUBERNETES_INSTALL_VERSION" kubeadm="$KUBERNETES_INSTALL_VERSION"

# # Prevent automatic updates for kubelet, kubeadm, and kubectl
# sudo apt-mark hold kubelet kubeadm kubectl

# sudo apt-get update -y

# # Install jq, a command-line JSON processor
# sudo apt-get install -y jq

# # Retrieve the local IP address of the eth0 interface and set it for kubelet
# local_ip=$(ip --json addr | jq -r 'map(select(.ifname | test("ens|enX"))) | .[0].addr_info[] | select(.family == "inet") | .local')
# # local_ip="$(ip --json addr show ens5 || enX0 | jq -r '.[0].addr_info[] | select(.family == "inet") | .local')"


# # Write the local IP address to the kubelet default configuration file
# cat > /etc/default/kubelet << EOF
# KUBELET_EXTRA_ARGS=--node-ip=$local_ip
# EOF




# set -euxo pipefail

# # If you need public access to API server using the servers Public IP adress, change PUBLIC_IP_ACCESS to true.

# PUBLIC_IP_ACCESS="false"
# NODENAME=$(hostname -s)
# POD_CIDR="192.168.0.0/16"

# # Pull required images

# sudo kubeadm config images pull

# # Initialize kubeadm based on PUBLIC_IP_ACCESS

# if [[ "$PUBLIC_IP_ACCESS" == "false" ]]; then
    
#     MASTER_PRIVATE_IP=$(ip addr show ens5 | awk '/inet / {print $2}' | cut -d/ -f1)
#     sudo kubeadm init --apiserver-advertise-address="$MASTER_PRIVATE_IP" --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap

# elif [[ "$PUBLIC_IP_ACCESS" == "true" ]]; then

#     MASTER_PUBLIC_IP=$(curl ifconfig.me && echo "")
#     sudo kubeadm init --control-plane-endpoint="$MASTER_PUBLIC_IP" --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap

# else
#     echo "Error: MASTER_PUBLIC_IP has an invalid value: $PUBLIC_IP_ACCESS"
#     exit 1
# fi

# export HOME=/home/ubuntu
# echo "The home directory is: $HOME"
# mkdir -p "$HOME"/.kube
# sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
# sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# EOP
#   )

#   tags = {
#     Name = "k8-master-${var.environment_name}-1"
#   }
# }

# "public_subnet1" "10.0.1.0/24"
# "public_subnet2" "10.0.2.0/24"
# "private_subnet1" "10.0.3.0/24"
# "private_subnet2" "10.0.4.0/24"
# "private_subnet_db1" "10.0.5.0/24"
# "private_subnet_db2" "10.0.6.0/24"

# resource "aws_instance" "instance_2" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public_subnet2.id
#   vpc_security_group_ids = [aws_security_group.instances.id]
#   user_data              = <<-EOF
#               #!/bin/bash
#               echo "Hello, World 2" > index.html
#               python3 -m http.server 8080 &
#               EOF
#   tags = {
#     Name = "web-app-${var.environment_name}-2"
#   }
# }
