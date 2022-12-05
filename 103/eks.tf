resource "aws_eks_cluster" "ana" {
  name     = "ANA-WC-EKS-CLUSTER"
  role_arn = aws_iam_role.ana.arn

  vpc_config {
    subnet_ids = [data.terraform_remote_state.s3.outputs.subnet_pri_a_02_id, data.terraform_remote_state.s3.outputs.subnet_pri_c_02_id] #반드시NAT GW와 같은 곳
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.ana-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ana-AmazonEKSVPCResourceController,
  ]
}

#IAM role for eks
resource "aws_iam_role" "ana" {
  name = "ana-eks-cluster-role"

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

resource "aws_iam_role_policy_attachment" "ana-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ana.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "ana-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.ana.name
  }