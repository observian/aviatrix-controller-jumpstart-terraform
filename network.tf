
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.application}-${var.env}-vpc"
  }
}

### AZ 1
resource "aws_subnet" "main-public-alpha" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_alpha_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-alpha")

  tags = {
    Name        = "${var.application}-${var.env}-public-alpha",
    Environment = var.env
  }
}

### AZ 2
resource "aws_subnet" "main-public-bravo" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_bravo_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-bravo")

  tags = {
    Name = "${var.application}-${var.env}-public-bravo",
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.application}-${var.env}-igw"
  }
}

resource "aws_route_table" "main-rt-public-alpha" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}

resource "aws_route_table_association" "main-rta-public-alpha" {
  subnet_id      = aws_subnet.main-public-alpha.id
  route_table_id = aws_route_table.main-rt-public-alpha.id
}

resource "aws_route_table" "main-rt-public-bravo" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}

resource "aws_route_table_association" "main-rta-public-bravo" {
  subnet_id      = aws_subnet.main-public-bravo.id
  route_table_id = aws_route_table.main-rt-public-bravo.id
}
