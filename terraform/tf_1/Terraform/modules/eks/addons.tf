/* "aws eks list-addons --cluster-name node_do_cluster" Para listar os nomes dos addons (addons_name) */
resource "aws_eks_addon" "aws-ebs-csi-driver" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name   = "aws-ebs-csi-driver"
}

resource "aws_eks_addon" "vpc-cni" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube-proxy" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "coredns" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name   = "coredns"
}