resource "aws_instance" "jumper_box" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  key_name              = var.key_pair
  vpc_security_group_ids = [aws_security_group.jumper_box_sg.id]
  tags = {
    Name = "jumper-box-${var.environment_name}-1"
  }
}


resource "aws_instance" "k8_control_plane" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet1.id 
  key_name              = var.key_pair
  vpc_security_group_ids = [aws_security_group.k8_master_sg.id]  
  
  user_data = base64encode(<<EOF
#!/bin/bash -xe
exec > /tmp/k8_control_output.log 2>&1 
sudo apt-get update -y
/home/dikodin/Documents/Devops/project/ha_odoo-18.0_deployment/k8/scripts/common.sh
sleep 5
/home/dikodin/Documents/Devops/project/ha_odoo-18.0_deployment/k8/scripts/master.sh
sleep 5
EOF
  )

  tags = {
    Name = "k8-master-${var.environment_name}-1"
  }
}

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
