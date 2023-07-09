## Create the EKS cluster
resource "aws_eks_cluster" "eks-cluster" {
  name = var.cluster-name
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role.eks-iam-role
  ]
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "${var.cluster-name}-worker-nodes-ng"
  node_role_arn   = aws_iam_role.worker-nodes-iam.arn
  subnet_ids      = var.subnet_ids
  instance_types = [ var.instance_types[0] ]
  #ssh_access { key_name = "devops-eks" }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = {
    "k8s.io/cluster-autoscaler/eks-${var.tag_environment}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "kubernetes.io/cluster/eks-${var.tag_environment}"= "owned"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

# resource "aws_key_pair" "ssh-keypair" {
#   key_name   = "devops-eks"
# }

