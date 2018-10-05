# Terraform - Digital Ocean Swarm mode firewall rules

Terraform module to configure Docker Swarm mode firewall rules on DigitalOcean. Based on the [Docker documentation](https://docs.docker.com/engine/swarm/swarm-tutorial/#open-protocols-and-ports-between-the-hosts). This module provides a basic set of rules for cluster communications.

[![CircleCI](https://circleci.com/gh/thojkooi/terraform-digitalocean-docker-swarm-firewall/tree/master.svg?style=svg)](https://circleci.com/gh/thojkooi/terraform-digitalocean-docker-swarm-firewall/tree/master)

---

## Requirements

- [Terraform](https://www.terraform.io/)
- [Digitalocean account / API token with write access](https://www.digitalocean.com/docs/api/create-personal-access-token/)

## Usage

```hcl
provider "digitalocean" {
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

module "swarm-mode-firewall" {
    source  = "thojkooi/docker-swarm-firewall/digitalocean"
    version = "1.0.0"

    prefix                     = "my-project"
    cluster_tags               = ["${digitalocean_tag.cluster.id}"]
}
```

See [examples](https://github.com/thojkooi/terraform-digitalocean-docker-swarm-firewall/tree/master/examples) for more.

## Firewall rules

The following rules will be created:

### Cluster communications

The following inbound rules are applied to any droplet that matches the id in `cluster_droplet_ids` or has a tag listed in `cluster_tags`:

Port       | Description                       | Source
---------- | --------------------------------- | -------
`2377/TCP` | cluster management communications | `cluster_droplet_ids`, `cluster_tags`
`7946/TCP` | Container network discovery       | `cluster_droplet_ids`, `cluster_tags`
`7946/UDP` | Container network discovery       | `cluster_droplet_ids`, `cluster_tags`
`4789/UDP` | Container overlay network         | `cluster_droplet_ids`, `cluster_tags`

Please note that previous versions of this module also added rules for SSH access and various outbound rules. These have been removed from this module. Simliar functionality is provided by the following modules:

- [DigitalOcean firewall rules set](https://github.com/thojkooi/terraform-digitalocean-firewall-rules), provides SSH inbound/outbound and various outbound rules.
- [DigitalOcean Remote Docker API access](https://github.com/thojkooi/terraform-digitalocean-firewall-docker-api).

## License

[MIT © Thomas Kooi](LICENSE)
