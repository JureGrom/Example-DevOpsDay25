resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
  }
  deletion_protection=false
}

resource "google_redis_instance" "cache" {
  name           = "memory-cache"
  memory_size_gb = 1

  lifecycle {
    prevent_destroy = false
  }
}
