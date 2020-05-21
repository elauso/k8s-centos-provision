variable "mysql_port" {
  description = "Mysql forward port"
  default     = 3306
}

variable "mysql_image" {
  description = "Mysql container image"
  default     = ""
}

variable "mysql_root_password" {
  description = "Mysql container image"
  default     = ""
}

variable "mysql_pv_storage" {
  description = "Mysql persistent volume storage size"
  default     = ""
}

variable "mysql_pv_path" {
  description = "Mysql persistent volume host path"
  default     = "/mnt/mysql_data"
}

variable "traefik_image" {
  description = "Traefik container image"
  default = ""
}

variable "traefik_http_port" {
  description = "The traefik ingress http port"
  default = 80
}

variable "traefik_admin_port" {
  description = "The traefik ingress admin port"
  default = 8080
}