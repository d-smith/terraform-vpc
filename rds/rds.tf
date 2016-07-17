module "2x4-oregon" {
 	source="../2x4-oregon"
}

resource "aws_security_group" "postgres" {
  name = "postgres"
  description = "Allow postgres"
  vpc_id =  "${module.2x4-oregon.vpc_id}"

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
    subnet_ids = ["${module.2x4-oregon.private_subnet_a}","${module.2x4-oregon.private_subnet_b}"]
    tags {
        Name = "My DB subnet group"
    }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 5
  engine               = "postgres"
  instance_class       = "db.t2.micro"
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