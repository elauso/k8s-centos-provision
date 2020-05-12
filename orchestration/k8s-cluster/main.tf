resource "rke_cluster" "cluster" {
    
    nodes {
        address = "localhost"
        user = "root"
        role = ["controlplane", "worker", "etcd"]
    }

    addons_include = [
        "https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml",
        "https://gist.githubusercontent.com/superseb/499f2caa2637c404af41cfb7e5f4a938/raw/930841ac00653fdff8beca61dab9a20bb8983782/k8s-dashboard-user.yml",
    ]
}

resource "local_file" "kube_cluster_yaml" {
  
  filename = "${path.root}/kube_config_cluster.yml"
  sensitive_content  = "${rke_cluster.cluster.kube_config_yaml}"
}