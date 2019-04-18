variable "srvpid" {}
variable "srvpkey" {}
variable "subsid" {}
variable "tntid" {}
variable "location" {}
variable "resourcegroupname" {}

provider "azurerm" {

  client_id = "${var.srvpid"}

  client_secret = "${var.srvpkey}"

  subscription_id = "${var.subsid}"

  tenant_id = "${var.tntid}"

}

 

resource "azurerm_resource_group" "BOK" {

 

        name = "${var.resourcegroupname}"
        location = "${var.location}"

 

}

 

 

resource "azurerm_virtual_network" "BOK" {

 

name                = "acctvn"

 

address_space       = ["10.0.0.0/16"]

 

location            = "${azurerm_resource_group.BOK.location}"

 

resource_group_name = "${azurerm_resource_group.BOK.name}"

 

}

 

 

resource "azurerm_subnet" "BOK" {

 

name                 = "acctsub"

 

resource_group_name  = "${azurerm_resource_group.BOK.name}"

 

virtual_network_name = "${azurerm_virtual_network.BOK.name}"

 

address_prefix       = "10.0.2.0/24"

 

}

 

 

resource "azurerm_public_ip" "BOK" {

 

name                         = "publicIPForLB"

 

location                     = "${azurerm_resource_group.BOK.location}"

 

resource_group_name          = "${azurerm_resource_group.BOK.name}"

 

public_ip_address_allocation = "static"

 

}

 

 

resource "azurerm_lb" "BOK" {

 

name                = "loadBalancer"

 

location            = "${azurerm_resource_group.BOK.location}"

 

resource_group_name = "${azurerm_resource_group.BOK.name}"

 

 

frontend_ip_configuration {

 

   name                 = "publicIPAddress"

 

   public_ip_address_id = "${azurerm_public_ip.BOK.id}"

 

}

 

}

 

 

resource "azurerm_lb_backend_address_pool" "BOK" {

 

resource_group_name = "${azurerm_resource_group.BOK.name}"

 

loadbalancer_id     = "${azurerm_lb.BOK.id}"

 

name                = "BackEndAddressPool"

 

}

 

 

resource "azurerm_network_interface" "BOK" {

 

count               = 2

 

name                = "acctni${count.index}"

 

location            = "${azurerm_resource_group.BOK.location}"

 

resource_group_name = "${azurerm_resource_group.BOK.name}"

 

 

ip_configuration {

 

   name                          = "BOKConfiguration"

 

   subnet_id                     = "${azurerm_subnet.BOK.id}"

 

   private_ip_address_allocation = "dynamic"

 

   load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.BOK.id}"]

 

}

 

}

 

 

resource "azurerm_managed_disk" "BOK" {

 

count                = 2

 

name                 = "datadisk_existing_${count.index}"

 

location             = "${azurerm_resource_group.BOK.location}"

 

resource_group_name  = "${azurerm_resource_group.BOK.name}"

 

storage_account_type = "Standard_LRS"

 

create_option        = "Empty"

 

disk_size_gb         = "1023"

 

}

 

 

resource "azurerm_availability_set" "avset" {

 

name                         = "avset"

 

location                     = "${azurerm_resource_group.BOK.location}"

 

resource_group_name          = "${azurerm_resource_group.BOK.name}"

 

platform_fault_domain_count  = 2

 

platform_update_domain_count = 2

 

managed                      = true

 

}

 

 

resource "azurerm_virtual_machine" "BOK" {

 

count                 = 2

 

name                  = "acctvm${count.index}"

 

location              = "${azurerm_resource_group.BOK.location}"

 

availability_set_id   = "${azurerm_availability_set.avset.id}"

 

resource_group_name   = "${azurerm_resource_group.BOK.name}"

 

network_interface_ids = ["${element(azurerm_network_interface.BOK.*.id, count.index)}"]

 

vm_size               = "Standard_DS1_v2"

 

 

# Uncomment this line to delete the OS disk automatically when deleting the VM

 

delete_os_disk_on_termination = true

 

 

# Uncomment this line to delete the data disks automatically when deleting the VM

 

delete_data_disks_on_termination = true

 

 

storage_image_reference {

 

   publisher = "Canonical"

 

   offer     = "UbuntuServer"

 

   sku       = "16.04-LTS"

 

   version   = "latest"
 

}

 

 

storage_os_disk {

 

   name              = "myosdisk${count.index}"

 

   caching           = "ReadWrite"

 

   create_option     = "FromImage"

 

   managed_disk_type = "Standard_LRS"

 

}

 

 

# Optional data disks

 

storage_data_disk {

 

   name              = "datadisk_new_${count.index}"

 

   managed_disk_type = "Standard_LRS"

 

   create_option     = "Empty"

 

   lun               = 0

 

   disk_size_gb      = "1023"

 

}

 

 

storage_data_disk {

 

   name            = "${element(azurerm_managed_disk.BOK.*.name, count.index)}"

 

   managed_disk_id = "${element(azurerm_managed_disk.BOK.*.id, count.index)}"

 

   create_option   = "Attach"

 

   lun             = 1

 

   disk_size_gb    = "${element(azurerm_managed_disk.BOK.*.disk_size_gb, count.index)}"

 

}

 

 

os_profile {

 

   computer_name  = "hostname"

 

   admin_username = "BOKadmin"

 

   admin_password = "Password1!"

 

}

 

 

os_profile_linux_config {

 

   disable_password_authentication = false

 

}

 

 

tags {

 

   environment = "staging"

 

}

 

}
