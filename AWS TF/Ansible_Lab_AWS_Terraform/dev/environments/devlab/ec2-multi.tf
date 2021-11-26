################################################################################
# EC2 Module
################################################################################
#Bastion
module "ec2_bastion_multi" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  for_each = local.multiple_bastion_instances

  name = "${var.ec2_name_bastion}-${each.key}"

  ami                    = data.aws_ami.windows-2019.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.security_group_public.security_group_id]

  associate_public_ip_address = true
  disable_api_termination     = false # change me 
  #user_data_base64
  #user_data
  key_name           = aws_key_pair.key_pair_ec2.key_name
  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(
    {
      "Name" = "${var.ec2_name_bastion}-${var.environment}-${var.customer_name}"
      "Role" = "bastion" #change me
    },
    var.tags,
    var.ec2_tags
  )
}
#windows
module "ec2_windows_multi" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  for_each = local.multiple_windows_instances

  name = "${var.ec2_name_windows}-${each.key}"

  ami                    = data.aws_ami.windows-2019.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.security_group_private.security_group_id]

  disable_api_termination     = false # change me
  #user_data_base64
  user_data = templatefile("./dependencies/win_boot.ps1.tpl", {uname = var.ec2_uname, pass = var.ec2_passwd})
  key_name           = aws_key_pair.key_pair_ec2.key_name
  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(
    {
      "Name" = "${var.ec2_name_windows}-${var.environment}-${var.customer_name}"
      "Role" = "app-windows" #change me 
    },
    var.tags,
    var.ec2_tags,
  )
}
#linux
module "ec2_linux_multi" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  for_each = local.multiple_linux_instances

  name = "${var.ec2_name_linux}-${each.key}"

  ami                    = data.aws_ami.redhat-linux-8.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.security_group_private.security_group_id]

  disable_api_termination     = false # change me
  #user_data_base64
  #user_data
  key_name           = aws_key_pair.key_pair_ec2.key_name
  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(
    {
      "Name" ="${var.ec2_name_linux}-${var.environment}-${var.customer_name}"
      "Role" = "enterprise-rhel" #change me 
    },
    var.tags,
    var.ec2_tags,
  )
}

/*
resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = local.availability_zone
  size              = 1

  tags = local.tags
}
*/
