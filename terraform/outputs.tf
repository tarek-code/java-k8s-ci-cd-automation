output "control_plane_ip" {
  value = aws_instance.control_plane.public_ip
}

output "worker_ip" {
  value = aws_instance.worker.public_ip
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}
