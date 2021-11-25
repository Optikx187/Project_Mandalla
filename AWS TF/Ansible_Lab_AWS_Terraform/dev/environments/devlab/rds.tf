################################################################################
# RDS Module
################################################################################
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@!"
}
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.1"

  identifier = var.db_identifier

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  family               = var.db_engine_family # DB parameter group
  major_engine_version = var.db_engine_major_version# DB option group
  instance_class       = "db.t3.large"
  
  allocated_storage     = var.db_engine_storage #change me
  max_allocated_storage = var.db_engine_max_storage #change me
  storage_encrypted     = false

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name                   = var.db_name
  username               = var.db_username
  create_random_password = true 
  random_password_length = 16
  #password = random_password.password.result
  port                   = 5432

  multi_az               = true
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group_private.security_group_id]

  maintenance_window              = "Sun:00:00-Sun:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false #change me

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "rds-monitor-role"
  monitoring_role_description           = "Monitor RDS instance"
 
  #update
  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = merge (
    {
      "Name" = format("%s", var.key_name_ec2)
    },
    var.tags,
    var.db_tags,
  )
}