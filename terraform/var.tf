variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "resource_group" {
  description = "The Azure Resource Group in which all resources in this example should be created."
}

variable "instance_count" {
  description = "The number of resources."
}

variable "image_resource_id" {
  description = "Packer image resource ID."
}
