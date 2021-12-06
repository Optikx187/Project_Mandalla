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
  get_password_data           = true
  user_data = templatefile("../dependencies/templates/win_bastion_boot.ps1.tpl", {uname = var.bastion_username, pass = random_password.bastion_pw.result})
  key_name           = aws_key_pair.key_pair_ec2.key_name
  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(
    {
      "Name"      = "${var.ec2_name_bastion}-${var.environment}-${var.customer_name}"
      "Role"      = "${var.ec2_bastion_role}" 
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

  disable_api_termination= false # change me
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.id
  user_data = templatefile("../dependencies/templates/win_boot.ps1.tpl", {uname = var.ec2_username, sm_key = local.sm_key}) #must match security.tf value
  #user_data = templatefile("./dependencies/templates/win_boot.ps1.tpl", {uname = var.ec2_username, pass = random_password.ec2_pw.result})
  key_name           = aws_key_pair.key_pair_ec2.key_name
  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(
    {
      "Name"            = "${var.ec2_name_windows}-${var.environment}-${var.customer_name}"
      "Role"            = "${var.ec2_windows_role}" 
      "${var.ssm_boot}" = "${var.win_configure_service_1}"
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
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.id
  user_data = templatefile("../dependencies/templates/rhel_boot.sh.tpl", {uname = var.ec2_username, pass = random_password.ec2_pw.result, region = var.aws_region })
  key_name           = aws_key_pair.key_pair_ec2.key_name
  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(
    {
      "Name"            = "${var.ec2_name_linux}-${var.environment}-${var.customer_name}"
      "Role"            = "${var.ec2_linux_role}" 
      "${var.ssm_boot}" = "${var.lin_configure_service_1}"
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
