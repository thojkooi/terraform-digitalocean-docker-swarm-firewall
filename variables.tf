variable "do_token" {
    description = "DigitalOcean access token with read/write permissions"
}

variable "cluster_droplet_ids" {
  description = "List of droplet ids"
  type        = "list"
}

variable "cluster_tags" {
  description = "List of droplet tags"
  type        = "list"
}


variable "prefix" {
    description = "Prefix used for the name of the firewall rules"
}

variable "ssh_access_tags" {
  default = []
  type = "list"
  description = "List of droplet tags from which SSH is allowed to any node in cluster"
}

variable "ssh_access_droplet_ids" {
  default = []
  type = "list"
  description = "List of droplet ids from which SSH is allowed to any node in cluster"
}

variable "ssh_access_from_adresses" {
  default = ["0.0.0.0/0", "::/0"]
  type = "list"
  description = "An array of strings containing the IPv4 addresses, IPv6 addresses, IPv4 CIDRs, and/or IPv6 CIDRs from which the inbound traffic will be accepted."
}


variable "allowed_outbound_addresses" {
  default = ["0.0.0.0/0", "::/0"]
  type = "list"
  description = "An array of strings containing the IPv4 addresses, IPv6 addresses, IPv4 CIDRs, and/or IPv6 CIDRs to which outbound traffic will be allowed."
}
variable "allowed_outbound_droplet_ids" {
  default = []
  type = "list"
  description = "An array of droplet ids to which outbound traffic will be allowed."
}
variable "allowed_outbound_droplet_tags" {
  default = []
  type = "list"
  description = "An array of tags of droplets to which outbound traffic will be allowed."
}
variable "allowed_outbound_load_balancer_uids" {
  default = []
  type = "list"
  description = "An array containing the IDs of the Load Balancers to which outbound traffic will be allowed."
}
