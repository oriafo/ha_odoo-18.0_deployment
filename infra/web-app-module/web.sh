# #!/bin/bash -xe
# exec > /tmp/script_output.log 2>&1 
# sleep 10
# sudo apt-get update -y
# sudo apt-get install -y ca-certificates curl
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update -y
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo systemctl status docker.service
# sudo apt-get update
# sudo apt-get remove awscli -y
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# sudo apt-get install unzip -y
# unzip awscliv2.zip
# sudo sudo ./aws/install
# aws --version

# if [ "$github.head_ref" == "dev" ]; then
#   export AWS_DEFAULT_REGION="us-east-1"
#   aws sts get-caller-identity
#   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 681117582889.dkr.ecr.us-east-1.amazonaws.com
#   echo "${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}"
#   docker pull ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
#   docker run -itd --name odoo-erp-${RUN_NUMBER} -p 8069:8069 -e ODOO_USER=odoo  ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
# else
#   export AWS_DEFAULT_REGION="us-east-1"
#   aws sts get-caller-identity
#   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 375410234341.dkr.ecr.us-east-1.amazonaws.com
#   docker pull ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}
#   docker run -itd --name odoo-erp-${RUN_NUMBER} -p 8069:8069 -e ODOO_USER=odoo  ${REGISTRY}/${REPOSITORY}:${RUN_NUMBER}




# # #!/bin/bash -xe
# # exec > /tmp/script_output.log 2>&1 
# # sleep 10
# # sudo apt update
# # sudo apt install wget unzip -y
# # sudo apt install nginx -y
# # sudo ufw allow 'Nginx HTTP'
# # sudo ufw status
# # sudo systemctl start nginx
# # sudo systemctl enable nginx
# # sudo systemctl status nginx
# # cd /tmp    #This next command will fall because, you might not have the permissiont o write to the file system, hence you are using the /tmp directory where you dont need such permission
# # wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
# # # if [ -f "2137_barista_cafe.zip" ]; then
# # sudo mkdir -p /var/www/html
# # sudo unzip 2137_barista_cafe.zip -d /var/www/html
# # sudo cp -r /var/www/html/2137_barista_cafe/* /var/www/html
# # sudo nginx -s reload
# # sudo systemctl restart nginx
# # # else
# #     # echo "Something went wrong while downloading the file"
# # # fi


