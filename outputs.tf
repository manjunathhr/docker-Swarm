output "swarm_manager_private_ip" {
	value = "${aws_instance.docker_swarm_manager.0.private_ip}"
}

output "swarm_workers_private_id" {
	value = "${aws_instance.docker_swarm_worker.*.id}"
}

output "swarm_workers_private_ip" {
	value = "${aws_instance.docker_swarm_worker.*.private_ip}"
}

output "efs_mount_target_ids" {
	value = "${aws_efs_mount_target.efs-mnt-master.id}"
}

output "efs_file_system_id" 
{
	value = "${aws_efs_file_system.efs_docker.id}"
}

output "workspace" {
	value = "${terraform.workspace}"
}

/*
output "swarm_manager_token" {
	value = "${data.external.swarm_tokens.result["manager"]}"
}

output "swarm_worker_token" {
	value = "${data.external.swarm_tokens.result["worker"]}"
}

output "ebs_master_volume_id" {
    value = "${data.aws_ebs_volume.ebs_master_vol.id}"
}

output "ebs_slave_volume_id" {
    value = "${data.aws_ebs_volume.ebs_slave_vol.*.id}"
}
*/


