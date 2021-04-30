variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "20210405"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "westus2"
}

variable "resource_group" {
  description = "The Azure Resource Group in which all resources in this example should be created."
  default     = "20210430group"
}

variable "instance_count" {
  description = "The number of resources."
  default     = 2
}

variable "image_resource_id" {
  description = "Packer image resource ID."
  default     = "/subscriptions/5bb35c36-233e-4b7e-afd9-a2b795899fb9/resourceGroups/rg/providers/Microsoft.Compute/images/Ubuntu18.04"
}
