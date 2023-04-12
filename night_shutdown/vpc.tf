data "aws_vpc" "ng-eks" {
  tags = {
    Name = "ng-eks-vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.ng-eks.id}"
  tags = {
    Type = "Public"
  }
}