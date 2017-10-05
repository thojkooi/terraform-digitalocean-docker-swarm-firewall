variable "do_token" {
}

variable "ssh_keys" {
    type = "list"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_tag" "cluster" {
    name = "swarm-mode-cluster"
}
resource "digitalocean_tag" "manager" {
    name = "manager"
}
resource "digitalocean_tag" "worker" {
    name = "worker"
}

module "swarm-cluster" {
    source            = "github.com/thojkooi/terraform-digitalocean-docker-swarm-mode"
    total_managers    = 0
    total_workers     = 0
    domain            = "do.example.com"
    do_token          = "${var.do_token}"
    manager_ssh_keys  = "${var.ssh_keys}"
    worker_ssh_keys   = "${var.ssh_keys}"
    manager_tags      = ["${digitalocean_tag.cluster.id}", "${digitalocean_tag.manager.id}"]
    worker_tags       = ["${digitalocean_tag.cluster.id}", "${digitalocean_tag.worker.id}"]
}

module "swarm-firewall" {
    source              = "../"
    do_token            = "${var.do_token}"
    prefix              = "production"
    cluster_tags        = ["${digitalocean_tag.manager.id}", "${digitalocean_tag.worker.id}"]
    cluster_droplet_ids = []
}
