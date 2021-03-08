##
variable "db_password" {
  description = "The password for the database"
  type        = string
}
##
variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "msqldb"
}
##
variable "region" {
    description = "region for tf code"
    type        = string
    default     = "us-east-1"
}