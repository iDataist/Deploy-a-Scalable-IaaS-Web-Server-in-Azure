provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "main" {
 name                         = "publicIPForLB"
 location                     = var.location
 resource_group_name          = var.resource_group
 allocation_method            = "Static"
}

resource "azurerm_lb" "main" {
 name                = "loadBalancer"
 location            = var.location
 resource_group_name = var.resource_group

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.main.id
 }
}

resource "azurerm_lb_backend_address_pool" "main" {
 resource_group_name = var.resource_group
 loadbalancer_id     = azurerm_lb.main.id
 name                = "BackEndAddressPool"
}

resource "azurerm_network_interface" "main" {
  count               = var.instance_count
  name                = "${var.prefix}-nic"
  resource_group_name = var.resource_group
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_security_group" "main" {
    name                = "${var.prefix}-nsg"
    location            = var.location
    resource_group_name = var.resource_group
    
    security_rule {
        name                       = "internal_inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.2.0/24"
        destination_address_prefix = "10.0.2.0/24"
    }

    security_rule {
        name                       = "internal_outbound"
        priority                   = 101
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.2.0/24"
        destination_address_prefix = "10.0.2.0/24"
    }

    security_rule {
        name                       = "external_inbound"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_managed_disk" "main" {
 count                = var.instance_count
 name                 = "datadisk_existing_${count.index}"
 location             = var.location
 resource_group_name  = var.resource_group
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = var.location
 resource_group_name          = var.resource_group
 platform_fault_domain_count  = var.instance_count
 platform_update_domain_count = var.instance_count
 managed                      = true
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.instance_count
  name                            = "${var.prefix}-vm"
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = "Standard_D2s_v3"
  source_image_id                 = var.image_resource_id
  availability_set_id             = azurerm_availability_set.avset.id
  admin_username                  = "vmadmin"
  admin_password                  = "p@ssword1234"
  disable_password_authentication = false
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
   DevOps = "Deploy a Web Server in Azure"
 }
}