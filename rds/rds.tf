variable "target_vpc" {}
variable "subnet_az1" {}
variable "subnet_az2" {}


resource "aws_security_group" "postgres" {
  name = "postgres"
  description = "Allow postgres"
  vpc_id = "${var.target_vpc}"

  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["10.0.1.0/24"]
  }


  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["10.0.3.0/24"]
  }

  tags {
    Name = "postgres"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "main"
    description = "Our main group of subnets"
    subnet_ids = ["${var.subnet_az1}","${var.subnet_az2}"]
    tags {
        Name = "My DB subnet group"
    }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 5
  engine               = "postgres"
  instance_class       = "db.t1.micro"
  name                 = "escopy"
  username             = "dbroot"
  password             = "password"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.id}"
  port = "5432"
  publicly_accessible = false
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
  tags = {
    Name = "Event Store Copy DB"
  }
}