/*providing vpc id as output*/

output "myoutput" {
  value = aws_vpc.myvpc.id
}

/*providing public subnets as output*/

output "mypublicsubnets" {
  value = aws_subnet.public_subnet.*.id
}

/*providing private subnet as output*/

output "myprivatesubnets" {
  value = aws_subnet.private_subnet.*.id
}

/*providing subnet group as output*/


output "mydbsubnetgroup" {
  value = aws_db_subnet_group.db-subnet.name
}

