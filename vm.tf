locals {
  name = "demo-vm"
}

resource "google_service_account" "vm_sa" {
  account_id   = "${local.name}-sa"
  display_name = "SA for VM Instance ${local.name}"
}

resource "google_compute_instance" "dev_vm" {
  name         = local.name
  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2404-lts-amd64"
    }
  }
  network_interface {
    network    = "default"
    subnetwork = "default"
    # No "access_config" means no external IP—internal only
  }
  metadata_startup_script = file("${path.module}/startup.sh")
  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_router" "vm_router" {
  name    = "${local.name}-vm-router"
  network = "default"
}

resource "google_compute_router_nat" "vm_nat" {
  name                               = "${local.name}-nat-config"
  router                             = google_compute_router.vm_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}