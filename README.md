# Terraform - Digital Ocean Swarm mode firewall rules

Terraform module to configure Docker Swarm mode firewall rules on DigitalOcean. Based on the [Docker documentation](https://docs.docker.com/engine/swarm/swarm-tutorial/#open-protocols-and-ports-between-the-hosts).

[![CircleCI](https://circleci.com/gh/thojkooi/terraform-digitalocean-docker-swarm-firewall/tree/master.svg?style=svg)](https://circleci.com/gh/thojkooi/terraform-digitalocean-docker-swarm-firewall/tree/master)

---

## Usage

```hcl

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
    total_managers    = 3
    total_workers     = 5
    domain            = "do.example.com"
    do_token          = "${var.do_token}"
    manager_ssh_keys  = "${var.ssh_keys}"
    worker_ssh_keys   = "${var.ssh_keys}"
    manager_tags      = ["${digitalocean_tag.cluster.id}", "${digitalocean_tag.manager.id}"]
    worker_tags       = ["${digitalocean_tag.cluster.id}", "${digitalocean_tag.worker.id}"]
}

module "swarm-firewall" {
    source              = "github.com/thojkooi/terraform-digitalocean-swarm-firewall"
    do_token            = "${var.do_token}"
    prefix              = "my-project"
    cluster_tags        = ["${digitalocean_tag.manager.id}", "${digitalocean_tag.worker.id}"]
    cluster_droplet_ids = []
    allowed_outbound_addresses = ["0.0.0.0/0"]
}
```


## Requirements

- Terraform
- Digitalocean account / API token with write access

## Firewall rules

The following rules will be created:

### Inbound

Port       | Description                       | Source
---------- | --------------------------------- | -------
`2377/TCP` | cluster management communications | Cluster
`7946/TCP` | Container network discovery       | Cluster
`7946/UDP` | Container network discovery       | Cluster
`4789/UDP` | Container overlay network         | Cluster
`22/TCP`   | SSH access.                       | Adresses or droplets listed in `ssh_access_from_adresses`, `ssh_access_tags` or `ssh_access_droplet_ids`

### Outbound

Port    | Descripton                         | Destination
------- | ---------------------------------- | -----------
All/tcp | Traffic to any node in the cluster | Cluster
All/udp | Traffic to any node in the cluster | Cluster
