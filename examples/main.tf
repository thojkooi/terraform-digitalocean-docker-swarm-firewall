variable "do_token" {}

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

module "swarm-mode-cluster" {
  source           = "thojkooi/docker-swarm-mode/digitalocean"
  version          = "0.1.1"
  total_managers   = 2
  total_workers    = 2
  domain           = "do.example.com"
  do_token         = "${var.do_token}"
  manager_ssh_keys = "${var.ssh_keys}"
  worker_ssh_keys  = "${var.ssh_keys}"
  manager_tags     = ["${digitalocean_tag.cluster.id}", "${digitalocean_tag.manager.id}"]
  worker_tags      = ["${digitalocean_tag.cluster.id}", "${digitalocean_tag.worker.id}"]
}

# This module provides SSH access
module "basic-fw-rules" {
  source  = "thojkooi/firewall-rules/digitalocean"
  version = "1.0.0"

  prefix = "do-example-com"
  tags   = ["${digitalocean_tag.cluster.id}"]
}

# Create the internal cluster firewall rules
module "swarm-mode-firewall" {
  source              = "../"
  do_token            = "${var.do_token}"
  prefix              = "do-example-com"
  cluster_tags        = ["${digitalocean_tag.manager.id}", "${digitalocean_tag.worker.id}"]
  cluster_droplet_ids = []
}
