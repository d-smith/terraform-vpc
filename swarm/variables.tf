variable "region" {
    default = "us-west-1"
    description = "The region of AWS, for AMI lookups."
}

variable "key_name" {}
variable "swarm_subnet_id" {}
variable "swarm_vpc_id" {}