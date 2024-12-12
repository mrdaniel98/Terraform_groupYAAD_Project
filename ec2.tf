# Webserver 1 in Public Subnet 1
resource "aws_instance" "webserver_1" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets["0"].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "vockey"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "<h1>Welcome to Webserver 1</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /home/ec2-user/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAz91nhrKozcmoeFZCzflHIAdvCRYYApk+DOjd3vTF5OOzbxZw
OMbAnquGGN07yVIR7P+NnZTQkaKrttqsGhha5qVOn1KVAu7UExTIBLls4JICM+7t
f1fS4hdr7ssn0AtR1xRivoLDNtB9EKbbpClmbBv90Oz98+QbmPx0mvO8XQXf75hc
Dq37/8OWD9ZsnnxLaW9/MjU9gqamasaLJEAfhoxVyQV9t5gVoo1bGeqshJiirbvZ
X3i4MIjQ9xrz+v4Fos8B+gmff4jq/OffxzrEyOwqKMiUzRNdrpfgNTeUBC7QcEMM
SkPEAzgxEXCSaNeKwfmIEYzREHq0jAmy3m/7fQIDAQABAoIBAGqE2vh7tWU/YcXI
7pL+myQeqxfM6qDqRpH3Azut03tn9BuJNBjkQPEOlLlJJcoU9HquurN1/yuiYLxj
cq4srOhk7dVXTGUkXikpDRberpymNdrHJY2MQ9T4i6bjFJPYOSgumitmdwMv8+cE
mqmVTZc5AOh/iePhkQLk3BxLqss/ulDNCHvTlL3HQFKO8g68MaubXd/5hyCruWyF
OM19po4iWfbrqcjdCZjOS/35y1mH31q8MKYHaVv0u6bHl/3ps3GuojQ9GUpH9aHx
fnkAsKnZpTOwbgWF0jPVCL7WEnHc2FA3nNzqE6OGEodphaO1I6AtBF4zQFzo/FiD
Z0uxQ0ECgYEA+S/3HMquAkcitzK1guLbs8e0YhafOCGxkNOgYBf6neQTl3PP3bY3
vLDP3devKeNRI/XGck/PJSiPyp5jfmW3JwEqTjR3DVAd+v+vT+hi8C7B7WcCmm5p
x5OY4nrJKWE9OYl0Rlk/YCar8b4JCVL6GuzMOd/AdvcudelKU9TEgIMCgYEA1Yw6
PV5ftkPwxUx8eNAhYclkNDG6EWAU9i7hlZ9udH6rLKN3esWvPRecR2EquvOUYsTr
rkVDvXLTpWuYnLDzEiKK0QVdSsfcm4PvgMn+a0SXKEmY1rYUnF+6WiWGEUyZdGiT
pLuqnwgi8oIldEA51CrpdZ/+nJE87cNQQ7mY0/8CgYEAkU1109UfqHZgeODZ1KuC
Hw/5UCUOzMVg7Clq3/27hqwC/JJsiEUDtUSIwTxOiKdjngtnnyqIiIthZW38aCzZ
oqXcTGPtc9be1IiZaogAgTtSm6Mwcmqlxdl8Ebw1Zqqr78wGACt0eBW0t67vR/+Z
lW+1Gp4tdXFnJxxU2hM8Tg8CgYEAxjeDV7Nh5CzsMDbu0rVeRwZInKoLrFUjH+Ak
RF3YiQmKmcSiArO8FVj1Fsx6fU3bTlK68OgaGJ+dFM7quYcGGK83aw0vq1oYy8GL
bmAQaEEijaLC24nnV78Dmul5qFURm5v2b9JCbZt/1No5Kc7z3px2V1hLXcjyZUAG
INcFpMECgYEAlZHmzO8PGXuvkXXWhXEFzgEq+2tKGMVIkd25VmBPazfEWGifUe2Y
Y89R4SDjRQqQZg2Zsi0qlTfPrMqY50+QCBAZ+cbK4BhkS7tFnjU7zc+46U18iT+f
TMCNPsD7jkScYpe2Ssse+aEMNrm2gUktkGLb7BnbVO3cT0zc/gCWFoM=
-----END RSA PRIVATE KEY----- ec2-user@ip-172-31-67-60.ec2.internal" | sudo tee /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF

  tags = merge(var.tags, { Name = "WebServer1" })
}

# Webserver 2 (Bastion Host) in Public Subnet 2
resource "aws_instance" "bastion_host" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets["1"].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "vockey"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "<h1>Bastion Host</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /home/ec2-user/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCRoej+NGdVn7yoMA5mF/qpIGZMCfKN1JKH3iEx2ctAB1LYa4IA33LK7dpVSjEqPlb83VXeYNhS/GH1i1uc0qRlfjlDACSS6Cwr/cgwGTrNIF4wiZLxbO18mASfrBBTiHMvqbd5zfiZ2+2KDnFWHwtpJLa5B2U+qJ5YY+IiMnOYg56Bl+rDYt+S1kVTFwNEpVq9O6xekgw2boJawZJRt3mJP6o6rJD0e9XvYkTdg/FCnM5+b66fDBYc2SyM2EzXO5EUKhCybfKEKT78bE8BAfG9MfgNmsJe+EG6eGkCZUgMRPbu3Ld/Ij5JYNbJ46yFegAXR1pkcKIsflChUyZe/hVn ec2-user@ip-172-31-67-60.ec2.internal" | sudo tee /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF

  tags = merge(var.tags, { Name = "BastionHost" })
}

# Webserver 3 in Public Subnet 3
resource "aws_instance" "webserver_3" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets["2"].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "vockey"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "<h1>Welcome to Webserver 3</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /home/ec2-user/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAz91nhrKozcmoeFZCzflHIAdvCRYYApk+DOjd3vTF5OOzbxZw
OMbAnquGGN07yVIR7P+NnZTQkaKrttqsGhha5qVOn1KVAu7UExTIBLls4JICM+7t
f1fS4hdr7ssn0AtR1xRivoLDNtB9EKbbpClmbBv90Oz98+QbmPx0mvO8XQXf75hc
Dq37/8OWD9ZsnnxLaW9/MjU9gqamasaLJEAfhoxVyQV9t5gVoo1bGeqshJiirbvZ
X3i4MIjQ9xrz+v4Fos8B+gmff4jq/OffxzrEyOwqKMiUzRNdrpfgNTeUBC7QcEMM
SkPEAzgxEXCSaNeKwfmIEYzREHq0jAmy3m/7fQIDAQABAoIBAGqE2vh7tWU/YcXI
7pL+myQeqxfM6qDqRpH3Azut03tn9BuJNBjkQPEOlLlJJcoU9HquurN1/yuiYLxj
cq4srOhk7dVXTGUkXikpDRberpymNdrHJY2MQ9T4i6bjFJPYOSgumitmdwMv8+cE
mqmVTZc5AOh/iePhkQLk3BxLqss/ulDNCHvTlL3HQFKO8g68MaubXd/5hyCruWyF
OM19po4iWfbrqcjdCZjOS/35y1mH31q8MKYHaVv0u6bHl/3ps3GuojQ9GUpH9aHx
fnkAsKnZpTOwbgWF0jPVCL7WEnHc2FA3nNzqE6OGEodphaO1I6AtBF4zQFzo/FiD
Z0uxQ0ECgYEA+S/3HMquAkcitzK1guLbs8e0YhafOCGxkNOgYBf6neQTl3PP3bY3
vLDP3devKeNRI/XGck/PJSiPyp5jfmW3JwEqTjR3DVAd+v+vT+hi8C7B7WcCmm5p
x5OY4nrJKWE9OYl0Rlk/YCar8b4JCVL6GuzMOd/AdvcudelKU9TEgIMCgYEA1Yw6
PV5ftkPwxUx8eNAhYclkNDG6EWAU9i7hlZ9udH6rLKN3esWvPRecR2EquvOUYsTr
rkVDvXLTpWuYnLDzEiKK0QVdSsfcm4PvgMn+a0SXKEmY1rYUnF+6WiWGEUyZdGiT
pLuqnwgi8oIldEA51CrpdZ/+nJE87cNQQ7mY0/8CgYEAkU1109UfqHZgeODZ1KuC
Hw/5UCUOzMVg7Clq3/27hqwC/JJsiEUDtUSIwTxOiKdjngtnnyqIiIthZW38aCzZ
oqXcTGPtc9be1IiZaogAgTtSm6Mwcmqlxdl8Ebw1Zqqr78wGACt0eBW0t67vR/+Z
lW+1Gp4tdXFnJxxU2hM8Tg8CgYEAxjeDV7Nh5CzsMDbu0rVeRwZInKoLrFUjH+Ak
RF3YiQmKmcSiArO8FVj1Fsx6fU3bTlK68OgaGJ+dFM7quYcGGK83aw0vq1oYy8GL
bmAQaEEijaLC24nnV78Dmul5qFURm5v2b9JCbZt/1No5Kc7z3px2V1hLXcjyZUAG
INcFpMECgYEAlZHmzO8PGXuvkXXWhXEFzgEq+2tKGMVIkd25VmBPazfEWGifUe2Y
Y89R4SDjRQqQZg2Zsi0qlTfPrMqY50+QCBAZ+cbK4BhkS7tFnjU7zc+46U18iT+f
TMCNPsD7jkScYpe2Ssse+aEMNrm2gUktkGLb7BnbVO3cT0zc/gCWFoM=
-----END RSA PRIVATE KEY----- ec2-user@ip-172-31-67-60.ec2.internal" | sudo tee /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF

  tags = merge(var.tags, { Name = "WebServer3" })
}

# Webserver 4 in Public Subnet 1
resource "aws_instance" "webserver_4" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets["0"].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "vockey"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "<h1>Welcome to Webserver 4</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /home/ec2-user/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAz91nhrKozcmoeFZCzflHIAdvCRYYApk+DOjd3vTF5OOzbxZw
OMbAnquGGN07yVIR7P+NnZTQkaKrttqsGhha5qVOn1KVAu7UExTIBLls4JICM+7t
f1fS4hdr7ssn0AtR1xRivoLDNtB9EKbbpClmbBv90Oz98+QbmPx0mvO8XQXf75hc
Dq37/8OWD9ZsnnxLaW9/MjU9gqamasaLJEAfhoxVyQV9t5gVoo1bGeqshJiirbvZ
X3i4MIjQ9xrz+v4Fos8B+gmff4jq/OffxzrEyOwqKMiUzRNdrpfgNTeUBC7QcEMM
SkPEAzgxEXCSaNeKwfmIEYzREHq0jAmy3m/7fQIDAQABAoIBAGqE2vh7tWU/YcXI
7pL+myQeqxfM6qDqRpH3Azut03tn9BuJNBjkQPEOlLlJJcoU9HquurN1/yuiYLxj
cq4srOhk7dVXTGUkXikpDRberpymNdrHJY2MQ9T4i6bjFJPYOSgumitmdwMv8+cE
mqmVTZc5AOh/iePhkQLk3BxLqss/ulDNCHvTlL3HQFKO8g68MaubXd/5hyCruWyF
OM19po4iWfbrqcjdCZjOS/35y1mH31q8MKYHaVv0u6bHl/3ps3GuojQ9GUpH9aHx
fnkAsKnZpTOwbgWF0jPVCL7WEnHc2FA3nNzqE6OGEodphaO1I6AtBF4zQFzo/FiD
Z0uxQ0ECgYEA+S/3HMquAkcitzK1guLbs8e0YhafOCGxkNOgYBf6neQTl3PP3bY3
vLDP3devKeNRI/XGck/PJSiPyp5jfmW3JwEqTjR3DVAd+v+vT+hi8C7B7WcCmm5p
x5OY4nrJKWE9OYl0Rlk/YCar8b4JCVL6GuzMOd/AdvcudelKU9TEgIMCgYEA1Yw6
PV5ftkPwxUx8eNAhYclkNDG6EWAU9i7hlZ9udH6rLKN3esWvPRecR2EquvOUYsTr
rkVDvXLTpWuYnLDzEiKK0QVdSsfcm4PvgMn+a0SXKEmY1rYUnF+6WiWGEUyZdGiT
pLuqnwgi8oIldEA51CrpdZ/+nJE87cNQQ7mY0/8CgYEAkU1109UfqHZgeODZ1KuC
Hw/5UCUOzMVg7Clq3/27hqwC/JJsiEUDtUSIwTxOiKdjngtnnyqIiIthZW38aCzZ
oqXcTGPtc9be1IiZaogAgTtSm6Mwcmqlxdl8Ebw1Zqqr78wGACt0eBW0t67vR/+Z
lW+1Gp4tdXFnJxxU2hM8Tg8CgYEAxjeDV7Nh5CzsMDbu0rVeRwZInKoLrFUjH+Ak
RF3YiQmKmcSiArO8FVj1Fsx6fU3bTlK68OgaGJ+dFM7quYcGGK83aw0vq1oYy8GL
bmAQaEEijaLC24nnV78Dmul5qFURm5v2b9JCbZt/1No5Kc7z3px2V1hLXcjyZUAG
INcFpMECgYEAlZHmzO8PGXuvkXXWhXEFzgEq+2tKGMVIkd25VmBPazfEWGifUe2Y
Y89R4SDjRQqQZg2Zsi0qlTfPrMqY50+QCBAZ+cbK4BhkS7tFnjU7zc+46U18iT+f
TMCNPsD7jkScYpe2Ssse+aEMNrm2gUktkGLb7BnbVO3cT0zc/gCWFoM=
-----END RSA PRIVATE KEY----- ec2-user@ip-172-31-67-60.ec2.internal" | sudo tee /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF

  tags = merge(var.tags, { Name = "WebServer4" })
}

# Webserver 5 in Private Subnet 1
resource "aws_instance" "webserver_5" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnets["0"].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "vockey"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "<h1>Welcome to Webserver 5</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /home/ec2-user/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAz91nhrKozcmoeFZCzflHIAdvCRYYApk+DOjd3vTF5OOzbxZw
OMbAnquGGN07yVIR7P+NnZTQkaKrttqsGhha5qVOn1KVAu7UExTIBLls4JICM+7t
f1fS4hdr7ssn0AtR1xRivoLDNtB9EKbbpClmbBv90Oz98+QbmPx0mvO8XQXf75hc
Dq37/8OWD9ZsnnxLaW9/MjU9gqamasaLJEAfhoxVyQV9t5gVoo1bGeqshJiirbvZ
X3i4MIjQ9xrz+v4Fos8B+gmff4jq/OffxzrEyOwqKMiUzRNdrpfgNTeUBC7QcEMM
SkPEAzgxEXCSaNeKwfmIEYzREHq0jAmy3m/7fQIDAQABAoIBAGqE2vh7tWU/YcXI
7pL+myQeqxfM6qDqRpH3Azut03tn9BuJNBjkQPEOlLlJJcoU9HquurN1/yuiYLxj
cq4srOhk7dVXTGUkXikpDRberpymNdrHJY2MQ9T4i6bjFJPYOSgumitmdwMv8+cE
mqmVTZc5AOh/iePhkQLk3BxLqss/ulDNCHvTlL3HQFKO8g68MaubXd/5hyCruWyF
OM19po4iWfbrqcjdCZjOS/35y1mH31q8MKYHaVv0u6bHl/3ps3GuojQ9GUpH9aHx
fnkAsKnZpTOwbgWF0jPVCL7WEnHc2FA3nNzqE6OGEodphaO1I6AtBF4zQFzo/FiD
Z0uxQ0ECgYEA+S/3HMquAkcitzK1guLbs8e0YhafOCGxkNOgYBf6neQTl3PP3bY3
vLDP3devKeNRI/XGck/PJSiPyp5jfmW3JwEqTjR3DVAd+v+vT+hi8C7B7WcCmm5p
x5OY4nrJKWE9OYl0Rlk/YCar8b4JCVL6GuzMOd/AdvcudelKU9TEgIMCgYEA1Yw6
PV5ftkPwxUx8eNAhYclkNDG6EWAU9i7hlZ9udH6rLKN3esWvPRecR2EquvOUYsTr
rkVDvXLTpWuYnLDzEiKK0QVdSsfcm4PvgMn+a0SXKEmY1rYUnF+6WiWGEUyZdGiT
pLuqnwgi8oIldEA51CrpdZ/+nJE87cNQQ7mY0/8CgYEAkU1109UfqHZgeODZ1KuC
Hw/5UCUOzMVg7Clq3/27hqwC/JJsiEUDtUSIwTxOiKdjngtnnyqIiIthZW38aCzZ
oqXcTGPtc9be1IiZaogAgTtSm6Mwcmqlxdl8Ebw1Zqqr78wGACt0eBW0t67vR/+Z
lW+1Gp4tdXFnJxxU2hM8Tg8CgYEAxjeDV7Nh5CzsMDbu0rVeRwZInKoLrFUjH+Ak
RF3YiQmKmcSiArO8FVj1Fsx6fU3bTlK68OgaGJ+dFM7quYcGGK83aw0vq1oYy8GL
bmAQaEEijaLC24nnV78Dmul5qFURm5v2b9JCbZt/1No5Kc7z3px2V1hLXcjyZUAG
INcFpMECgYEAlZHmzO8PGXuvkXXWhXEFzgEq+2tKGMVIkd25VmBPazfEWGifUe2Y
Y89R4SDjRQqQZg2Zsi0qlTfPrMqY50+QCBAZ+cbK4BhkS7tFnjU7zc+46U18iT+f
TMCNPsD7jkScYpe2Ssse+aEMNrm2gUktkGLb7BnbVO3cT0zc/gCWFoM=
-----END RSA PRIVATE KEY----- ec2-user@ip-172-31-67-60.ec2.internal" | sudo tee /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF

  tags = merge(var.tags, { Name = "WebServer5" })
}

# VM 6 in Private Subnet 2
resource "aws_instance" "vm_6" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnets["1"].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "vockey"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "<h1>Welcome to VM 6</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
mkdir -p /home/ec2-user/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAz91nhrKozcmoeFZCzflHIAdvCRYYApk+DOjd3vTF5OOzbxZw
OMbAnquGGN07yVIR7P+NnZTQkaKrttqsGhha5qVOn1KVAu7UExTIBLls4JICM+7t
f1fS4hdr7ssn0AtR1xRivoLDNtB9EKbbpClmbBv90Oz98+QbmPx0mvO8XQXf75hc
Dq37/8OWD9ZsnnxLaW9/MjU9gqamasaLJEAfhoxVyQV9t5gVoo1bGeqshJiirbvZ
X3i4MIjQ9xrz+v4Fos8B+gmff4jq/OffxzrEyOwqKMiUzRNdrpfgNTeUBC7QcEMM
SkPEAzgxEXCSaNeKwfmIEYzREHq0jAmy3m/7fQIDAQABAoIBAGqE2vh7tWU/YcXI
7pL+myQeqxfM6qDqRpH3Azut03tn9BuJNBjkQPEOlLlJJcoU9HquurN1/yuiYLxj
cq4srOhk7dVXTGUkXikpDRberpymNdrHJY2MQ9T4i6bjFJPYOSgumitmdwMv8+cE
mqmVTZc5AOh/iePhkQLk3BxLqss/ulDNCHvTlL3HQFKO8g68MaubXd/5hyCruWyF
OM19po4iWfbrqcjdCZjOS/35y1mH31q8MKYHaVv0u6bHl/3ps3GuojQ9GUpH9aHx
fnkAsKnZpTOwbgWF0jPVCL7WEnHc2FA3nNzqE6OGEodphaO1I6AtBF4zQFzo/FiD
Z0uxQ0ECgYEA+S/3HMquAkcitzK1guLbs8e0YhafOCGxkNOgYBf6neQTl3PP3bY3
vLDP3devKeNRI/XGck/PJSiPyp5jfmW3JwEqTjR3DVAd+v+vT+hi8C7B7WcCmm5p
x5OY4nrJKWE9OYl0Rlk/YCar8b4JCVL6GuzMOd/AdvcudelKU9TEgIMCgYEA1Yw6
PV5ftkPwxUx8eNAhYclkNDG6EWAU9i7hlZ9udH6rLKN3esWvPRecR2EquvOUYsTr
rkVDvXLTpWuYnLDzEiKK0QVdSsfcm4PvgMn+a0SXKEmY1rYUnF+6WiWGEUyZdGiT
pLuqnwgi8oIldEA51CrpdZ/+nJE87cNQQ7mY0/8CgYEAkU1109UfqHZgeODZ1KuC
Hw/5UCUOzMVg7Clq3/27hqwC/JJsiEUDtUSIwTxOiKdjngtnnyqIiIthZW38aCzZ
oqXcTGPtc9be1IiZaogAgTtSm6Mwcmqlxdl8Ebw1Zqqr78wGACt0eBW0t67vR/+Z
lW+1Gp4tdXFnJxxU2hM8Tg8CgYEAxjeDV7Nh5CzsMDbu0rVeRwZInKoLrFUjH+Ak
RF3YiQmKmcSiArO8FVj1Fsx6fU3bTlK68OgaGJ+dFM7quYcGGK83aw0vq1oYy8GL
bmAQaEEijaLC24nnV78Dmul5qFURm5v2b9JCbZt/1No5Kc7z3px2V1hLXcjyZUAG
INcFpMECgYEAlZHmzO8PGXuvkXXWhXEFzgEq+2tKGMVIkd25VmBPazfEWGifUe2Y
Y89R4SDjRQqQZg2Zsi0qlTfPrMqY50+QCBAZ+cbK4BhkS7tFnjU7zc+46U18iT+f
TMCNPsD7jkScYpe2Ssse+aEMNrm2gUktkGLb7BnbVO3cT0zc/gCWFoM=
-----END RSA PRIVATE KEY----- ec2-user@ip-172-31-67-60.ec2.internal" | sudo tee /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF

  tags = merge(var.tags, { Name = "VM6" })
}
