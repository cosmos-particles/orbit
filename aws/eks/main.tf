module "eks_iam" {
  source = "git::https://github.com/cosmos-particles/constellation.git//aws/eks?ref=main"

  cluster_name         = var.cluster_name
  cluster_role_name    = var.cluster_role_name
  node_group_role_name = var.node_group_role_name
  tags                 = var.tags
}
