locals {
  #############################
  # General
  #############################
  region                 = "us-east-1" #change me
  #############################
  # Security Groups
  #############################
  private_formatted_list = "${formatlist("%s", var.vpc_private_subnets)}"
  public_formatted_list  = "${formatlist("%s", var.vpc_public_subnets)}"
  db_formatted_list      = "${formatlist("%s", var.vpc_db_subnets)}"
  remote_formatted_list  = "${formatlist("%s", var.remote_public_subnets)}"
  # combine the formatted list of parameter together using join
  private_subnet_cidr    = "${join(",", local.private_formatted_list)}"
  db_subnet_cidr         = "${join(",", local.db_formatted_list)}"
  public_subnet_cidr     = "${join(",", local.public_formatted_list)}"
  remote_subnet_cidr     = "${join(",", local.remote_formatted_list)}"
  #############################
  # EC2
  #############################
  #bastion host
  multiple_bastion_instances = {
    one = {
      instance_type     = "t3.micro"
      availability_zone = element(module.vpc.azs, 0)
      subnet_id         = element(module.vpc.public_subnets, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 150
          tags = {
            Name        = "win-root" #chqange me
            IaaC        = "terraform"
            Environment = "dev" #change me
            Owner       = "mygroup" #change me
          }
        }
      ]
    }
  }
  #Windows
  multiple_windows_instances = {
    one = {
      instance_type     = "t3.micro"
      availability_zone = element(module.vpc.azs, 0)
      subnet_id         = element(module.vpc.private_subnets, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 150
          tags = {
            Name        = "win-root" #chqange me
            IaaC        = "terraform"
            Environment = "dev" #change me
            Owner       = "mygroup" #change me
          }
        }
      ]
    }
    two = {
      instance_type     = "t3.micro"
      availability_zone = element(module.vpc.azs, 1)
      subnet_id         = element(module.vpc.private_subnets, 1)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 150
          tags = {
            Name        = "win-root" #chqange me
            IaaC        = "terraform"
            Environment = "dev" #change me
            Owner       = "mygroup" #change me
          }
        }
      ]
    }
    /*
    three = {
      instance_type     = "t3.medium"
      availability_zone = element(module.vpc.azs, 2)
      subnet_id         = element(module.vpc.private_subnets, 2)
    }
    */
  }
 #linux
 multiple_linux_instances = {
    one = {
      instance_type     = "t3.small"
      availability_zone = element(module.vpc.azs, 0)
      subnet_id         = element(module.vpc.private_subnets, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 150
          tags = {
            Name        = "rhel-root" #change me
            IaaC        = "terraform"
            Environment = "dev" #change me
            Owner       = "mygroup" #change me
          }
        }
      ]
    }
    two = {
      instance_type     = "t3.micro"
      availability_zone = element(module.vpc.azs, 1)
      subnet_id         = element(module.vpc.private_subnets, 1)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 150
          tags = {
            Name        = "rhel-root" #change me
            IaaC        = "terraform"
            Environment = "dev" #change me
            Owner       = "mygroup" #change me
          }
        }
      ]
    }
  }
}