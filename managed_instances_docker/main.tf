// Configure the Google Cloud provider

provider "google" {
  credentials = file("usersumit.json")
  project     = "cloud-data-migrator"
  region      = "us-west1"
}

// Create an Instance Template

resource "google_compute_instance_template" "bunny-template" {
  name        = "bunny-template"
  description = "This template is used to create app server instances."

  tags = ["http-server", "https-server"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "n1-standard-1"
  can_ip_forward       = true

  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "projects/cloud-data-migrator/global/networks/default"
    access_config {
      network_tier = "STANDARD"

    }
    }

  metadata_startup_script = "gs://junk_bucket/start-up-script.sh"

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    email  = ""
  }

}

// Create an Instance Group

resource "google_compute_instance_group_manager" "bunny-instance-group" {
  name               = "bunny-instance-group"
  instance_template  = "${google_compute_instance_template.bunny-template.self_link}"
  base_instance_name = "instance-group-manager"
  zone               = "us-central1-f"
  target_size = "2"
}

resource "google_compute_autoscaler" "bunny-autoscaler" {
  name   = "bunny-autoscaler"
  zone   = "us-central1-f"
  target = "${google_compute_instance_group_manager.bunny-instance-group.self_link}"

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

