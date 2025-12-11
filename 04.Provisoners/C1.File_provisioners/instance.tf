resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id  ]
  tags = {
    "Name" = "EC2 Demo-2"
  }

  # Local provisioner to set correct permissions on SSH key
  provisioner "local-exec" {
    command = "chmod 400 terraform-key.pem"
  }

  # Connection block for provisioners
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("terraform-key.pem")
    host        = self.public_ip
  }

  # File provisioner to copy HTML file
  provisioner "file" {
    source      = "app/index.html"
    destination = "/tmp/index.html"
  }

  # Remote provisioner to install and configure web server
  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo cp /tmp/index.html /var/www/html"
     ]
  }
}

# after deployed the ec2 machine you will see ip address of the ec2 machine let's connect to the machine
# via using below command in command line 
# ssh -i terraform-key.pem ec2-user@ip_address 
# you will able to connect to host by using connection block.