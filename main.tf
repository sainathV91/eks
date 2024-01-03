provider "aws" {
  access_key = "AKIAUWHF2O344WA5NVP2"
  secret_key = "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"
  region     = "us-east-2"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "terraform_eks"
  version  = "1.28"
  /*role_arn = aws_iam_role.eks_cluster_role.arn*/
  role_arn = "arn:aws:iam::322604529401:role/eksClusterRole"

  vpc_config {
    subnet_ids = ["subnet-0d750807f1129064b", "subnet-017d26d831c71cbb7", "subnet-04bc3799bc65941b0"]
  }

  /*depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]*/
}

/*resource "aws_iam_role" "eks_cluster_role" {
  name = "terraform-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}*/

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "terraform-node-group"
  node_role_arn   = "arn:aws:iam::322604529401:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
  subnet_ids      = aws_eks_cluster.my_cluster.vpc_config[0].subnet_ids
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  /*depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_policy,
  ]*/
}

