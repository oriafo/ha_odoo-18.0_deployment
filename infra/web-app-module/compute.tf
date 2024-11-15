# resource "aws_instance" "instance_1" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public_subnet1.id
#   vpc_security_group_ids = [aws_security_group.instances.id]
#   user_data              = base64encode(<<EOF
#      #!/bin/bash -xe
#         exec > /var/log/user-data.log 2>&1  # Log output to a file
#         sudo apt update
#         sudo apt install wget unzip -y
#         sudo apt install nginx -y
#         sudo ufw allow 'Nginx HTTP'
#         sudo ufw status
#         sudo systemctl enable nginx
#         sudo systemctl start nginx
#         sudo systemctl status nginx
#         wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
#         sudo unzip -o 2137_barista_cafe.zip -d /var/www/html 
#         sudo cp -r /var/www/html/2137_barista_cafe/* /var/www/html
#         sudo nginx -s reload
#      EOF
#   )
#   tags = {
#     Name = "web-app-${var.environment_name}-1"
#   }
# }

# # "public_subnet1" "10.0.1.0/24"
# # "public_subnet2" "10.0.2.0/24"
# # "private_subnet1" "10.0.3.0/24"
# # "private_subnet2" "10.0.4.0/24"
# # "private_subnet_db1" "10.0.5.0/24"
# # "private_subnet_db2" "10.0.6.0/24"

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
