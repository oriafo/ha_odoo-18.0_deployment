resource "aws_instance" "jumper_box" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
   key_name              = var.key_pair
  vpc_security_group_ids = [aws_security_group.jumper_box_sg.id]
  user_data = base64encode(<<EOF
  #!/usr/bin/expect -f
  exec > /tmp/script_output.log 2>&1 
  set timeout -1
  sleep 10
  sudo apt update
  sudo apt install -y curl ca-certificates gnupg
  curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo tee /etc/apt/trusted.gpg.d/pgadmin.asc
  echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/focal pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin.list
  sudo apt update
  sudo apt install -y pgadmin4
  expect "Enter master password:"
  send "OronaOgege1.\r"  # Replace with the password you want to use
  expect "Re-enter master password:"
  send "OronaOgege1.\r"  # Same password for confirmation
  expect eof
  pgadmin4
  EOF
  )
  tags = {
    Name = "jumper-box-${var.environment_name}-1"
  }
}

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
