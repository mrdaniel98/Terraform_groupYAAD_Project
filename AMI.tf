# Create AMI from Webserver 1
resource "aws_ami_from_instance" "webserver_1_ami" {
  name               = "Webserver1-AMI-${formatdate("YYYY-MM-DD", timestamp())}" # Valid name format
  source_instance_id = "i-091b16235ff8e3add" # Instance ID of Webserver 1
  tags = {
    Name = "Webserver1AMI"
  }
}
