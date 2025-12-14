# ------------------------------
# EKS Cluster
# ------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = local.name
  cluster_version = "1.30"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  enable_irsa = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
  default = {
    min_size     = 2
    desired_size = 2
    max_size     = 2

    disk_size      = 20
    instance_types = ["t3.small"]
  }
}


  tags = local.tags
}
