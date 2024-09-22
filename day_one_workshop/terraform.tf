provider "aws" {
  region = "us-east-1"

}



variable "Environment" {}
variable "Owner" {}


resource "aws_vpc" "day_one_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "day_one_vpc"
    Environment = var.Environment
    Owner       = var.Owner
  }

}
resource "aws_subnet" "day_one_subnet" {
  vpc_id            = aws_vpc.day_one_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "day_one_subnet"
    Environment = var.Environment
    Owner       = var.Owner
  }
}

resource "aws_internet_gateway" "day_one_gateway" {
  vpc_id = aws_vpc.day_one_vpc.id

  tags = {
    Name        = "day_one_gateway"
    Environment = var.Environment
    Owner       = var.Owner
  }
}


resource "aws_route_table" "day_one_route_table" {
  vpc_id = aws_vpc.day_one_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.day_one_gateway.id
  }

  tags = {
    Name        = "day_one_route_table"
    Environment = var.Environment
    Owner       = var.Owner
  }
}
