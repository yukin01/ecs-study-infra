resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.prefix}-node-group"
  node_role_arn   = aws_iam_role.eks_worker.arn
  subnet_ids = [
    aws_subnet.private["private-a"].id,
    aws_subnet.private["private-c"].id,
    aws_subnet.public["public-a"].id,
    aws_subnet.public["public-c"].id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_worker_cni_policy,
    aws_iam_role_policy_attachment.eks_worker_ecr_policy
  ]
}

data "aws_iam_policy_document" "eks_node_group" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_worker" {
  name               = "${var.prefix}-eks-worker-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group.json
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker.name
}