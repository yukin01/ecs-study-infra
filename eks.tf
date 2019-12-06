resource "aws_eks_cluster" "main" {
  name = "kinjo-cluster"
  role_arn = ""

  vpc_config {
    subnet_ids = [
      aws_subnet.private["private-a"].id,
      aws_subnet.private["private-c"].id
      # aws_subnet.public["public-a"].id,
      # aws_subnet.public["public-c"].id
    ]
    security_group_ids = [
      aws_security_group.api.id
    ]
  }
}