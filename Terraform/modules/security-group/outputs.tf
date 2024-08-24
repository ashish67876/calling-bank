output "eks_control_plane_sg_id" {
  description = "ID of the EKS Control Plane security group"
  value       = aws_security_group.eks-control-plane-sg.id
}

output "eks_worker_sg_id" {
  description = "ID of the EKS Worker Nodes security group"
  value       = aws_security_group.eks-worker-sg.id
}
