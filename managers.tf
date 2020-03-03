resource "aws_instance" "docker_swarm_manager" {
	#count          = 1
  	#name           = "${terraform.workspace}-manager-${count.index + 1}"
	ami            = "${var.ami}"
	instance_type  = "${var.manager_instance_type}"
  	security_groups = [ "${aws_security_group.swarm_manager.id}" ]
  	#private_ip    = "${element(aws_instance.docker_swarm_manager.0.private_ip, count.index)}"
	key_name       = "${aws_key_pair.deployer.key_name}"
	subnet_id      = "${var.subnet}"

	connection {
    	type = "ssh"
    	user = "ec2-user"
		private_key = "${file("~/.ssh/id_rsa")}"
		port = 22
		timeout = "90m"
	}

 	provisioner "remote-exec" {
    	inline = [
		"sudo mkdir -p /etc/systemd/system/docker.service.d",
    	]
  	}
	provisioner "file" {
    	content     = "${data.template_file.docker_conf.rendered}",
    	destination = "/tmp/docker.conf",
  	}
	provisioner "file" {
		source      = "scripts/cdos-yum.repo",
    	destination = "/tmp/cdos-yum.repo",
  	}
	provisioner "file" {
		source      = "scripts/install-docker-ce.sh",
    	destination = "/tmp/install-docker-ce.sh",
  	}
	provisioner "remote-exec" {
	inline = [
		"sudo cp /tmp/docker.conf /etc/systemd/system/docker.service.d/docker.conf",
		"sudo cp /tmp/cdos-yum.repo /etc/yum.repos.d/cdos-yum.repo",
		"chmod +x /tmp/install-docker-ce.sh",
		"sudo /tmp/install-docker-ce.sh ${var.docker_version}",
		"sudo docker swarm init --advertise-addr ${self.private_ip}",
		]
 	}

	user_data = "${data.template_cloudinit_config.efs-mnt.rendered}"
	
/*
	#user_data = "${file("scripts/efs.sh" ${aws_efs_file_system.efs_docker.id})}"
	root_block_device {
		volume_type = "gp2"
	}

	# user data
	# user_data = "${data.template_cloudinit_config.cloudinit-example.rendered}"
	
	provisioner "file" {
		source      = "scripts/efs1.sh",
    	destination = "/tmp/efs1.sh",
  	}

	provisioner "remote-exec" {
	inline = [
		"chmod +x /tmp/efs1.sh",
		"sudo /tmp/efs1.sh ${aws_efs_file_system.efs_docker.id}",
		]
 	}
	# user data, fire the files
	#user_data = "${file("scripts/efs.sh", ${aws_efs_file_system.efs_docker.id})}"
*/

	tags = {
		Name = "${var.docker_master_tag}"
		BillingID = "CIT"
		Service = "CDS"
		Project = "CDS"
	}
}

