resource "aws_security_group" "eks-control-plane-sg" {
    name = var.name_prefix
    description = "EKS Control Plane security group"
    vpc_id = var.vpc_id
    tags = merge(
        var.tags,
        {
            Name = "${var.name_prefix}-eks-control-plan-sg"
        }
    ) 
}

# EKS Worker Nodes Security Group
resource "aws_security_group" "eks-worker-sg" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-eks-worker-sg"
    },
  )
}
# Allow worker nodes to communicate with the control plane
resource "aws_security_group_rule" "control_plane_to_worker" {
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    source_security_group_id = aws_security_group.eks-worker-sg.id
    security_group_id = aws_security_group.eks-control-plane-sg.id
}

# Allow communication from control plane to worker nodes
resource "aws_security_group_rule" "worker_to_control_plane" {
        type              = "egress"
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        source_security_group_id = aws_security_group.eks-worker-sg.id
        security_group_id = aws_security_group.eks-control-plane-sg.id    
}
# Allow inbound traffic to worker nodes from the control plane on ports 1025-65535 (Kubernetes communication)
resource "aws_security_group_rule" "worker_nodes_ingress" {
        type              = "ingress"
        from_port         = 1025
        to_port           = 65535
        protocol          = "tcp"
        source_security_group_id = aws_security_group.eks-control-plane-sg.id
        security_group_id = aws_security_group.eks-worker-sg.id    
}
# Allow nodes to communicate with each other (node-to-node traffic)
resource "aws_security_group_rule" "node_to_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  source_security_group_id = aws_security_group.eks-worker-sg.id
  security_group_id = aws_security_group.eks-worker-sg.id
}
# Allow internet access from worker nodes (for updates, pulling images, etc.)
resource "aws_security_group_rule" "worker_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-worker-sg.id
}
