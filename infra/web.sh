#!/bin/bash -xe
exec > /tmp/script_output.log 2>&1 
sleep 10
sudo apt update
sudo apt install wget unzip -y
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo ufw status
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
cd /tmp    #This next command will fall because, you might not have the permissiont o write to the file system, hence you are using the /tmp directory where you dont need such permission
wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
# if [ -f "2137_barista_cafe.zip" ]; then
sudo mkdir -p /var/www/html
sudo unzip 2137_barista_cafe.zip -d /var/www/html
sudo cp -r /var/www/html/2137_barista_cafe/* /var/www/html
sudo nginx -s reload
sudo systemctl restart nginx
# else
    # echo "Something went wrong while downloading the file"
# fi


