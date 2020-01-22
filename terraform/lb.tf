resource "google_compute_instance_group" "appgroup" {
  name = "${var.name_app}-group"
  zone = var.zone

  instances = [for i in google_compute_instance.app.*.self_link : i]

  named_port {
    name = var.instance_group_name_port
    port = var.instance_group_port
  }
}

resource "google_compute_backend_service" "appbackend" {
  name = "${var.name_app}-backend"

  backend {
    group = google_compute_instance_group.appgroup.self_link
  }

  health_checks = [
    "${google_compute_http_health_check.apphealthcheck.self_link}",
  ]
}

resource "google_compute_http_health_check" "apphealthcheck" {
  name               = "${var.name_app}-health-check"
  check_interval_sec = var.hc_check_interval_sec
  timeout_sec        = var.hc_timeout_sec
  port               = var.health_check_port
}

resource "google_compute_url_map" "appurlmap" {
  name            = "${var.name_app}-url-map"
  default_service = google_compute_backend_service.appbackend.self_link
}

resource "google_compute_target_http_proxy" "apphttpproxy" {
  name    = "${var.name_app}-proxy"
  url_map = google_compute_url_map.appurlmap.self_link
}

resource "google_compute_global_address" "applbaddress" {
  name = "${var.name_app}-lb-address"
}

resource "google_compute_global_forwarding_rule" "applbforwardingrule" {
  name       = "${var.name_app}-lb-forwarding-rule"
  target     = google_compute_target_http_proxy.apphttpproxy.self_link
  ip_address = google_compute_global_address.applbaddress.address
  port_range = var.forwarding_rule_port_range
}
