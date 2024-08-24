variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_cluster_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS cluster"
  type        = string
}

variable "eks_worker_node_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS worker nodes"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the EKS cluster"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.23"  # Set your desired Kubernetes version here
}

variable "desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
