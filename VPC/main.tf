provider "aws" {
    region = var.region
}

#####################################  VPC   #########################################
######################################################################################
resource "aws_vpc" "vpc" {
    cidr_block              = var.cidr_block
    enable_dns_support      = true
    enable_dns_hostnames    = true

    tags = {
        Name                = var.VPCName
    }
}

#####################################  Subnets   #####################################
######################################################################################
resource "aws_subnet" "privateSubnet1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.privateSubnet1CIDR
    availability_zone       = "us-east-1a"
}

resource "aws_subnet" "privateSubnet2" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.privateSubnet2CIDR
    availability_zone       = "us-east-1b"
}

resource "aws_subnet" "privateSubnet3" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.privateSubnet3CIDR
    availability_zone       = "us-east-1c"
}

resource "aws_subnet" "publicSubnet" {
  for_each = { for idx, config in var.public_subnet_configs : idx => config }

  vpc_id             = aws_vpc.vpc.id
  cidr_block         = each.value.cidr_block
  availability_zone  = each.value.availability_zone
}

#####################################  Internet Gateway   #####################################
###############################################################################################
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = var.igwName
    }
}
#####################################  Elastic IP   ###########################################
###############################################################################################
resource "aws_eip" "eip" {
    domain = "vpc"

    tags = {
      Name = "EIP"
    }
  }

#####################################  NAT Gateway   ##########################################
###############################################################################################
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id     = aws_subnet.privateSubnet1.id # Use one of the private subnets

    tags = {
      Name = "NATGateway"
    }
}

#####################################  Route Table   ###########################################
#################################################################################################
resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = var.publicRTName
    }
}

resource "aws_route_table" "privateRT" {
    vpc_id = aws_vpc.vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
      Name = var.privateRTName
    }
}


#####################################  Route Table Association  #################################
#################################################################################################

resource "aws_route_table_association" "public" {
    depends_on     = [aws_route_table.publicRT]
    for_each       = aws_subnet.publicSubnet
    subnet_id      = each.value.id
    route_table_id = aws_route_table.publicRT.id
}

locals { 
  private_subnet_ids = toset([
    ## putting random values just to test with terraform plan
    "subnet-1234567890abcdef1",
    "subnet-1234567890abcdef2",
    "subnet-1234567890abcdef3"
    # aws_subnet.privateSubnet1.id,
    # aws_subnet.privateSubnet2.id,
    # aws_subnet.privateSubnet3.id
  ])
  private_subnet_map = { for id in local.private_subnet_ids : id => true }
}

resource "aws_route_table_association" "private" {
    depends_on     = [aws_route_table.privateRT]
    for_each       = local.private_subnet_map
    subnet_id      = each.value
    route_table_id = aws_route_table.privateRT.id
  }


#####################################  Security Group  ##########################################
#################################################################################################

module "my_security_group" {
  source = "/Users/shubhamkumar/repo/MyWork/terraform/modules/securityGroup"

  name           = var.name
  description    = var.description
  vpc_id         = aws_vpc.vpc.id
  ingress_rules  = var.ingress_rules
  egress_rules   = var.egress_rules
}


# terraform {
#   backend "s3" {
# 	bucket     	= "kumarshubham1807"
# 	key        	= "s3://kumarshubham1807/statefile.tfstate"
# 	region     	= "us-east-1"
# 	encrypt    	= true
# 	dynamodb_table = "kumarshubham1807"
#   }
# }

terraform {
  backend local {}
}