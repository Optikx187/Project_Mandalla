################################################################################
# Security Group Module
################################################################################
module "security_group_private" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = var.private_subnet_sg
  description = "Private and DB subnet traffic"
  vpc_id      = module.vpc.vpc_id 

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh from public subnet"
      cidr_blocks = local.public_subnet_cidr
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "rdp from public subnet"
      cidr_blocks = local.public_subnet_cidr
    },
    {
      rule        = "all-all"
      cidr_blocks =  local.private_subnet_cidr
    },
    {
      rule        = "all-all"
      cidr_blocks =  local.db_subnet_cidr
    },
    /*
    {
      rule        = "ssh-tcp"
      cidr_blocks =  local.public_subnet_cidr
    },
    {
      rule        = "rdp-tcp"
      cidr_blocks =  local.public_subnet_cidr
    },
    {
      rule        = "rdp-udp"
      cidr_blocks =  local.public_subnet_cidr
    },
    */
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

    tags = merge(
    {
      "Name" = "private-${var.environment}-${var.customer_name}"
    },
    var.tags,
    var.sg_tags,
  )
}

module "security_group_public" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = var.public_subnet_sg
  description = "Public subnet traffic"
  vpc_id      = module.vpc.vpc_id 

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "rdp from public subnet"
      cidr_blocks = local.remote_subnet_cidr
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "rdp from public subnet"
      cidr_blocks = local.private_subnet_cidr
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http traffic from internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https traffic from internet"
      cidr_blocks = "0.0.0.0/0"
    },
   /*
    {
      rule        = "rdp-tcp"
      cidr_blocks =  local.remote_subnet_cidr
    },
    {
      rule        = "rdp-udp"
      cidr_blocks =  local.remote_subnet_cidr
    },
    {
      rule        = "rdp-tcp"
      cidr_blocks =  local.private_subnet_cidr
    },
    {
      rule        = "rdp-udp"
      cidr_blocks =  local.private_subnet_cidr
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks =  "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks =  "0.0.0.0/0"
    },
    */
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http traffic to internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https traffic to internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = local.private_subnet_cidr
    },
  ]
    tags = merge(
    {
      "Name" = "public-${var.environment}-${var.customer_name}"
    },
    var.tags,
    var.sg_tags,
  )
}


/*
#############################################################
# Security group which is used as an argument in complete-sg
#############################################################
module "main_sg" {
  source = "../../"

  name        = "main-sg"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_rules       = ["https-443-tcp"]
}

################################################
# Security group with complete set of arguments
################################################
module "complete_sg" {
  source = "../../"

  name        = "complete-sg"
  description = "Security group with all available arguments set (this is just an example)"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Cash       = "king"
    Department = "kingdom"
  }

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.
  ingress_cidr_blocks = ["10.10.0.0/16"]

  ingress_ipv6_cidr_blocks = ["2001:db8::/64"]

  # Prefix list ids to use in all ingress rules in this module.
  # ingress_prefix_list_ids = ["pl-123456"]
  # Open for all CIDRs defined in ingress_cidr_blocks
  ingress_rules = ["https-443-tcp"]

  # Use computed value here (eg, `${module...}`). Plain string is not a real use-case for this argument.
  computed_ingress_rules           = ["ssh-tcp"]
  number_of_computed_ingress_rules = 1

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0,2.2.2.2/32"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "30.30.30.30/32"
    },
    {
      from_port   = 10
      to_port     = 20
      protocol    = 6
      description = "Service name"
      cidr_blocks = "10.10.0.0/20"
    },
  ]

  computed_ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "3.3.3.3/32,${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 15
      to_port     = 25
      protocol    = 6
      description = "Service name with vpc cidr"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  number_of_computed_ingress_with_cidr_blocks = 2

  # Open to IPV6 CIDR blocks (rule or from_port+to_port+protocol+description)
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 300
      to_port          = 400
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "2001:db8::/64"
    },
  ]

  computed_ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 350
      to_port          = 450
      protocol         = "tcp"
      description      = "Service ports (ipv6). VPC ID = ${module.vpc.vpc_id}"
      ipv6_cidr_blocks = "2001:db8::/64"
    },
  ]

  number_of_computed_ingress_with_ipv6_cidr_blocks = 1

  # Open for security group id (rule or from_port+to_port+protocol+description)
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port                = 10
      to_port                  = 10
      protocol                 = 6
      description              = "Service name"
      source_security_group_id = data.aws_security_group.default.id
    },
  ]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.main_sg.security_group_id
    },
    {
      from_port                = 23
      to_port                  = 23
      protocol                 = 6
      description              = "Service name"
      source_security_group_id = module.main_sg.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 2

  # Open for self (rule or from_port+to_port+protocol+description)
  ingress_with_self = [
    {
      rule = "all-all"
    },
    {
      from_port   = 30
      to_port     = 40
      protocol    = 6
      description = "Service name"
      self        = true
    },
    {
      from_port = 41
      to_port   = 51
      protocol  = 6
      self      = true
    },
  ]

  computed_ingress_with_self = [
    {
      from_port   = 32
      to_port     = 43
      protocol    = 6
      description = "Service name. VPC ID: ${module.vpc.vpc_id}"
      self        = true
    },
  ]

  number_of_computed_ingress_with_self = 1

  # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.
  egress_cidr_blocks = ["10.10.0.0/16"]

  egress_ipv6_cidr_blocks = ["2001:db8::/64"]

  # Prefix list ids to use in all egress rules in this module.
  # egress_prefix_list_ids = ["pl-123456"]
  # Open for all CIDRs defined in egress_cidr_blocks
  egress_rules = ["http-80-tcp"]

  computed_egress_rules           = ["ssh-tcp"]
  number_of_computed_egress_rules = 1

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  egress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0,2.2.2.2/32"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "30.30.30.30/32"
    },
    {
      from_port   = 10
      to_port     = 20
      protocol    = 6
      description = "Service name"
      cidr_blocks = "10.10.0.0/20"
    },
  ]

  computed_egress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  number_of_computed_egress_with_cidr_blocks = 1

  # Open to IPV6 CIDR blocks (rule or from_port+to_port+protocol+description)
  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 300
      to_port          = 400
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "2001:db8::/64"
    },
  ]

  computed_egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 55
      to_port          = 66
      protocol         = "tcp"
      description      = "Service ports (ipv6). VPC ID: ${module.vpc.vpc_id}"
      ipv6_cidr_blocks = "2001:db8::/64"
    },
  ]

  number_of_computed_egress_with_ipv6_cidr_blocks = 1

  # Open for security group id (rule or from_port+to_port+protocol+description)
  egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port                = 10
      to_port                  = 10
      protocol                 = 6
      description              = "Service name"
      source_security_group_id = data.aws_security_group.default.id
    },
  ]

  computed_egress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.main_sg.security_group_id
    },
  ]

  number_of_computed_egress_with_source_security_group_id = 1

  # Open for self (rule or from_port+to_port+protocol+description)
  egress_with_self = [
    {
      rule = "all-all"
    },
    {
      from_port   = 30
      to_port     = 40
      protocol    = "tcp"
      description = "Service name"
      self        = true
    },
    {
      from_port = 41
      to_port   = 51
      protocol  = 6
      self      = true
    },
  ]

  computed_egress_with_self = [
    {
      rule = "https-443-tcp"
    },
  ]

  number_of_computed_egress_with_self = 1

  create_timeout = "15m"
  delete_timeout = "45m"
}

*/