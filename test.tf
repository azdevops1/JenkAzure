variable "srvpid" {}
variable "srvpkey" {}
variable "subsid" {}
variable "tntid" {}

provider "azurerm" {

}
resource "azurerm_resource_group" "rg" {
        name = "testResourceGroup"
        location = "South Central US"
}