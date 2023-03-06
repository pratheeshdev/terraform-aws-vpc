/*
Module to Create VPC and other Network components
*/

/*
Creating VPC
*/


resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
}



/*
Creating 2 public subnets in 2 availability zones
*/

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = element(var.public_subnet, count.index)
  availability_zone = element(var.azlist, count.index)
}

/*
Creating 2 private subnets for app layer in 2 availability zones
*/


resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = element(var.azlist, count.index)
}

/*
Creating 2 private subnets for DB layer in 2 availability zones
*/


resource "aws_subnet" "private_subnet_db" {
  count             = length(var.private_subnet_db)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = element(var.private_subnet_db, count.index)
  availability_zone = element(var.azlist, count.index)
}


/*
Creating Internet gateway and attaching to the VPC for internet access
*/


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

}


/*
Creating routetable with route pointing to Internet gateway
*/


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

/*
attaching the Internet gateway route table to subnet to make it public subnet
*/

resource "aws_route_table_association" "rapub" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}

/*
Creating the Elastic IP for NAT gateway
*/


resource "aws_eip" "natip" {
  vpc = true
}

/*
Creating NAT Gateway in one public subnet
*/


resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.natip.id
  subnet_id     = aws_subnet.public_subnet[1].id
}

/*
Creating the route table with route pointing towards NAT gateway
*/


resource "aws_route_table" "natroute" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynatgw.id
  }
}

/*
Associating the App subnet with route table pointing towards NAT gateway
*/


resource "aws_route_table_association" "rapriv" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.natroute.id
}

/*
Associating the DB subnet with route table pointing towards NAT gateway
*/

resource "aws_route_table_association" "rapriv_db" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet_db[count.index].id
  route_table_id = aws_route_table.natroute.id
}

/*
Creating the DB subnet group for RDS
*/

resource "aws_db_subnet_group" "db-subnet" {
  name       = "mydbsubnetgroup"
  subnet_ids = [aws_subnet.private_subnet_db[0].id, aws_subnet.private_subnet_db[1].id]
}

