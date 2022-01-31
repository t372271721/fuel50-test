data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_network_interface" "web-server" {
  subnet_id       = aws_subnet.fuel50-vpc-public-1.id
  private_ips     = ["10.0.1.50"]
#  security_groups = [aws_security_group.fuel50-allow-vpc.id]
}
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.fuel50-gw]
}

resource "aws_instance" "fuel50-instance-1" {
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t2.micro"
  availability_zone = "ap-southeast-2a"
  
  

  tags = {
    "Name" = "fuel50-instance-1"
  }
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server.id
  }
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
    EOF

}

