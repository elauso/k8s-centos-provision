resource "kubernetes_service" "traefik-service" {
  metadata {
    name = "traefik-ingress-service"
    namespace = "kube-system"
  }
  spec {
    selector = {
      k8s-app = "traefik-ingress-lb"
    }
    port {
      protocol = "TCP"
      port = "80"
      target_port = "${var.traefik_http_port}"
      name = "web"
    }
    port {
      protocol = "TCP"
      port = "8080"
      target_port = "${var.traefik_admin_port}"
      name = "admin"
    }
    type = "NodePort"
  }
}

resource "kubernetes_daemonset" "traefik-daemonset" {
  metadata {
    name      = "traefik-ingress-controller"
    namespace = "kube-system"
    labels = {
      k8s-app = "traefik-ingress-lb"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "traefik-ingress-lb"
        name = "traefik-ingress-lb"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "traefik-ingress-lb"
          name = "traefik-ingress-lb"
        }
      }

      spec {
        service_account_name = "traefik-ingress-controller"
        termination_grace_period_seconds = 60
        container {
          image = "${var.traefik_image}"
          name  = "traefik-ingress-lb"

          port {
              name = "http"
              container_port = 80
              host_port = "${var.traefik_http_port}"
          }

          port {
              name = "admin"
              container_port = 8080
              host_port = "${var.traefik_admin_port}"
          }

          security_context {
              capabilities {
                  drop = ["ALL"]
                  add = ["NET_BIND_SERVICE"]
              }
          }

          args = ["--api", "--kubernetes", "--logLevel=INFO"]
        }
      }
    }
  }
}

resource "kubernetes_service_account" "traefik-service-account" {
  metadata {
    name = "traefik-ingress-controller"
    namespace = "kube-system"
  }
}
