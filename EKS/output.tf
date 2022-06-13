output "eks-cluster" {
    value = aws_eks_cluster.eks-cluster
}

output "node-group" {
    value = aws_eks_node_group.node-group.id
}
