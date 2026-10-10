variable "region" {
  description = "AWS region to deploy into. Set explicitly via terraform.tfvars - no default."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster these IAM resources belong to."
  type        = string
}

variable "cluster_role_name" {
  description = "Suffix appended after \"$${cluster_name}-\" to form the EKS cluster IAM role name. Defaults to \"cluster-role\" - override only if you need a different convention."
  type        = string
  default     = "cluster-role"
}

variable "node_group_role_name" {
  description = "Suffix appended after \"$${cluster_name}-\" to form the EKS node group IAM role name. Defaults to \"node-group-role\" - override only if you need a different convention."
  type        = string
  default     = "node-group-role"
}

variable "tags" {
  description = "Tags applied to all resources created by this configuration. Set explicitly via terraform.tfvars - no default."
  type        = map(string)
}
