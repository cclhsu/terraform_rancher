# instance the provider
provider "libvirt" {
  uri = var.libvirt_keyfile == "" ? var.libvirt_uri : "${var.libvirt_uri}?keyfile=${var.libvirt_keyfile}"
}

# resource "libvirt_pool" "pool" {
#   name = var.pool
#   type = "dir"
#   path = "/tmp/terraform-provider-libvirt-pool-${var.pool}"
# }

# # We fetch the latest rancher-harvester release image from their mirrors
# resource "libvirt_volume" "image" {
#   name   = "${var.stack_name}-${basename(var.image_uri)}"
#   # source = "https://github.com/rancher/harvester/releases/download/${var.harvester_version}/harvester-amd64.img"
#   source = var.image_uri
#   pool   = var.pool
#   format = "qcow2"
# }

resource "libvirt_volume" "kernel" {
  name = "kernel-${var.stack_name}"
  # source = "https://github.com/rancher/harvester/releases/download/${var.harvester_version}/harvester-vmlinuz-amd64"
  source = var.kernel_uri
  pool   = var.pool
  format = "raw"
}

resource "libvirt_volume" "initrd" {
  name = "initrd-${var.stack_name}"
  # source = "https://github.com/rancher/harvester/releases/download/${var.harvester_version}/harvester-initrd-amd64"
  source = var.initrd_uri
  pool   = var.pool
  format = "raw"
}

resource "libvirt_volume" "squashfs" {
  name = "squashfs-${var.stack_name}"
  # source = "https://github.com/rancher/harvester/releases/download/${var.harvester_version}/harvester-kernel-amd64.squashfs"
  source = var.squashfs_uri
  pool   = var.pool
  format = "raw"
}

resource "libvirt_volume" "iso" {
  name = "harvester-amd64-${var.stack_name}.iso"
  # source = "https://github.com/rancher/harvester/releases/download/${var.harvester_version}/harvester-amd64.iso"
  source = var.iso_uri
  pool   = var.pool
  format = "iso"
}
