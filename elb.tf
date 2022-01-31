resource "aws_elb" "fuel50-elb" {
  name               = "fuel50-elb"
  subnets = [aws_subnet.fuel50-vpc-public-1.id,aws_subnet.fuel50-vpc-public-2.id]
#  availability_zones = ["ap-southeast-2a","ap-southeast-2b","ap-southeast-2c"]
  security_groups    = [aws_security_group.fuel50-elb-sg.id]

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
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = [aws_instance.fuel50-instance-1.id]
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    "name" = "fuel50-elb"
  }
}

resource "aws_security_group" "fuel50-elb-sg" {
  name        = "fuel50-elb-sg"
  description = "security group for ELB"
  vpc_id           = aws_vpc.fuel50-vpc.id


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "fuel50-elb-sg"
  }

}

resource "aws_security_group" "fuel50-ec2-sg" {
  name        = "fuel50-ec2-sg"
  description = "security group for EC2"
  vpc_id           = aws_vpc.fuel50-vpc.id


  ingress {
    from_port       = 22
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.fuel50-elb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "fuel50-ec2-sg"
  }

}