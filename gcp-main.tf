resource "google_artifact_registry_repository" "my-repo" {
  location = var.region
  repository_id = "labdevops"
  description = "Imagens Docker"
  format = "DOCKER"
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = "me"
  instance = google_sql_database_instance.main.name
  password = "changeme"
}

resource "google_secret_manager_secret" "db-password" {
  provider = google-beta

  secret_id = "db-password"

  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "db-password-1" {
  provider = google-beta

  secret      = google_secret_manager_secret.db-password.id
  secret_data = "changeme"
}