resource "kubernetes_service_account" "traefik-service-account" {
  metadata {
    name = "${kubernetes_daemonset.traefik_daemonset.metadata.0.name}"
    namespace = "${kubernetes_daemonset.traefik_daemonset.metadata.0.namespace}"
  }
}

resource "kubernetes_daemonset" "traefik_daemonset" {
  metadata {
    name      = "traefik-ingress-controller"
    namespace = "kube-system"
    labels = {
      k8s-app = "${kubernetes_daemonset.traefik_daemonset.spec.container.0.namespace}"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "${kubernetes_daemonset.traefik_daemonset.spec.container.0.namespace}"
        name = "${kubernetes_daemonset.traefik_daemonset.spec.container.0.namespace}"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "${kubernetes_daemonset.traefik_daemonset.spec.container.0.namespace}"
          name = "${kubernetes_daemonset.traefik_daemonset.spec.container.0.namespace}"
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

resource "kubernetes_service" "traefik-service" {
  metadata {
    name = "traefik-ingress-service"
    namespace = "${kubernetes_daemonset.traefik_daemonset.metadata.0.namespace}"
  }
  spec {
    selector = {
      k8s-app = "${kubernetes_daemonset.traefik_daemonset.spec.container.0.namespace}"
    }
    port {
      protocol = "TCP"
      port = "${var.traefik_http_port}"
      name = "web"
    }
    port {
      protocol = "TCP"
      port = "${var.traefik_admin_port}"
      name = "admin"
    }
  }
}
