terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.53.0"
    }
  }

  backend "gcs" {
    bucket = "my-bucket-name"
    prefix = "terraform/state"

  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "instances" {
  source = "./modules/instances"
}

module "storage" {
  source = "./modules/storage"
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "6.0.0"
  project_id   = var.project_id
  network_name = "my-network"
  routing_mode = "GLOBAL"
  subnets = [
    {
      subnet-1 = {
        subnet_name = "subnet-1"
        subnet_ip   = "10.10.10.0/24"
      }
    },
    {
      subnet-2 = {
        subnet_name = "subnet-2"
        subnet_ip   = "10.10.20.0/24"
      }
    }
  ]
}

resource "google_compute_firewall" "my-firewall" {
    name    = "my-firewall"
    network = "projects/${var.project_id}/global/networks/my-network"
    
    allow {
        protocol = "tcp"
        ports    = ["80"]
    }
    
    source_tags = ["web"]
	source_ranges = ["0.0.0.0/0"]
  
}
