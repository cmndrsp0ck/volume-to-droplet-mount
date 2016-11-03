# Set up provider details
variable "do_token" {}

variable "region" {}

variable "image_slug" {}

variable "keys" {}

variable "private_key_path" {}

variable "ssh_fingerprint" {}

variable "public_key" {}

variable "project" {}

# Honey pot vars
variable "hp_count" {}

variable "hp_image" {}

variable "hp_size" {}

variable "probe_count" {}

variable "probe_image" {}

variable "probe_size" {}

variable "volume_size" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
