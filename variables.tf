# Stack Name
variable "cluster_name" {
  type = string
}

# Worker Node instance size
variable "instance_size" {
  type = string
}

# Region
variable "region" {}

# Environment
variable "env" {
  type    = string
  default = "Prod"
}

# Type
variable "type" {
  type    = string
  default = "Production"
}

# Instance count
variable "instance_count" {
  type = string
}

# AMI ID
variable "ami_id" {
  type = string
}

# Cluster Version
variable "cluster_version" {
  type = string
}

# VPC CNI Version
variable "vpc-cni-version" {
  type        = string
  description = "VPC CNI Version"
}

# Kube Proxy Version
variable "kube-proxy-version" {
  type        = string
  description = "Kube Proxy Version"
}

# EC2 for EKS client
variable "ec2_ami_id" {
  description = "AMI ID for EC2 client"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type for EKS client"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name to access EC2"
  type        = string
}
