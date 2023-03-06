Overview1:
========

This module provisions VPC,Subnets,NAT gateway,Internet Gateway,route tables,route table associations.

Usage:
======
module "vpc_module" {

  source            = "../vpc_module"
  
  vpc_cidr          = var.vpc_cidr
  
  public_subnet     = var.public_subnet
  
  private_subnet    = var.private_subnet
  
  private_subnet_db = var.private_subnet_db
  
  azlist            = var.azlist
  
}




dependency
=========
None

Resources
=========
aws_vpc

aws_subnet

aws_internet_gateway

aws_route_table

aws_route_table_association

aws_eip

aws_nat_gateway

aws_db_subnet_group



Inputs (Required)
================

vpc_cidr:
type = string,
description = "CIDR for VPC"

public_subnet:
type = list(string),
description = "CIDR for public subnets"


private_subnet:
type = list(string),
description = "CIDR for private subnet"


private_subnet_db:
type = list(string),
description = "cidr for db private subnet"


azlist:
type = list(string),
description = "availability zone list where you want to deploy subnets"





Outputs
========
myoutput:providing vpc id as output

mypublicsubnets:providing public subnets ids as output

myprivatesubnets:providing private subnet ids as output

mydbsubnetgroup:providing subnet group id as output


