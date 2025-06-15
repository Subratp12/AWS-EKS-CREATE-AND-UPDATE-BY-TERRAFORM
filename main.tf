
# Creating VPC
module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
  env          = var.env
  type         = var.type
}

# Creating security group
module "security_groups" {
  source       = "./modules/security-group"
  vpc_id       = module.vpc.vpc_id
  cluster_name = var.cluster_name
  env          = var.env
  type         = var.type
}

# Creating IAM resources
module "iam" {
  source = "./modules/iam"
}

# Creating EKS Cluster
module "eks" {
  source                = "./modules/eks"
  master_arn            = module.iam.master_arn
  worker_arn            = module.iam.worker_arn
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  env                   = var.env
  type                  = var.type
  eks_security_group_id = module.security_groups.eks_security_group_id
  instance_size         = var.instance_size
  cluster_name          = var.cluster_name
  worker_node_count     = var.instance_count
  image_id              = var.ami_id
  cluster_version       = var.cluster_version
  vpc-cni-version       = var.vpc-cni-version
  kube-proxy-version    = var.kube-proxy-version
}

resource "aws_instance" "eks_client" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = module.vpc.public_subnet_az1_id
  vpc_security_group_ids      = [module.security_groups.bastion_sg_id] # or your existing SG
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              yum update -y
              yum install -y curl tar unzip

              # Install kubectl
              curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mv ./kubectl /usr/local/bin
              kubectl version --short --client

              # Install eksctl
              curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
              mv /tmp/eksctl /usr/local/bin
              eksctl version
              EOF

  tags = {
    Name        = "${var.cluster_name}-eks-client"
    Environment = var.env
    Type        = var.type
  }
}
