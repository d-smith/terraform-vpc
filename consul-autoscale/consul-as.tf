resource "aws_security_group" "consul_sg" {
    name = "consul_sg"
    description = "Consul internal traffic + maintenance."
    vpc_id = "${var.consul_vpc_id}"

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_launch_configuration" "consul_launch" {
    name="consul_launch"
    image_id = "${var.consul_ami}"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.consul_sg.id}"]
}


resource "aws_autoscaling_group" "consul_asg_a" {
  vpc_zone_identifier = ["${var.consul_zone_a_subnet}"]
  name = "consul_asg_a"
  max_size = 2
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.consul_launch.name}"
}

