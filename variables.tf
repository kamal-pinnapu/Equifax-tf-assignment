variable "aws_region" {
	default = "us-east-1"
}

variable "vpc_cidr" {
	default = "10.0.0.0/21"
}

variable "private_subnet" {
    default = "equifax_pvt_subnet"
}

variable "private_cidr" {
	type = "list"
	default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_azs" {
	type = "list"
	default = ["us-east-1a", "us-east-1b"]
}

variable "private_route_table" {
    default = "equifax_private_rt_table"
}

variable "public_cidr" {
	type = "list"
	default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "public_azs" {
	type = "list"
	default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet" {
    default = "equifax_public_subnet"
}

variable "public_route_table" {
    default = "equifax_public_rt_table"
}

variable "elb_name" {
	default = "equifax_elb"
}

variable "instance_type" {
	default = "t2.micro"
}

variable "image_id" {
	default = "ami-0323c3dd2da7fb37d"
}

variable "vol_size" {
	default = "10"
}

variable "instance_name" {
  default = "webserver"
}







