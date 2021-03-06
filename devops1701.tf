terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.17.1"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "access_id" {}
variable "secret_key" {}

provider "digitalocean" {
  token = var.do_token
  spaces_access_id  = var.access_id
  spaces_secret_key = var.secret_key
}

data "digitalocean_ssh_key" "jenkins" {
  name = "jenkins"
}

resource "digitalocean_droplet" "build1701" {
  image    = "ubuntu-20-04-x64"
  name     = "build1701"
  region   = "fra1"
  size     = "s-1vcpu-2gb-amd"
  ssh_keys = [
    data.digitalocean_ssh_key.jenkins.id
  ]
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt update",
      "apt install -y python"
    ]
    connection {
      host        = self.ipv4_address
      user        = "root"
      type        = "ssh"
      private_key = file(var.pvt_key)
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root --private-key ${var.pvt_key} -i '${self.ipv4_address_private},' -T 300 devsrv.yml"
  }

}

resource "digitalocean_droplet" "stage1701" {
  image    = "ubuntu-20-04-x64"
  name     = "stage1701"
  region   = "fra1"
  size     = "s-1vcpu-2gb-amd"
  ssh_keys = [
    data.digitalocean_ssh_key.jenkins.id
  ]
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt update",
      "apt install -y python"
    ]
    connection {
      host        = self.ipv4_address
      user        = "root"
      type        = "ssh"
      private_key = file(var.pvt_key)
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root --private-key ${var.pvt_key} -i '${self.ipv4_address_private},' -T 300 stage.yml"
  }
   depends_on = [
     digitalocean_droplet.build1701
   ]
}
