# creation resouece group

resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.localisation
}

# creation vnet

resource "azurerm_virtual_network" "vnet_j" {
  name = var.vnet_j
  location = var.localisation
  resource_group_name = azurerm_resource_group.rg.name 
  address_space = ["10.2.0.0/16"]
  
} 

# creation subnet 

resource "azurerm_subnet" "subnet_j"   { 
  name = var.subnet_j
  resource_group_name = azurerm_resource_group.rg.name 
  virtual_network_name = azurerm_virtual_network.vnet_j.name 
  address_prefixes = ["10.2.1.0/24"]
 
 }

# Create IP

 resource "azurerm_public_ip" "ip_j"   { 
   name = var.ip_j 
   location = var.localisation
   resource_group_name = azurerm_resource_group.rg.name 
   allocation_method = "Static" 
   sku = "Basic" 
 } 


# Create VM network interface

resource "azurerm_network_interface" "vm" {
  name = var.vm-nic
  location = var.localisation
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = var.config_vm
    subnet_id = azurerm_subnet.subnet_j.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.2.1.10"
    public_ip_address_id = azurerm_public_ip.ip_j.id
  }
}

# Create VM

resource "azurerm_linux_virtual_machine" "vm_jenkins" {
  name = var.vm_jenkins
  resource_group_name = azurerm_resource_group.rg.name
  location = var.localisation
  size = "Standard_A1_v2"
  admin_username = var.admin 
  network_interface_ids = [azurerm_network_interface.vm.id]
  


   admin_ssh_key {
    username   = var.admin
    public_key = file("/Users/rajachoukri/Desktop/todo/Bureau/id_rsa.pub")
    }


  os_disk {
    name = var.OSdisk_name
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
    version   = "latest"
    
  }
  
    computer_name = var.computervmj
    disable_password_authentication = true
}


# Create NSG

resource "azurerm_network_security_group" "vm" {
  name  = var.NSG
  location = var.localisation
  resource_group_name = azurerm_resource_group.rg.name 

  security_rule {
    name = var.VM_rule
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = ["22"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

   security_rule {
    name = var.VM_rule2
    priority = 101
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = ["8080"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "vm" {
  subnet_id = azurerm_subnet.subnet_j.id
  network_security_group_id = azurerm_network_security_group.vm.id
}

