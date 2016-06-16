variable "consul_ami" {
    default = "ami-558fca35"
    description = "Consul ami to use in autolaunch config"
}

variable "consul_vpc_id" {}
variable "consul_zone_a_subnet" {}
variable "key_name" {}