resource "aws_security_group" "swarm_manager" {

	name = "my_swarm"
	description = "Open ports required for Docker Swarm and hosted services"
	vpc_id = "${var.vpc-id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	ingress {
		from_port = 2377
		to_port = 2377
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	ingress {
		from_port = 7946
		to_port = 7946
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	ingress {
		from_port = 7946
		to_port = 7946
		protocol = "udp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	ingress {
		from_port = 4789
		to_port = 4789
		protocol = "udp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	ingress {
		from_port = 2049
		to_port = 2049
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags {
		name = "my_docker_swarm"
		BillingID = "CIT"
		Project = "CDS"
		Service = "CDS"
	}
}

resource "aws_security_group" "efs-access" {

	name = "my_efs_access"
	description = "Open ports required for EFS mount connections"
	vpc_id = "${var.vpc-id}"

	ingress {
		from_port = 2049
		to_port = 2049
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/8"]
	}
	tags {
		name = "my_efs_access"
		BillingID = "CDS"
		Project = "CDS"
		Service = "CDS"
	}

}
