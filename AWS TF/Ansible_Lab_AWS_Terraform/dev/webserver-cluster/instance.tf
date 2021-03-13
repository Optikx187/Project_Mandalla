# Define database inside the private subnet
resource "aws_instance" "db" {
   ami  = var.ami_id
   instance_type = t1.micro
   key_name = aws_key_pair.default.id
   subnet_id = aws_subnet.private_subnet.id
   vpc_security_group_ids = [aws_security_group.sgdb.id]
   source_dest_check = false

  tags = {
    Name = "test_database"
  }
}