resource "kubernetes_service" "mysql-service" {
  metadata {
    name = "mysql-service"
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.mysql-deployment.metadata.0.labels.app}"
    }
    port {
      port        = 3306
      target_port = "${var.mysql_port}"
    }
    cluster_ip = "None"
  }
}

resource "kubernetes_deployment" "mysql-deployment" {
  metadata {
    name = "mysql-deployment"
    labels = {
      app = "mysql"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "mysql"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "${var.mysql_image}"
          
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value = "${var.mysql_root_password}" # move to k8s secret
          }

          port {
            name = "mysql"
            container_port = 3306
          }

          volume_mount {
            name = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-persistent-storage"
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.mysql-pv-claim.metadata.0.name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mysql-pv-claim" {
  metadata {
    name = "mysql-pv-claim"
  }
  spec {
    storage_class_name = "manual"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "${var.mysql_pv_storage}"
      }
    }
    volume_name = "${kubernetes_persistent_volume.mysql-pv-volume.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "mysql-pv-volume" {
  metadata {
    name = "mysql-pv-volume"
  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "${var.mysql_pv_storage}"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "${var.mysql_pv_path}"
      }
    }
  }
}
