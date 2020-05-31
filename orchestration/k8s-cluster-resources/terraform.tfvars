# Cluster node
server_ip = "192.168.11.11"

# Mysql
mysql_image = "mysql:5.6"
mysql_root_password = "root"
mysql_pv_storage = "20Gi"
mysql_pv_path = "/srv/containers/volumes/mysql/data"

# Traefik
traefik_image = "traefik:v1.7"