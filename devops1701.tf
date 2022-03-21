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

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "jenkins" {
  name = "jenkins"
}

resource "digitalocean_droplet" "devbuild" {
  image    = "ubuntu-20-04-x64"
  name     = "devbuild"
  region   = "fra1"
  size     = "s-1vcpu-2gb-amd"
  ssh_keys = [
    data.digitalocean_ssh_key.jenkins.id
  ]
  provisioner "remote-exec" {
    inline = [
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
    command = "echo '[devsrvs]' > hosts"
    command = "echo  '${self.ipv4_address}' >> hosts"
    command = "ansible-playbook -u root -i hosts --private-key ${var.pvt_key} -T 300 devsrv.yml"
  }

}
