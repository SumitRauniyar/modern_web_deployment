####### Configure the Google Cloud provider

provider "google" {
  credentials = file("usersumit.json")
  project     = "cloud-data-migrator"
  region      = "us-west1"
}

####################################################################


resource "google_project_service" "kubernetes" {
  project = "cloud-data-migrator"
  service = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_container_cluster" "kubernetes" {
  name               = "k8s-cluster"
  depends_on         = ["google_project_service.kubernetes"]
  initial_node_count = 1
  location           = "us-west1"

  master_auth {
    username = ""
    password = ""
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["network-cluster"]
  }
}