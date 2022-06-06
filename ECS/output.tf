output "ecr_repository" {
  value = aws_ecr_repository.ecr_repository.id
}

output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_cluster.id
}

