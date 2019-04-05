variable "service_principal_id" {}
variable "service_principal_key" {}
variable "subscription_id" {}
variable "tenant_id" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.service_principal_id}"
  client_secret = "${var.service_principal_key}"
  tenant_id = "${var.tenant_id}"

}
resource "azurerm_resource_group" "rg" {
        name = "testResourceGroup"
        location = "South Central US"
}