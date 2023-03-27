resource "aws_eks_node_group" "nd_grp" {
    cluster_name = aws_eks_cluster.eks_test.name
    node_group_name = "nd_grp"
    subnet_ids = [aws_subnet.Public_subnet1.id,aws_subnet.Public_subnet2.id]
    scaling_config {
      desired_size = 2
      max_size = 4
      min_size = 1
    }
    node_role_arn = aws_iam_role.nd_grp_role.arn
    instance_types = ["t2.micro"]
    remote_access {
      ec2_ssh_key = "us-west"
      source_security_group_ids = [aws_security_group.allow_ssh.id]
    }
  
}

resource "aws_iam_role" "nd_grp_role" {
    name = "eks_ndgrp_role"
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

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nd_grp_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nd_grp_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nd_grp_role.name
}