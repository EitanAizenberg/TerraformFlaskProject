terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "neural-virtue-393306"  # Your GCP Project ID
  region  = "europe-west1-b"         # Change this to your desired region
}

resource "google_container_cluster" "example" {
  name     = "flask-app-cluster"
  location = "europe-west1"  # Change this to your desired region
  initial_node_count = 1  # Specify the initial node count here
}

resource "null_resource" "apply_manifests" {
  triggers = {
    cluster_name = google_container_cluster.example.name
  }

  provisioner "local-exec" {
    command = <<-EOT
      gcloud container clusters get-credentials flask-app-cluster --location europe-west1 &&
      kubectl apply -f /home/eitan/learn-terraform-docker-container/deployment.yaml &&
      kubectl apply -f /home/eitan/learn-terraform-docker-container/service.yaml
    EOT
  }
}
