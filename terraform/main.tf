# VPC
resource "google_compute_network" "vpc" {
  name                    = "multi-env-vpc"
  auto_create_subnetworks = true
}

# Firewall
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# DEV VM
resource "google_compute_instance" "dev_vm" {
  name         = "dev-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = google_compute_network.vpc.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update
    apt install -y nginx
    echo "Hello from DEV Environment!!!" > /var/www/html/index.html
    systemctl start nginx
  EOF
}

# PROD VM
resource "google_compute_instance" "prod_vm" {
  name         = "prod-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = google_compute_network.vpc.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update
    apt install -y nginx
    echo "Hello from PROD Environment!!!" > /var/www/html/index.html
    systemctl start nginx
  EOF
}