output "dev_ip" {
  value = google_compute_instance.dev_vm.network_interface[0].access_config[0].nat_ip
}

output "prod_ip" {
  value = google_compute_instance.prod_vm.network_interface[0].access_config[0].nat_ip
}

output "username" {
  value = "your-vm-username"
}