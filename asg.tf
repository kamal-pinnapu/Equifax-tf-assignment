# Retrieve bootstrap script
data "aws_s3_bucket_object" "user_data" {
  bucket = "${aws_s3_bucket.s3_httpd.id}"
  key    = "httpd.sh"
  depends_on = ["aws_s3_bucket.s3_httpd"]
}

# Launch Configuration
resource "aws_launch_configuration" "equifax_lc" {
    name            = "equifax_lc"
    image_id        = "${var.image_id}"
    instance_type   = "${var.instance_type}"
    security_groups = ["${aws_security_group.webserver.id}"]
   # user_data       = "${data.aws_s3_bucket_object.user_data.id}"
    user_data = "${file("./httpd.sh")}"
    
    key_name        = "prod"
    ebs_block_device = [
    {
        device_name           = "/dev/xvdz"
        volume_type           = "gp2"
        volume_size           = "${var.vol_size}"
        delete_on_termination = true
    },
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "equifax_webserver" {
    name                      = "equifax_asg"
    max_size                  = 2
    min_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "ELB"
    desired_capacity          = 2
    force_delete              = true
    launch_configuration      = "${aws_launch_configuration.equifax_lc.id}"
    vpc_zone_identifier       = ["${aws_subnet.equifax_private.*.id}"]
    tags {
        key = "Name"
        value = "${var.instance_name}"
        propagate_at_launch = true
    }
}
# Attach ELB to Auto Scaling Group
resource "aws_autoscaling_attachment" "equifax_asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.equifax_webserver.id}"
  elb                    = "${aws_elb.equifax-elb.id}"
}