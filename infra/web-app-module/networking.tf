
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

resource "aws_eip" "custom_lb1" {
  # instance = aws_nat_gateway.custom_ngwl11.id
  # domain   = "vpc"
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "Nat1 EIP-${var.environment_name}"
  }
}

resource "aws_nat_gateway" "custom_ngwl11" {
  allocation_id = aws_eip.custom_lb1.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "NatgwL11-${var.environment_name}"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "custom_privl1_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_ngwl11.id
  }
  tags = {
    Name = "priv_rt_l1-${var.environment_name}"
  }
}

resource "aws_route_table_association" "privl2_rt1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.custom_privl1_rt.id
}

resource "aws_eip" "custom_lb2" {
  # instance = aws_nat_gateway.custom_ngwl12.id
  # domain   = "vpc"
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "Nat2 EIP-${var.environment_name}"
  }
}

resource "aws_nat_gateway" "custom_ngwl12" {
  allocation_id = aws_eip.custom_lb2.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = {
    Name = "NatgwL12-${var.environment_name}"
  }
  # depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "custom_privl2_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_ngwl12.id
  }
  tags = {
    Name = "priv_rt_l2-${var.environment_name}"
  }
}

resource "aws_route_table_association" "privl2_rt2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.custom_privl2_rt.id
}

resource "aws_nat_gateway" "custom_ngwl21" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet_db1.id
  tags = {
    Name = "NatgwL21-${var.environment_name}"
  }
}

resource "aws_route_table" "custom_privl21_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_ngwl21.id
  }
  tags = {
    Name = "priv_rt_l21-${var.environment_name}"
  }
}

resource "aws_route_table_association" "privl21_rt21" {
  subnet_id      = aws_subnet.private_subnet_db1.id
  route_table_id = aws_route_table.custom_privl21_rt.id
}

resource "aws_nat_gateway" "custom_ngwl22" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet_db2.id
  tags = {
    Name = "NatgwL22-${var.environment_name}"
  }
}

resource "aws_route_table" "custom_privl22_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_ngwl22.id
  }
  tags = {
    Name = "priv_rt_l22-${var.environment_name}"
  }
}

resource "aws_route_table_association" "privl22_rt22" {
  subnet_id      = aws_subnet.private_subnet_db2.id
  route_table_id = aws_route_table.custom_privl22_rt.id
}


resource "aws_lb" "custom_lb" {
  name               = "${trimspace(var.environment_name)}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instances.id]
  subnets            = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id] 

  enable_deletion_protection = false

  tags = {
    Environment = "LB-${var.environment_name}"
  }
}

resource "aws_lb_target_group" "lb_tg" {
  name        = "${trimspace(var.environment_name)}-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  depends_on  = [aws_lb.custom_lb]
  vpc_id      = aws_vpc.custom_vpc.id

  health_check {
    path                = "/*"
    port                = 80
    protocol            = "HTTP"
    interval            = 60
    timeout             = 50
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Environment = "tg-${var.environment_name}"
  }
}

# resource "aws_lb_target_group_attachment" "lb_tg_attach" {
#   target_group_arn = aws_lb_target_group.lb_tg.arn
#   target_id        = eks-worker-node_node_group-60ca5593-a9f6-02a5-62c5-4e8f5aba9f62.id
#   port             = 80
# }  

resource "aws_lb_listener" "lb-lis" {
  load_balancer_arn = aws_lb.custom_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

resource "aws_lb_listener_rule" "lb_lis_rules" {
  listener_arn = aws_lb_listener.lb-lis.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = {
    Environment = "lb_lis_rules-${var.environment_name}"
  }
}

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
    from_port   = 2379
    to_port     = 2380
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
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    # cidr_blocks = ["${data.http.public_ip.body}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10252
    to_port     = 10252
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
    from_port   = 443
    to_port     = 443
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





resource "aws_iam_role" "k8_control_plane_role" {
  name = "${trimspace(var.app_name)}_k8_control_plane_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8_control_plane_role_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8_control_plane_role.name
}

resource "aws_eks_cluster" "k8_cluster" {
  name     = "${trimspace(var.app_name)}_k8_control_plane"
  role_arn = aws_iam_role.k8_control_plane_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.k8_control_plane_role_AmazonEKSClusterPolicy
  ]
}





resource "aws_iam_role" "k8_node_group_role" {
  name = "${trimspace(var.app_name)}_k8_node_group_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "k8_node_group_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "k8_node_group_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "k8_node_group_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8_node_group_role.name
}


resource "aws_eks_node_group" "k8_node_group" {
  cluster_name    = aws_eks_cluster.k8_cluster.name
  node_group_name = "${trimspace(var.app_name)}_node_group"
  node_role_arn   = aws_iam_role.k8_node_group_role.arn
  subnet_ids      = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  instance_types  = ["t3.medium"]
  ami_type        = "AL2_x86_64"
  #ami_id          = var.ami
  # additional_security_groups = [aws_security_group.k8_worker_sg.id]

  remote_access {
    ec2_ssh_key     = var.key_pair
    source_security_group_ids = [aws_security_group.jumper_box_sg.id]
  }

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8_node_group_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8_node_group_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8_node_group_role-AmazonEC2ContainerRegistryReadOnly,
  ]

  #security_groups = [aws_security_group.k8_worker_sg.id]
}
