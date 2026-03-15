resource "aws_instance" "devops_vm" {

  ami           = "ami-0f65fc8c24ec8d2a1"
  instance_type = "t3.large"
  key_name      = "Bastion"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "DevOps-Agent"
  }

  # Upload script to EC2
  provisioner "file" {
    source      = "install.sh"
    destination = "/home/ubuntu/install.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("Bastion.pem")
      host        = self.public_ip
    }
  }

  # Execute the script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install.sh",
      "sudo /home/ubuntu/install.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("Bastion.pem")
      host        = self.public_ip
    }
  }

}
