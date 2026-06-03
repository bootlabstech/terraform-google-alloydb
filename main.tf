resource "random_password" "alloydb_password" {
  length           = 24
  special          = true
  override_special = "!@#$%^&*()-_=+"
}

resource "google_secret_manager_secret" "alloydb_password" {
  secret_id = "${var.cluster_id}-db-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "alloydb_password" {
  secret = google_secret_manager_secret.alloydb_password.id
  #   secret_data = random_password.alloydb_password.result
  secret_data_wo         = random_password.alloydb_password.result
  secret_data_wo_version = 1

}

resource "google_alloydb_cluster" "cluster" {
  cluster_id = var.cluster_id
  location   = var.region

  network_config {
    network = var.network_self_link
  }

  initial_user {
    user     = var.db_user
    password = random_password.alloydb_password.result
  }

  database_version = var.database_version

  automated_backup_policy {
    enabled = true

    weekly_schedule {
      days_of_week = ["MONDAY"]

      start_times {
        hours   = 2
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }

    quantity_based_retention {
      count = 7
    }
  }

  labels = {
    environment = var.environment
  }
}

resource "google_alloydb_instance" "primary" {
  cluster           = google_alloydb_cluster.cluster.name
  instance_id       = "${var.cluster_id}-primary"
  instance_type     = "PRIMARY"
  availability_type = var.availability_type


  machine_config {
    cpu_count = var.primary_cpu_count

  }

  depends_on = [
    google_alloydb_cluster.cluster
  ]
}

resource "google_alloydb_instance" "read_pool" {
  count             = var.create_read_pool ? 1 : 0
  cluster           = google_alloydb_cluster.cluster.name
  instance_id       = "${var.cluster_id}-readpool"
  instance_type     = "READ_POOL"
  availability_type = var.availability_type

  machine_config {
    cpu_count = var.read_pool_cpu_count

  }

  read_pool_config {
    node_count = var.read_pool_node_count

  }

  depends_on = [
    google_alloydb_instance.primary
  ]
}