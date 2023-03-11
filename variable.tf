variable "resource_group_name" {
  default = "Brief8-Raja-jenkins"
}

variable "localisation" {
  default = "francecentral"
}

variable "vnet_j" {
  default = "vnet_j"
}

variable "subnet_j" {
  default = "subnet_j"
}

variable "ip_j" {
  default = "ip_j"
}

variable "vm" {
    default = "vm_jenkins"
}


variable "OSdisk_name" {
    default = "OSdisk"

}

variable "vm-nic" {
    default = "vm-nic"
}


variable "config_vm" {
    default = "config_vm"
}

variable "admin" {
    default = "raja"
}

variable "vm_jenkins" {
    default = "vm_jenkins"
}

variable "computervmj" {
    default = "computervmj"
}

variable "NSG" {
    default = "NSG"
}


variable "VM_rule" {
    default = "SSH"

}

variable "VM_rule2" {
    default = "HTTP"

}
