output "cluster_role_name" {
  description = "Name of the EKS cluster IAM role."
  value       = module.eks_iam.cluster_role_name
}

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role."
  value       = module.eks_iam.cluster_role_arn
}

output "cluster_role_policy_arns" {
  description = "ARNs of the IAM policies attached to the EKS cluster role."
  value       = module.eks_iam.cluster_role_policy_arns
}

output "node_group_role_name" {
  description = "Name of the EKS node group IAM role."
  value       = module.eks_iam.node_group_role_name
}

output "node_group_role_arn" {
  description = "ARN of the EKS node group IAM role."
  value       = module.eks_iam.node_group_role_arn
}

output "node_group_instance_profile_name" {
  description = "Name of the EKS node group instance profile."
  value       = module.eks_iam.node_group_instance_profile_name
}

output "node_group_role_policy_arns" {
  description = "ARNs of the IAM policies attached to the EKS node group role."
  value       = module.eks_iam.node_group_role_policy_arns
}
