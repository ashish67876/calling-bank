terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.63.1"
   }
 }
}


# Module for vpc
module "vpc" {
  source               = "../modules/vpc"
  name_prefix          = "prod"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  tags = {
  Environment = "production"
  Project     = "my-eks-cluster"
}
}

#Module for iam

module "iam" {
  source = "../modules/IAM"
  name_prefix = "microservices"
  tags = {
    Environment = "Production"
    Project = "eks-cluster-role"
  }

}

# module for security group
module "security_group" {
  source = "../modules/security-group"
  name_prefix = "prod"
  vpc_id = module.vpc.vpc_id
  tags = {
  Environment = "production"
  Project     = "my-eks-cluster"
}
}
/***
module "eks_cluster" {
  source = "../modules/eks"

  cluster_name        = "prod-eks-cluster"
  eks_cluster_role_arn   = module.IAM.eks_cluster_role_arn
  eks_worker_node_role_arn     = module.IAM.eks_worker_node_role_arn
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.security-group.eks_worker_sg_id]  # Ensure this matches your security group output
  kubernetes_version  = "1.28"
  desired_capacity    = 3
  max_size            = 6
  min_size            = 1
  tags = {
        Environment = "production"
        Project     = "my-eks-cluster"
}
}
***/
  

