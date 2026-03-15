variable "region" {
  description = "AWS Region"
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "github_repo" {
  description = "GitHub repo in format owner/repo"
}

# ECR
variable "ecr_repository_name" {
  description = "ECR repository name"
}

# EKS
variable "eks_cluster_name" {
  description = "EKS Cluster Name"
}

variable "eks_node_instance_types" {
  type = list(string)
}

variable "eks_node_desired_size" {
  description = "Desired node count"
}

variable "eks_node_min_size" {
  description = "Minimum node count"
}

variable "eks_node_max_size" {
  description = "Maximum node count"
}
