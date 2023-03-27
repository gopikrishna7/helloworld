resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "EKS_VPC"
  }
}

resource "aws_subnet" "Public_subnet1" {
  vpc_id = aws_vpc.eks_vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.10.0/26"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Public1"
    "kubernetes.io/cluster/eks_test"= "shared"

  }
}

resource "aws_subnet" "Public_subnet2" {
  vpc_id = aws_vpc.eks_vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.14.0/26"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Public2"
    "kubernetes.io/cluster/eks_test"= "shared"
  }
}

resource "aws_internet_gateway" "igw_eks_vpc" {
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
      Name = "igw_eks_vpc"
    }
  
}

resource "aws_route_table" "Public_rt" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_eks_vpc.id
    }
    tags = {
      Name = "rt_public"
    }
  
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.Public_subnet1.id
    route_table_id = aws_route_table.Public_rt.id
  
}

resource "aws_route_table_association" "Public2" {
    subnet_id = aws_subnet.Public_subnet2.id
    route_table_id = aws_route_table.Public_rt.id
  
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "allow ssh inbound"
  vpc_id = aws_vpc.eks_vpc.id
  ingress {
    from_port = 20
    to_port = 23
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}