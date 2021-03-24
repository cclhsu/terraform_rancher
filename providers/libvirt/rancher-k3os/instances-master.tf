# data "template_file" "master_commands" {
#   count    = join("", var.packages) == "" ? 0 : 1
#   template = file("${path.module}/cloud-init/commands.tpl")
# }

# data "template_file" "master_cloud-init" {
#   count    = var.masters
#   template = file("${path.module}/cloud-init/cloud-init.yaml.tpl")

#   vars = {
#     authorized_keys    = join("\n", formatlist("  - %s", var.authorized_keys))
#     username           = var.username
#     password           = var.password
#     hostname           = "${var.stack_name}-master-${count.index}"
#     hostname_from_dhcp = var.hostname_from_dhcp == true && var.cpi_enable == false ? "yes" : "no"
#     ntp_servers        = join("\n", formatlist("    - %s", var.ntp_servers))
#     dns_nameservers    = join("\n", formatlist("    - %s", var.dns_nameservers))
#     packages           = join("\n", formatlist("  - %s", var.packages))
#     commands           = join("\n", data.template_file.master_commands.*.rendered)
#   }
# }

resource "libvirt_volume" "master" {
  count = var.masters
  name  = "${var.stack_name}-master-volume-${count.index}"
  pool  = var.pool
  size  = var.master_disk_size
  # format         = "raw"
  # base_volume_id = libvirt_volume.image.id
}

# resource "libvirt_cloudinit_disk" "master" {
#   # needed when 0 master nodes are defined
#   count     = var.masters
#   name      = "${var.stack_name}-master-cloudinit-disk-${count.index}"
#   pool      = var.pool
#   user_data = data.template_file.master_cloud-init[count.index].rendered
# }

# Create the machine
resource "libvirt_domain" "master" {
  count    = var.masters
  name     = "${var.stack_name}-master-domain-${count.index}"
  memory   = var.master_memory
  vcpu     = var.master_vcpu
  emulator = "/usr/bin/qemu-system-x86_64"
  # cloudinit = element(
  #   libvirt_cloudinit_disk.master.*.id,
  #   count.index
  # )
  depends_on = [
    libvirt_domain.lb,
    null_resource.lb_push_http_server_cfg,
  ]

  network_interface {
    network_name   = var.network_name
    network_id     = var.network_name == "" ? libvirt_network.network.0.id : null
    hostname       = "${var.stack_name}-master-${count.index}"
    wait_for_lease = true
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  cpu = {
    mode = "host-passthrough"
  }

  kernel = libvirt_volume.kernel.id
  initrd = libvirt_volume.initrd.id
  # squashfs = libvirt_volume.squashfs.id

  cmdline = [
    {
      "k3os.fallback_mode"      = "install"
      "k3os.install.config_url" = format("http://%s:80/cloud-init-server.yaml", libvirt_domain.lb.0.network_interface.0.addresses.0)
      "k3os.install.silent"     = true
      "k3os.install.device"     = "/dev/vda"
      "k3os.password"           = var.password
      "k3os.token"              = random_password.k3s_token.result
    },
  ]

  disk {
    volume_id = element(
      libvirt_volume.master.*.id,
      count.index
    )
  }

  disk {
    file = libvirt_volume.iso.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}
