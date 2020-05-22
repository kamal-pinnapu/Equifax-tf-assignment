# Create a Bastion Host
resource "aws_instance" "bastion" { 
	ami = "${var.image_id}"
	instance_type = "${var.instance_type}"
	vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
	subnet_id = "${element(aws_subnet.equifax_public.*.id,count.index)}"
    key_name = "bastion"
	tags {
	  Name = "bastion-host"
	}
    lifecycle {
    create_before_destroy = true
  }
}

