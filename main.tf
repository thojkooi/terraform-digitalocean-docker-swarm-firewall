provider "digitalocean" {
  version = "~> 0.1"
  token   = "${var.do_token}"
}

resource "digitalocean_firewall" "swarm-mode-outbound-fw" {
  name        = "${var.prefix}-swarm-mode-outbound-fw"
  droplet_ids = ["${var.cluster_droplet_ids}"]
  tags        = ["${var.cluster_tags}"]

  outbound_rule = [
    {
      protocol                       = "udp"
      port_range                     = "all"
      destination_addresses          = ["${var.allowed_outbound_addresses}"]
      destination_tags               = ["${var.allowed_outbound_droplet_tags}", "${var.cluster_droplet_ids}"]
      destination_droplet_ids        = ["${var.allowed_outbound_droplet_ids}", "${var.cluster_droplet_ids}"]
      destination_load_balancer_uids = ["${var.allowed_outbound_load_balancer_uids}"]
    },
    {
      protocol                       = "tcp"
      port_range                     = "all"
      destination_addresses          = ["${var.allowed_outbound_addresses}"]
      destination_tags               = ["${var.allowed_outbound_droplet_tags}", "${var.cluster_droplet_ids}"]
      destination_droplet_ids        = ["${var.allowed_outbound_droplet_ids}", "${var.cluster_droplet_ids}"]
      destination_load_balancer_uids = ["${var.allowed_outbound_load_balancer_uids}"]
    },
  ]
}

resource "digitalocean_firewall" "swarm-mode-internal-fw" {
  name        = "${var.prefix}-swarm-mode-internal-fw"
  droplet_ids = ["${var.cluster_droplet_ids}"]
  tags        = ["${var.cluster_tags}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "2377"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
      source_addresses   = []
    },
    {
      # for container network discovery
      protocol           = "tcp"
      port_range         = "7946"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
      source_addresses   = []
    },
    {
      # UDP for the container overlay network.
      protocol           = "udp"
      port_range         = "4789"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
      source_addresses   = []
    },
    {
      # for container network discovery.
      protocol           = "udp"
      port_range         = "7946"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
      source_addresses   = []
    },
  ]
}

resource "digitalocean_firewall" "swarm-cluster-ssh-access" {
  name        = "${var.prefix}-swarm-ssh-access-fw"
  droplet_ids = ["${var.cluster_droplet_ids}"]
  tags        = ["${var.cluster_tags}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_tags        = ["${var.ssh_access_tags}"]
      source_droplet_ids = ["${var.ssh_access_droplet_ids}"]
      source_addresses   = ["${var.ssh_access_from_adresses}"]
    },
  ]
}
