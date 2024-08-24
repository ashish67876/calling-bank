output "eks_cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM role"
  value = aws_iam_role.eks-cluster-role.arn
}

output "eks_worker_node_role_arn" {
  description = "ARN of the EKS Worker Node IAM role"
  value       = aws_iam_role.eks-worker-node-role.arn
}