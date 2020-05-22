# Bastion Host Security Group
resource "aws_security_group" "bastion" {
  name        = "allow_internal_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${aws_vpc.equifax_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["68.46.58.231/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
  }
}
# Webserver Security Group
resource "aws_security_group" "webserver" {
  name        = "allow_http"
  description = "Allow elb inbound traffic"
  vpc_id      = "${aws_vpc.equifax_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
# ELB security group
resource "aws_security_group" "lb" {
  name        = "allow_http_lb"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.equifax_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
