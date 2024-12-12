# Launch Template referencing AMI
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-launch-template-"
  image_id      = aws_ami_from_instance.webserver_1_ami.id # Reference the AMI from ami.tf
  instance_type = "t2.micro"
  key_name      = "vockey"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  tags = {
    Name = "AutoScalingInstance"
  }
}
