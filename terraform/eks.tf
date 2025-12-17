module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true
  cluster_version                = "1.34"

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  attach_cluster_primary_security_group = true

  # Defaults for all managed node groups
  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = ["t3.micro"]   # ✅ Free Tier eligible
    capacity_type  = "ON_DEMAND"    # ❌ Avoid SPOT issues
  }

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}
