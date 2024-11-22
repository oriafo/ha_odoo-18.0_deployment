
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom_vpc-${var.environment_name}"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  # depends_on              = [aws_internet_gateway.gw]
  tags = {
    Name = "custom_pubsub1-${var.environment_name}"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  # depends_on              = [aws_internet_gateway.gw]
  tags = {
    Name = "custom_pubsub2-${var.environment_name}"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "custom_privsub1-${var.environment_name}"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "custom_privsub2-${var.environment_name}"
  }
}

resource "aws_subnet" "private_subnet_db1" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "custom_privdb1-${var.environment_name}"
  }
}

resource "aws_subnet" "private_subnet_db2" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "custom_privdb2-${var.environment_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw-${var.environment_name}"
  }
}

resource "aws_route_table" "custom_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "custom_rt-${var.environment_name}"
  }
}

resource "aws_route_table_association" "custom_rt1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.custom_rt.id
}

resource "aws_route_table_association" "custom_rt2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.custom_rt.id
}

# resource "aws_eip" "custom_lb1" {
#   # instance = aws_nat_gateway.custom_ngwl11.id
#   # domain   = "vpc"
#   depends_on = [aws_internet_gateway.gw]
#   tags = {
#     Name = "Nat1 EIP-${var.environment_name}"
#   }
# }

# resource "aws_nat_gateway" "custom_ngwl11" {
#   allocation_id = aws_eip.custom_lb1.id
#   subnet_id     = aws_subnet.public_subnet1.id

#   tags = {
#     Name = "NatgwL11-${var.environment_name}"
#   }
#   depends_on = [aws_internet_gateway.gw]
# }

# resource "aws_route_table" "custom_privl1_rt" {
#   vpc_id = aws_vpc.custom_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.custom_ngwl11.id
#   }
#   tags = {
#     Name = "priv_rt_l1-${var.environment_name}"
#   }
# }

# resource "aws_route_table_association" "privl2_rt1" {
#   subnet_id      = aws_subnet.private_subnet1.id
#   route_table_id = aws_route_table.custom_privl1_rt.id
# }

# resource "aws_eip" "custom_lb2" {
#   # instance = aws_nat_gateway.custom_ngwl12.id
#   # domain   = "vpc"
#   depends_on = [aws_internet_gateway.gw]
#   tags = {
#     Name = "Nat2 EIP-${var.environment_name}"
#   }
# }

# resource "aws_nat_gateway" "custom_ngwl12" {
#   allocation_id = aws_eip.custom_lb2.id
#   subnet_id     = aws_subnet.public_subnet2.id

#   tags = {
#     Name = "NatgwL12-${var.environment_name}"
#   }
#   depends_on = [aws_internet_gateway.gw]
# }

# resource "aws_route_table" "custom_privl2_rt" {
#   vpc_id = aws_vpc.custom_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.custom_ngwl12.id
#   }
#   tags = {
#     Name = "priv_rt_l2-${var.environment_name}"
#   }
# }

# resource "aws_route_table_association" "privl2_rt2" {
#   subnet_id      = aws_subnet.private_subnet2.id
#   route_table_id = aws_route_table.custom_privl2_rt.id
# }

# resource "aws_nat_gateway" "custom_ngwl21" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.private_subnet_db1.id
#   tags = {
#     Name = "NatgwL21-${var.environment_name}"
#   }
# }

# resource "aws_route_table" "custom_privl21_rt" {
#   vpc_id = aws_vpc.custom_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.custom_ngwl21.id
#   }
#   tags = {
#     Name = "priv_rt_l21-${var.environment_name}"
#   }
# }

# resource "aws_route_table_association" "privl21_rt21" {
#   subnet_id      = aws_subnet.private_subnet_db1.id
#   route_table_id = aws_route_table.custom_privl21_rt.id
# }

# resource "aws_nat_gateway" "custom_ngwl22" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.private_subnet_db2.id
#   tags = {
#     Name = "NatgwL22-${var.environment_name}"
#   }
# }

# resource "aws_route_table" "custom_privl22_rt" {
#   vpc_id = aws_vpc.custom_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.custom_ngwl22.id
#   }
#   tags = {
#     Name = "priv_rt_l22-${var.environment_name}"
#   }
# }

# resource "aws_route_table_association" "privl22_rt22" {
#   subnet_id      = aws_subnet.private_subnet_db2.id
#   route_table_id = aws_route_table.custom_privl22_rt.id
# }


# resource "aws_lb" "custom_lb" {
#   name               = "${trimspace(var.environment_name)}-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.instances.id]
#   subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

#   enable_deletion_protection = false

#   tags = {
#     Environment = "LB-${var.environment_name}"
#   }
# }

# resource "aws_lb_target_group" "lb_tg" {
#   name        = "${trimspace(var.environment_name)}-lb-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "instance"
#   depends_on  = [aws_lb.custom_lb]
#   vpc_id      = aws_vpc.custom_vpc.id

#   health_check {
#     path                = "/"
#     port                = 80
#     protocol            = "HTTP"
#     interval            = 45
#     timeout             = 40
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     matcher             = "200"
#   }

#   tags = {
#     Environment = "tg-${var.environment_name}"
#   }
# }

# resource "aws_lb_listener" "lb-lis" {
#   load_balancer_arn = aws_lb.custom_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_tg.arn
#   }
# }

# resource "aws_lb_listener_rule" "lb_lis_rules" {
#   listener_arn = aws_lb_listener.lb-lis.arn
#   priority     = 1

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }

#   tags = {
#     Environment = "lb_lis_rules-${var.environment_name}"
#   }
# }

# Create a security group for instances
resource "aws_security_group" "instances" {
  name        = "${trimspace(var.environment_name)}-instances-sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1   # -1 means any ICMP type
    to_port     = -1   # -1 means any ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from anywhere (0.0.0.0/0)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# # Launch Template
# resource "aws_launch_template" "custom_lt" {
#   name_prefix   = "${trimspace(var.app_name)}_launch_template"
#   image_id      = var.ami
#   # instance_type = var.environment_name == "production" ? var.instance_type : "t3.micro"
#   instance_type = "t3.micro"
#   key_name      = var.key_pair

#   monitoring {
#     enabled = true
#   }

#   user_data = base64encode(<<EOF
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
#   export AWS_ACCESS_KEY_ID="${var.access_key_id}"
#   export AWS_SECRET_ACCESS_KEY="${var.secret_aws_access_key}"
#   export AWS_DEFAULT_REGION="us-east-1"
#   export REGISTRY="${var.REGISTRY}"
#   export REPOSITORY="${var.REPOSITORY}"
#   export RUN_NUMBER="${var.run_number}"
#   aws sts get-caller-identity
#   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 681117582889.dkr.ecr.us-east-1.amazonaws.com
#   # echo "$REGISTRY/$REPOSITORY:$RUN_NUMBER"
#   docker pull 681117582889.dkr.ecr.us-east-1.amazonaws.com/oriafo/ha_odoo-18.0_deployment:163
#   docker run -itd --name odoo-erp-135 -p 8069:8069 -e ODOO_USER=odoo  681117582889.dkr.ecr.us-east-1.amazonaws.com/oriafo/ha_odoo-18.0_deployment:163
#   # docker pull $REGISTRY/$REPOSITORY:$RUN_NUMBER
#   # docker run -itd --name odoo-erp-$RUN_NUMBER -p 8069:8069 -e ODOO_USER=odoo  $REGISTRY/$REPOSITORY:$RUN_NUMBER
# else
#   export AWS_ACCESS_KEY_ID="${var.access_key_id}"
#   export AWS_SECRET_ACCESS_KEY="${var.secret_aws_access_key}"
#   export AWS_DEFAULT_REGION="us-east-1"
#   export REGISTRY="${var.REGISTRY}"
#   export REPOSITORY="${var.REPOSITORY}"
#   export RUN_NUMBER="${var.run_number}"
#   aws sts get-caller-identity
#   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 375410234341.dkr.ecr.us-east-1.amazonaws.com
#   docker pull $REGISTRY/$REPOSITORY:$RUN_NUMBER
#   docker run -itd --name odoo-erp-$RUN_NUMBER -p 8069:8069 -e ODOO_USER=odoo  $REGISTRY/$REPOSITORY:$RUN_NUMBER
# fi
# EOF
# )

# #   user_data = base64encode(templatefile("web.sh", {
# #     AWS_ACCESS_KEY_ID=var.access_key_id
# #     AWS_SECRET_ACCESS_KEY=var.secret_aws_access_key
# #     REGISTRY=var.REGISTRY
# #     REPOSITORY=var.REPOSITORY
# #     RUN_NUMBER=var.run_number
# #     }))

# #   tag_specifications {
# #     resource_type = "instance"
# #     tags = {
# #       Environment = var.environment_name
# #     }
# #   }
# # }


# # # Launch Template
# # resource "aws_launch_template" "custom_lt" {
# #   name_prefix   = "${trimspace(var.app_name)}_launch_template"
# #   image_id      = var.ami
# #   # instance_type = var.environment_name == "production" ? var.instance_type : "t3.micro"
# #   instance_type = "t3.micro"
# #   key_name      = var.key_pair

# #   monitoring {
# #     enabled = true
# #   }

# #   vpc_security_group_ids = [aws_security_group.instances.id]

# #   user_data = base64encode(<<EOF
# # #!/bin/bash -xe
# # sudo apt-get update -y
# # sudo apt upgrade -y
# # sudo apt-get install wget unzip -y
# # sudo apt-get install nginx -y
# # sudo ufw allow 'Nginx HTTP'
# # sudo ufw status
# # sudo systemctl enable nginx
# # sudo systemctl start nginx    
# # sudo systemctl status nginx
# # wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
# # sudo unzip -o 2137_barista_cafe.zip -d /var/www/html 
# # sudo cp -r /var/www/html/2137_barista_cafe/* /var/www/html
# # sudo nginx -s reload
# # EOF
# #   )

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Environment = "worker-node-${var.environment_name}"
#     }
#   }
#  }


# # Auto Scaling Group
# resource "aws_autoscaling_group" "custom_asg" {
#   desired_capacity = 1
#   max_size         = 2
#   min_size         = 1
#   vpc_zone_identifier = [
#     aws_subnet.private_subnet1.id, # Update with your public subnet IDs
#     aws_subnet.private_subnet2.id
#   ]
#   target_group_arns         = [aws_lb_target_group.lb_tg.arn]
#   health_check_type         = "ELB"
#   health_check_grace_period = 300

#   launch_template {
#     id      = aws_launch_template.custom_lt.id
#     version = "$Latest"
#   }

#   instance_refresh {
#     strategy = "Rolling"

#     preferences {
#       instance_warmup        = 300
#       min_healthy_percentage = 50
#       # max_healthy_percentage = 100
#     }

#     triggers = ["desired_capacity"]
#   }
#   # tags = [
#   #   {
#   #     key                 = "Name"
#   #     value               = "${var.app_name}-instance"
#   #     propagate_at_launch = true
#   #   },
#   #   {
#   #     key                 = "Environment"
#   #     value               = var.environment_name
#   #     propagate_at_launch = true
#   #   }
#   # ]
# }


resource "aws_security_group" "jumper_box_sg" {
  name        = "${trimspace(var.environment_name)}-jumper-box-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   ingress {
    from_port   = -1   # -1 means any ICMP type
    to_port     = -1   # -1 means any ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from anywhere (0.0.0.0/0)
  }

 ingress {
    from_port   = -1   # -1 means any ICMP type
    to_port     = -1   # -1 means any ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from anywhere (0.0.0.0/0)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}


resource "aws_security_group" "k8_master_sg" {
  name        = "${trimspace(var.environment_name)}-k8-master-sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id 

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1   # -1 means any ICMP type
    to_port     = -1   # -1 means any ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from anywhere (0.0.0.0/0)
  }

  ingress {

    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1   # -1 means any ICMP type
    to_port     = -1   # -1 means any ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from anywhere (0.0.0.0/0)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_security_group" "k8_worker_sg" {
  name        = "${trimspace(var.environment_name)}-k8-worker-sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id 


  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1   # -1 means any ICMP type
    to_port     = -1   # -1 means any ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from anywhere (0.0.0.0/0)
  }

  ingress {
    from_port   = 10256
    to_port     = 10256
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}


# #!/bin/bash -xe
# exec > /tmp/script_output.log 2>&1 
# sleep 10
# if [ github.head_ref == 'dev' ]; then
#   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 681117582889.dkr.ecr.us-east-1.amazonaws.com
#   docker pull $REGISTRY/$REPOSITORY:$run_number
#   docker run -itd --name odoo-erp-$run_number -p 8069:8069 -e ODOO_USER=odoo  $REGISTRY/$REPOSITORY:$run_number 
# else
#   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 375410234341.dkr.ecr.us-east-1.amazonaws.com
#   docker $REGISTRY/$REPOSITORY:run_number 
#   docker run -itd --name odoo-erp-$run_number  -p 8069:8069 -e ODOO_USER=odoo 3$REGISTRY/$REPOSITORY:$run_number 
# fi
# EOF
# )