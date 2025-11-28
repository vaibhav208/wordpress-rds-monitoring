output "wordpress_public_ip" {
  value = module.wordpress.public_ip
}

output "grafana_url" {
  value = module.monitoring.grafana_url
}

output "prometheus_url" {
  value = module.monitoring.prometheus_url
}
