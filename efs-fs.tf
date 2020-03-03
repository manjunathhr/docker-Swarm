resource "aws_efs_file_system" "efs_docker" {
	creation_token 		= "efs_docker"
	performance_mode 	= "generalPurpose"
	encrypted 			= "true"
	
	tags {
		Name 			= "efs-shared-data"
		BillingID 		= "CIT"
		Project 		= "CDS"
		Service 		= "CDS"
	}
}

resource "aws_efs_mount_target" "efs-mnt-master" {
	file_system_id 		= "${aws_efs_file_system.efs_docker.id}"
	subnet_id      		= "${var.subnet}"
	security_groups 	= ["${aws_security_group.efs-access.id}"]

}

data "template_file" "efs" {
	template = "${file("scripts/efs.sh")}"
	
	vars = {
		REGION = "${var.region}"
		efsid = "${aws_efs_file_system.efs_docker.id}"
	}
}

data "template_cloudinit_config" "efs-mnt" {
	gzip          = true
	base64_encode = true
	
	part {
	 	content_type = "text/x-shellscript"
    	content      = "${data.template_file.efs.rendered}"
	}
}
