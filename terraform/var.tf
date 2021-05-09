variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "20210509"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "westus2"
}

variable "resource_group" {
  description = "The Azure Resource Group in which all resources in this example should be created."
  default     = "20210509group"
}

variable "instance_count" {
  description = "The number of resources."
  default     = 2
}

variable "image_resource_id" {
  description = "Packer image resource ID."
  default     = "/subscriptions/45a69fd7-1b5c-4963-a9c8-1c33e27e9b14/resourceGroups/20210509group/providers/Microsoft.Compute/images/Ubuntu18.04"
}
