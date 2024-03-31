variable "region" {
    type        = string
    description = "Specify the AWS region"  
}

variable "VPCName" {
    type        = string
    description = "Give VPC name"  
}

variable "cidr_block" {
    type        = string
    description = "CIDR block for your VPC"
}

variable "privateSubnet1CIDR" {
    type        = string
    description = "CIDR block for your Private Subnet 1"
}

variable "privateSubnet2CIDR" {
    type        = string
    description = "CIDR block for your Private Subnet 2"
}

variable "privateSubnet3CIDR" {
    type        = string
    description = "CIDR block for your Private Subnet 3"
}

variable "public_subnet_configs" {
  description = "List of public subnet configurations"
  type        = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "igwName" {
    type        = string
    description = "Name of Internet Gateway"
}

variable "publicRTName" {
    type        = string
    description = "Name of Public Route Table"
}

variable "privateRTName" {
    type        = string
    description = "Name of Private Route Table"
}


###########
variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to associate the security group with"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}