provider "aws" {
  region = var.aws_region
}

# สร้าง Key Pair ใหม่และบันทึก Private Key ลงไฟล์ (เฉพาะถ้ายังไม่มี)
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
 
  # ป้องกันการแทนที่ Key Pair เดิมถ้ามีอยู่แล้วใน AWS หรือ State
  lifecycle {
    ignore_changes = [public_key]
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
 
  # ป้องกันการสร้างไฟล์ใหม่หากมีอยู่แล้ว (ในระดับ Logic ของ Terraform คือถ้า Content เปลี่ยนถึงจะแก้)
  # แต่ tls_private_key ปกติจะเสถียรใน State file
}

resource "aws_security_group" "app_sg" {
  name_prefix = "app_sg"
  description = "Security Group for App and DB"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. สร้าง Database (RDS) โดยใช้ Variables
resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = "root"
  password               = var.db_password # ดึงจาก Variable
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  skip_final_snapshot    = true
}

locals {
  db_host = aws_db_instance.mysql_db.address
}

# 4. สร้าง EC2 โดยใช้ Variables
resource "aws_instance" "nodejs_server" {
  ami                    = "ami-0e5b9e1afa5e50e27"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1

    sleep 30

    apt-get update -y
    apt-get install -y curl git

    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs

    cd /home/ubuntu

    git clone https://github.com/suthasinee66/devops68-text-to-morse.git
    cd devops68-text-to-morse

    npm install

    # บังคับให้ listen ทุก IP
    export HOST=0.0.0.0
    export PORT=3030

    nohup npm start > app.log 2>&1 &
    EOF

  user_data_replace_on_change = true
}