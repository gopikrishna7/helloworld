resource "aws_eks_cluster" "eks_test" {
    name = "eks_test"
    role_arn = aws_iam_role.eks_test_role.arn
    vpc_config {
      subnet_ids = [aws_subnet.Public_subnet1.id,aws_subnet.Public_subnet2.id]
      public_access_cidrs = ["0.0.0.0/0"]
    }

    depends_on = [
      aws_iam_role.eks_test_role,
      aws_iam_role_policy_attachment.test-AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.test-AmazonEKSVPCResourceController,
    ]

  
}

output "endpoint" {
  value = aws_eks_cluster.eks_test.endpoint
}

resource "aws_iam_role" "eks_test_role" {
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  
}

resource "aws_iam_role_policy_attachment" "test-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_test_role.name
  
}

resource "aws_iam_role_policy_attachment" "test-AmazonEKSVPCResourceController" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role = aws_iam_role.eks_test_role.name
  
}


# OIDCS