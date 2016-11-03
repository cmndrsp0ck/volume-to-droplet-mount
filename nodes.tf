# Setting up volume
resource "digitalocean_volume" "storage_volume" {
  count  = "${var.hp_count}"
  name   = "${var.project}-volume-${count.index + 1}"
  region = "${var.region}"
  size   = "${var.volume_size}"
}

resource "digitalocean_droplet" "honey_pot" {
  count              = "${var.hp_count}"
  image              = "${var.hp_image}"
  name               = "${var.project}-honeypot-${count.index + 1}"
  region             = "${var.region}"
  size               = "${var.hp_size}"
  private_networking = true
  ssh_keys           = ["${split(",",var.keys)}"]
  user_data          = "${data.template_file.user_data.rendered}"
  volume_ids         = ["${element(digitalocean_volume.storage_volume.*.id, count.index)}"]

  connection {
    user     = "root"
    type     = "ssh"
    key_file = "${var.private_key_path}"
    timeout  = "2m"
  }
}

resource "digitalocean_droplet" "probe" {
  count              = "${var.probe_count}"
  image              = "${var.probe_image}"
  name               = "${var.project}-probe-${count.index + 1}"
  region             = "${var.region}"
  size               = "${var.probe_size}"
  private_networking = true
  ssh_keys           = ["${split(",",var.keys)}"]
  user_data          = "${data.template_file.user_data.rendered}"

  connection {
    user     = "root"
    type     = "ssh"
    key_file = "${var.private_key_path}"
    timeout  = "2m"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/config/cloud-config.yaml")}"

  vars {
    public_key = "${var.public_key}"
  }
}
