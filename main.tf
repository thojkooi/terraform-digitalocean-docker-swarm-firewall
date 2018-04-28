resource "digitalocean_firewall" "swarm-mode-internal-fw" {
  name        = "${var.prefix}-swarm-mode-internal-fw"
  droplet_ids = ["${var.cluster_droplet_ids}"]
  tags        = ["${var.cluster_tags}"]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "2377"
      destination_tags        = ["${var.cluster_tags}"]
      destination_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
    {
      # for container network discovery
      protocol                = "tcp"
      port_range              = "7946"
      destination_tags        = ["${var.cluster_tags}"]
      destination_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
    {
      # UDP for the container overlay network.
      protocol                = "udp"
      port_range              = "4789"
      destination_tags        = ["${var.cluster_tags}"]
      destination_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
    {
      # for container network discovery.
      protocol                = "udp"
      port_range              = "7946"
      destination_tags        = ["${var.cluster_tags}"]
      destination_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
  ]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "2377"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
    {
      # for container network discovery
      protocol           = "tcp"
      port_range         = "7946"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
    {
      # UDP for the container overlay network.
      protocol           = "udp"
      port_range         = "4789"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
    {
      # for container network discovery.
      protocol           = "udp"
      port_range         = "7946"
      source_tags        = ["${var.cluster_tags}"]
      source_droplet_ids = ["${var.cluster_droplet_ids}"]
    },
  ]
}
