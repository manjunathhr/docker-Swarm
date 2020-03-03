resource "aws_instance" "docker_swarm_worker" {
	count          = "${var.worker_instance_count}"
  	ami            = "${var.ami}"
  	subnet_id      = "${var.subnet}"
  	key_name       = "${aws_key_pair.deployer.key_name}"
	instance_type  = "${var.worker_instance_type}"
  	security_groups = [ "${aws_security_group.swarm_manager.id}" ]
	subnet_id      = "${var.subnet}"
	
	connection {
		type = "ssh"
		user = "ec2-user"
		private_key = "${file("~/.ssh/id_rsa")}"
		port = 22
		timeout = "3m"

	}
	
	provisioner "remote-exec" {
		inline = [
			"sudo mkdir -p /etc/systemd/system/docker.service.d",
		]
	}
	provisioner "file" {
		content     = "${data.template_file.docker_conf.rendered}"
		destination = "/tmp/docker.conf"
	}
	provisioner "file" {
		source      = "scripts/cdos-yum.repo"
		destination = "/tmp/cdos-yum.repo"
	}
	provisioner "file" {
		source      = "scripts/install-docker-ce.sh"
		destination = "/tmp/install-docker-ce.sh"
	}
	provisioner "remote-exec" {
		inline = [
		"sudo cp /tmp/docker.conf /etc/systemd/system/docker.service.d/docker.conf",
		"sudo cp /tmp/cdos-yum.repo /etc/yum.repos.d/cdos-yum.repo",
		"chmod +x /tmp/install-docker-ce.sh",
		"/tmp/install-docker-ce.sh ${var.docker_version}",
		"sudo /tmp/install-docker-ce.sh ${var.docker_version}",	
		"sudo docker swarm join --token ${data.external.swarm_tokens.result.worker} ${aws_instance.docker_swarm_manager.0.private_ip}:2377",
		]
	}
	user_data = "${data.template_cloudinit_config.efs-mnt.rendered}"

	/*
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
	*/

	tags = {
    	Name = "${var.docker_slave_tag}-${count.index}"
	    BillingID = "CIT"
		Service = "CDS"
		Project = "CDS"
	}
}


data "external" "swarm_tokens" {
	program = ["scripts/fetch-tokens.sh"]
	
	query = {
		host = "${aws_instance.docker_swarm_manager.0.private_ip}"
	}

	depends_on = ["aws_instance.docker_swarm_manager"]
}
