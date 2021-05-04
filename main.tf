provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_security_group" "mob-sg" {
  name = "mob_secgroupname"

  // Open traffic from everywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "mob-key" {
  key_name   = "mob-key"
  public_key = file("./keys/mob_key.pub")
}

resource "aws_instance" "mob-machines" {
  ami                         = "ami-0fbc0724a0721c688"
  count                       = var.number_of_machines
  instance_type               = "t2.large"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.mob-key.key_name

  vpc_security_group_ids = [
    aws_security_group.mob-sg.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 150
    volume_type           = "gp2"
  }

  tags = {
    Name = "mob-server-${count.index}"
  }

  depends_on        = [aws_security_group.mob-sg]
  get_password_data = "true"
  user_data         = <<EOF
<powershell>
        iwr -useb https://raw.githubusercontent.com/JayBazuzi/machine-setup/main/dev_environments/java.ps1 | iex
        New-Item -Path 'C:\Users\Administrator\Desktop\DONE.txt' -ItemType File
        echo xyz | anydesk --set-password
        Restart-Computer -Force
</powershell>
EOF
}

output "Machines" {
  value = [for machine in aws_instance.mob-machines : "${machine.tags.Name} ${machine.public_ip} ${rsadecrypt(machine.password_data, file("./keys/mob_key"))}"]
}