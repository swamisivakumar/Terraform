
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::my-tf-test-bucket-ubsallinace/ubs/*"
        }
    ]
})
}


resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}








resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket-ubsallinace"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_spot_instance_request" "Worker_Node" {
  ami           = "ami-0c2b8ca1dad447f8a" 
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
   tags = {
    Name = "CheapWorker_Node"
  }
  subnet_id     = "subnet-012705559ccc8f44f"
  security_groups = ["sg-0bd55fefeefca9538"]
  key_name = "DEVOPS_NEW"
}









