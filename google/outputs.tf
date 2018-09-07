output "ip-address" {
    value = "${google_compute_instance.singlenode.network_interface.0.access_config.0.assigned_nat_ip}"
}