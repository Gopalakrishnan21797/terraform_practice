
#for ec-2 instance creation
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

provider "aws" {
  region     = "us-east-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
  alias = "useast2"
}

resource "aws_instance" "us-west-2" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
}  

resource "aws_instance" "us-east-2" {
  ami           = "ami-005e54dee72cc1d00" # us-east-2
  instance_type = "t2.micro"
  provider = aws.useast2
}

resource "aws_s3_bucket" "firstbucket" {
  bucket = "my-s3-terraform-bucket"

  tags = {
    Name        = "terraform bucket"
    Environment = "Dev-env"
  }
  versioning{
        enabled = true
        }
}

resource "aws_vpc" "dev" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "sub" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dev-subnet"
  }
}

resource "aws_db_instance" "pro_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.19"
  instance_class       = "db.t3.micro"
  name                 = "myterraformdb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
