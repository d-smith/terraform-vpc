variable "region" {
    default = "us-west-1"
    description = "The region of AWS, for AMI lookups."
}

variable "key_name" {}
variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {}
variable "swarm_subnet_id" {}
variable "swarm_vpc_id" {}