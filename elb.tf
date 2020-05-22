# Create a new load balancer
resource "aws_elb" "equifax-elb" {
  name               = "equifax-elb"
  subnets = ["${aws_subnet.equifax_public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  tags {
    Name = "${var.elb_name}"
  }
}

# Output lb dns record
output "elb-dns-name" {
  value = "${aws_elb.equifax-elb.dns_name}"
}