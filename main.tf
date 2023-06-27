data ibm_resource_group "resource_group" {
    name = "satellite-rg"
}

locals {
  server_count_control_plane = 0
  server_count_host = 2
}

resource "ibm_compute_vm_instance" "virtual-server-classic-control-plane" {
  count                      = local.server_count_control_plane
  hostname                   = "control-plane-virtual-server-${count.index + 1}"
  domain                     = "IBM-PoC-Landing-Zone-Enterprise.cloud"
  os_reference_code          = "REDHAT_8_64"
  datacenter                 = "dal13"
  network_speed              = 10
  hourly_billing             = false
  private_network_only       = false
  cores                      = 4
  memory                     = 16384
  disks                      = [25, 150]
  user_metadata              = "{\"value\":\"newvalue\"}"
  dedicated_acct_host_only   = true
  local_disk                 = false

}

resource "ibm_compute_vm_instance" "virtual-server-classic-host" {
  count                      = local.server_count_host
  hostname                   = "host-virtual-server-${count.index + 1}"
  domain                     = "IBM-PoC-Landing-Zone-Enterprise.cloud"
  os_reference_code          = "REDHAT_8_64"
  datacenter                 = "dal13"
  network_speed              = 10
  hourly_billing             = false
  private_network_only       = false
  cores                      = 4
  memory                     = 16384
  disks                      = [25, 250]
  user_metadata              = "{\"value\":\"newvalue\"}"
  dedicated_acct_host_only   = true
  local_disk                 = false

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }

}

resource "null_resource" "wait_for_ssh" {
  depends_on = [ibm_compute_vm_instance.virtual-server-classic-host]

  provisioner "local-exec" {
    command = "sleep 45m"
  }

  provisioner "safe-remote-exec" {
    inline = [
      "echo 'Esperando a que el servidor esté disponible para SSH...'",
      "while ! nc -z -w 2 ${ibm_compute_vm_instance.virtual-server-classic-host[0].ipv4_address} 22; do sleep 10m; done",
      "echo 'Servidor disponible para SSH. Ejecutando script de aprovisionamiento...'",
      "sh /setup_satellite.sh",
      "chmod +x /attachHost-satellite-location.sh",
      "nohup bash /attachHost-satellite-location.sh &"
    ]
  }
}
