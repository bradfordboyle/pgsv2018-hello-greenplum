resource "google_compute_instance" "singlenode" {
    name = "greenplum-singlenode"
    machine_type = "n1-standard-4"
    zone = "${var.zone}"

    boot_disk {
        initialize_params {
            image = "ubuntu-1604-lts"
        }
    }

    network_interface {
        network = "default"
        access_config {}
    }

    labels {
        terraform = true
    }
}
