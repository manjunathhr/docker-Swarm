variable "docker_version" {
	default = "19.43-ce"
}
variable "ami" {
	default = "ami-082f38c5390fec046"
}
variable "region" {
	default = "eu-west-2"
}
variable "subnet" {
	default = "subnet-095cf6c404cfd88a6"
}
variable "manager_instance_type" {
	default = "t2.small"
}
variable "worker_instance_type" {
	default = "t2.small"
}
variable "worker_instance_count" {
	default = 1
}
variable "docker_api_ip" {
  default = "127.0.0.1"
}
variable "vpc-id" {
  default = "vpc-0452fbf8d61e7812b"
}
variable "docker_master_tag" {
  default = "docker-swarm-master"
}
variable "docker_slave_tag" {
  default = "docker-swarm-slave"
}
variable "slave_vol_name" {
  default = "/dev/svdh"
}
variable "efs_namei_id" {
  default = "emp"
}
variable "master_vol_name" {
  default = "/dev/mvdh"
}
