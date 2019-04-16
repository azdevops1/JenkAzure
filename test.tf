variable "srvpid" {}
variable "srvpkey" {}
variable "subsid" {}
variable "tntid" {}

provider "azurerm" {
  subscription_id = "${var.subsid}"
  client_id = "${var.srvpid}"
  client_secret = "${var.srvpkey}"
  tenant_id = "${var.tntid}"
}
resource "azurerm_resource_group" "rg" {
        name = "testResourceGroup"
        location = "${params.region}"
}