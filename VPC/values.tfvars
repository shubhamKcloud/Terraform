region             = "us-east-1"
VPCName            = "myVPC"
cidr_block         = "10.0.0.0/16"
privateSubnet1CIDR = "10.0.1.0/24"
privateSubnet2CIDR = "10.0.2.0/24"
privateSubnet3CIDR = "10.0.3.0/24"


public_subnet_configs = [
  {
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1a"
  },
  {
    cidr_block        = "10.0.5.0/24"
    availability_zone = "us-east-1b"
  },
  {
    cidr_block        = "10.0.6.0/24"
    availability_zone = "us-east-1c"
  }
]

igwName            = "myIGW"
publicRTName       = "publicRT"
privateRTName      = "privateRT"


# Input variables for the security group module
name           = "securityGroup"
description    = "Security group"
vpc_id         = ""

ingress_rules = [
{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
},
{
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
]

egress_rules = [
{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
]