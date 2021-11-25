data "aws_ami" "rhel" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["ami-0b0af3577fe5e3532"] #change me 
  }
}
data "aws_ami" "windows" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["ami-0b17e49efb8d755c3"] #change me 
  }
}