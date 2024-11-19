#!/bin/bash -xe
exec > /tmp/script_output.log 2>&1 
sleep 10
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker.service
sudo apt-get update
sudo apt-get remove awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip -y
unzip awscliv2.zip
sudo sudo ./aws/install
aws --version

if [ "$github.head_ref" == "dev" ]; then
  AWS_ACCESS_KEY_ID=var.access_key_id
  AWS_SECRET_ACCESS_KEY=var.secret_aws_access_key
  REGISTRY=var.REGISTRY
  REPOSITORY=var.REPOSITORY
  RUN_NUMBER=var.run_number
  export AWS_DEFAULT_REGION="us-east-1"
  aws sts get-caller-identity
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 681117582889.dkr.ecr.us-east-1.amazonaws.com
  # echo "${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}"
  # docker pull ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
  # docker run -itd --name odoo-erp-${RUN_NUMBER} -p 8069:8069 -e ODOO_USER=odoo  ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
  docker pull 681117582889.dkr.ecr.us-east-1.amazonaws.com/oriafo/ha_odoo-18.0_deployment:135
  docker run -itd --name odoo-erp-135 -p 8069:8069 -e ODOO_USER=odoo  681117582889.dkr.ecr.us-east-1.amazonaws.com/oriafo/ha_odoo-18.0_deployment:135
else
  export AWS_DEFAULT_REGION="us-east-1"
  aws sts get-caller-identity
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 375410234341.dkr.ecr.us-east-1.amazonaws.com
  docker pull ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
  docker run -itd --name odoo-erp-${RUN_NUMBER} -p 8069:8069 -e ODOO_USER=odoo  ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
fi





