terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.50.0"
        }
    }
}

provider "aws" {
    region= "ap-southeast-1"
}

#VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = { Name = "joel-eks-vpc"}
}

#Subnets
resource "aws_subnet" "public_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "joel-eks-public-a"
        "kubernetes.io/cluster/joel-eks" = "shared"
        "kubernetes.io/role/elb" = "1"
    }
}
resource "aws_subnet" "public_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-southeast-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "joel-eks-public-b"
        "kubernetes.io/cluster/joel-eks" = "shared"
        "kubernetes.io/role/elb" = "1"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = { Name = "joel-eks-igw" }
}

# Route Table
resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = { Name = "joel-eks-rt" }
}

resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "b" {
    subnet_id = aws_subnet.public_b.id
    route_table_id = aws_route_table.main.id
}

# IAM Role untuk EKS
resource "aws_iam_role" "eks_cluster" {
    name = "joel-eks-cluster-role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "eks.amazonaws.com"}
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.eks_cluster.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role untuk Node Group
resource "aws_iam_role" "eks_nodes" {
    name = "joel-eks-node-role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "ec2.amazonaws.com"}
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
    role = aws_iam_role.eks_nodes.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
    role = aws_iam_role.eks_nodes.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr" {
    role = aws_iam_role.eks_nodes.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
    name = "joel-eks"
    role_arn = aws_iam_role.eks_cluster.arn
    version = "1.31"

    vpc_config {
        subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]
        endpoint_public_access = true
    }
    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

#EKS Node Group
resource "aws_eks_node_group" "main" {
    cluster_name = aws_eks_cluster.main.name
    node_group_name = "joel-eks-nodes"
    node_role_arn = aws_iam_role.eks_nodes.arn
    subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    instance_types = ["t3.small"]

    scaling_config {
        desired_size = 1
        max_size = 2
        min_size = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_node,
        aws_iam_role_policy_attachment.eks_cni,
        aws_iam_role_policy_attachment.eks_ecr,
    ]
}