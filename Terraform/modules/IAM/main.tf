resource "aws_iam_role" "eks-cluster-role" {
    name = "${var.name_prefix}-eks-cluster-role"
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
  tags = merge(
    var.tags,
    {
        Name = "${var.name_prefix}-eks-cluster-role"
    }
  )  
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy-attachment" {
    role = aws_iam_role.eks-cluster-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#EKS worker node role
resource "aws_iam_role" "eks-worker-node-role" {
    name = "${var.name_prefix}-eks-worker-node-role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(
    var.tags,
    {
        Name = "${var.name_prefix}-eks-worker-node-role"
    }
  )  
}
#policy attachment with worker node
resource "aws_iam_role_policy_attachment" "eks-worker-node-role-attachment" {
    role = aws_iam_role.eks-worker-node-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks-ec2-container-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-node-role.name
}
resource "aws_iam_role_policy_attachment" "eks-CNI-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-node-role.name
}