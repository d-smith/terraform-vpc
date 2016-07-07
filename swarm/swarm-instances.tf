resource "aws_instance" "swarm-leader" {
    # Currently this assumes US-WEST-1
    ami = "ami-05384865"
    
    instance_type = "t2.micro"
    key_name = "${var.key_name}"

    # Assume 3 - 1 master, two workers
    count = "1"

    subnet_id = "${var.swarm_subnet_id}"
    vpc_security_group_ids = ["${aws_security_group.swarm.id}"]


    #Instance tags
    tags {
        Name = "swarm-leader-${count.index}"
    }

    connection {
        user = "ubuntu"
        key_file = "${var.key_path}"
    }

     provisioner "remote-exec" {
        scripts = [
            "${path.module}/install-swarm.sh",
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "docker swarm init",
        ]
    }
}

resource "aws_instance" "swarm-worker" {
    # Currently this assumes US-WEST-1
    ami = "ami-05384865"
    
    instance_type = "t2.micro"
    key_name = "${var.key_name}"

    # Assume 1 master, two workers
    count = "2"

    subnet_id = "${var.swarm_subnet_id}"
    vpc_security_group_ids = ["${aws_security_group.swarm.id}"]


    #Instance tags
    tags {
        Name = "swarm-worker-${count.index}"
    }

    connection {
        user = "ubuntu"
        key_file = "${var.key_path}"
    }

     provisioner "remote-exec" {
        scripts = [
            "${path.module}/install-swarm.sh",
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "docker swarm join ${aws_instance.swarm-leader.private_ip}:2377",
        ]
    }
}

resource "aws_security_group" "swarm" {
    name = "swarm_ubuntu"
    description = "Consul internal traffic + maintenance."
    vpc_id = "${var.swarm_vpc_id}"

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