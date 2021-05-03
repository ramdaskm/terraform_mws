/*====
The VPC
======*/


resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-vpc"
    Environment = "${var.common_prefix}"
  })
}


/*====
Subnets
======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-igw"
    Environment = "${var.common_prefix}"
  })
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip"  {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-eip"
    Environment = "${var.common_prefix}"
  })
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id 
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"

  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-nat"
    Environment = "${var.common_prefix}"
  })
  
  depends_on    = [aws_internet_gateway.ig]
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id 
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.common_prefix}"
  })
  depends_on = [aws_internet_gateway.ig]
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id 
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags = merge(var.tags, 
  {
    Name        = "${var.prefix}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.common_prefix}"
  })
}



/* Routing table for public subnet */
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.vpc.id
  depends_on = [aws_subnet.public_subnet]
  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-pubroute"
    Environment = "${var.common_prefix}"
  })  
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.public.id
  depends_on = [aws_route_table.public]
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
  

  depends_on = [aws_route_table.public]
}



/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, 
  {
    Name        = "${var.prefix}-pvtroute"
    Environment = "${var.common_prefix}"
  })   
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route" "private_nat_gateway" {

  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
   
}

/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {

  name        = "${var.common_prefix}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]

  ingress {
    self      = true
    from_port = 0
    to_port = 0
    protocol = -1
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
    self = null
  }

  tags = merge(var.tags, 
  {
    Name        = "${var.common_prefix}-sg"
    Environment = "${var.common_prefix}"
  })
}