provider "aws" {
    region ="ap-southeast-1"
}
#VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags= {
        name = "joel-tf-subnet"
}
}

#Subnet
resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "joel-tf-subnet"
    }
}

#Security Group
resource "aws_security_group" "main" {
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "joel-tf-sg"
    }
}

#EC2
resource "aws_instance" "main"{
    ami = "ami-0df7a207adb9748c7"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.main.id

    vpc_security_group_ids = [aws_security_group.main.id]

    tags = {
        Name = "joel-tf-ec2"
    }
}