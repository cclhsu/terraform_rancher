variable "libvirt_uri" {
  type        = string
  default     = "qemu:///system"
  description = "URL of libvirt connection - default to localhost"
}

variable "libvirt_keyfile" {
  type        = string
  default     = ""
  description = "The private key file used for libvirt connection - default to none"
}

variable "pool" {
  type        = string
  default     = "default"
  description = "Pool to be used to store all the volumes"
}

variable "harvester_version" {
  description = "The harvester version to use."
  type        = string
  default     = "v0.1.0"
}

variable "lb_image_uri" {
  type        = string
  default     = ""
  description = "URL of the lb image to use"
}

variable "image_uri" {
  type        = string
  default     = ""
  description = "URL of the image to use"
}

variable "kernel_uri" {
  type        = string
  default     = ""
  description = "URL of the kernel to use"
}

variable "initrd_uri" {
  type        = string
  default     = ""
  description = "URL of the initrd to use"
}

variable "squashfs_uri" {
  type        = string
  default     = ""
  description = "URL of the squashfs to use"
}

variable "iso_uri" {
  type        = string
  default     = ""
  description = "URL of the iso to use"
}

variable "lb_repositories" {
  type        = map(string)
  default     = {}
  description = "Urls of the repositories to mount via cloud-init"
}

variable "repositories" {
  type        = map(string)
  default     = {}
  description = "Urls of the repositories to mount via cloud-init"
}

variable "stack_name" {
  type        = string
  default     = ""
  description = "Identifier to make all your resources unique and avoid clashes with other users of this terraform project"
}

variable "authorized_keys" {
  type        = list(string)
  default     = []
  description = "SSH keys to inject into all the nodes"
}

variable "ntp_servers" {
  type        = list(string)
  default     = []
  description = "List of NTP servers to configure"
}

variable "dns_nameservers" {
  type        = list(string)
  default     = []
  description = "List of Name servers to configure"
}

variable "packages" {
  type = list(string)

  default = [
    "openssl",
    "python3",
    "curl",
    "rsync",
    "jq",
  ]

  description = "List of packages to install"
}

variable "username" {
  type        = string
  default     = "rancher-harvester"
  description = "Username for the cluster nodes"
}

variable "password" {
  type        = string
  default     = "linux"
  description = "Password for the cluster nodes"
}

variable "dns_domain" {
  type        = string
  default     = "rancher-harvester.local"
  description = "Name of DNS Domain"
}

variable "network_cidr" {
  type        = string
  default     = "10.17.0.0/22"
  description = "Network used by the cluster"
}

variable "network_mode" {
  type        = string
  default     = "nat"
  description = "Network mode used by the cluster"
}

variable "network_name" {
  type        = string
  default     = ""
  description = "The virtual network name to use. If provided just use the given one (not managed by terraform), otherwise terraform creates a new virtual network resource"
}

variable "create_lb" {
  type        = bool
  default     = true
  description = "Create load balancer node exposing master nodes"
}

variable "create_http_server" {
  type        = bool
  default     = true
  description = "Create http server in load balancer node"
}

variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  default     = "for i in `seq 1 60`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT/ping >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT/ping >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
  type        = string
}

variable "wait_for_cluster_interpreter" {
  description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
  default     = ["/bin/sh", "-c"]
  type        = list(string)
}

variable "lb_memory" {
  type        = number
  default     = 2048
  description = "Amount of RAM for a load balancer node"
}

variable "lb_vcpu" {
  type        = number
  default     = 1
  description = "Amount of virtual CPUs for a load balancer node"
}

variable "lb_disk_size" {
  type        = number
  default     = 32212254720
  description = "Disk size (in bytes)"
}

variable "masters" {
  type        = number
  default     = 1
  description = "Number of master nodes"
}

variable "master_memory" {
  type        = number
  default     = 2048
  description = "Amount of RAM for a master"
}

variable "master_vcpu" {
  type        = number
  default     = 2
  description = "Amount of virtual CPUs for a master"
}

variable "master_disk_size" {
  type        = number
  default     = 32212254720
  description = "Disk size (in bytes)"
}

variable "workers" {
  type        = number
  default     = 2
  description = "Number of worker nodes"
}

variable "worker_memory" {
  type        = number
  default     = 2048
  description = "Amount of RAM for a worker"
}

variable "worker_vcpu" {
  type        = number
  default     = 2
  description = "Amount of virtual CPUs for a worker"
}

variable "worker_disk_size" {
  type        = number
  default     = 32212254720
  description = "Disk size (in bytes)"
}

variable "hostname_from_dhcp" {
  type        = bool
  default     = true
  description = "Set node's hostname from DHCP server"
}

variable "cpi_enable" {
  type        = bool
  default     = false
  description = "Enable CPI integration with Azure"
}
