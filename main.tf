provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_security_group" "mob-sg" {
  name = "mob_secgroupname"

  // Open traffic from everywhere
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "mob-key" {
  key_name   = "mob-key"
  public_key = file("./keys/mob_key.pub")
}

resource "aws_instance" "mob-iac" {
  ami = "ami-0fbc0724a0721c688"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = aws_key_pair.mob-key.key_name

  vpc_security_group_ids = [
    aws_security_group.mob-sg.id
  ]
 
  root_block_device {
    delete_on_termination = true
    volume_size = 150
    volume_type = "gp2"
  }
 
  tags = {
    Name ="MOB SERVER"
    OS = "WINDOWS"
  }

  depends_on = [ aws_security_group.mob-sg ]
  get_password_data = "true"
  user_data = <<EOF
<powershell>
        Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/approvals/ApprovalTests.java.StarterProject/master/install.windows.ps1 | Invoke-Expression
        New-Item -Path 'C:\Users\Administrator\Desktop\DONE.txt' -ItemType File
        Restart-Computer
</powershell>
EOF
}

output "ec2instance" {
  value = aws_instance.mob-iac.public_ip
}

output "Administrator_Password" {
  value = rsadecrypt(aws_instance.mob-iac.password_data, file("./keys/mob_key"))
}