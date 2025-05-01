provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "main-vpc"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "main-igw"
    Environment = var.environment
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
  Name                              = "public-subnet-1"
  Environment                       = var.environment
  "kubernetes.io/cluster/buddywise-eks" = "owned"
  "kubernetes.io/role/elb"               = "1"
}
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
  Name                              = "public-subnet-2"
  Environment                       = var.environment
  "kubernetes.io/cluster/buddywise-eks" = "owned"
  "kubernetes.io/role/elb"               = "1"
}
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.az1

  tags = {
  Name                              = "private-subnet-1"
  Environment                       = var.environment
  "kubernetes.io/cluster/buddywise-eks" = "owned"
  "kubernetes.io/role/internal-elb"     = "1"
}
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az2

  tags = {
  Name                              = "private-subnet-2"
  Environment                       = var.environment
  "kubernetes.io/cluster/buddywise-eks" = "owned"
  "kubernetes.io/role/internal-elb"     = "1"
}

}

# NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name        = "nat-gateway"
    Environment = var.environment
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "public-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "private-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# Security Groups
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow HTTP/HTTPS traffic from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "frontend-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow frontend to connect to backend"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "From Frontend"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "backend-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Allow backend to connect to database"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "From Backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "database-sg"
    Environment = var.environment
  }
}

#################RDS###############################

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "main-db-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "mydb"
  engine                  = "postgres"
  engine_version          = "14.17"
  instance_class          = "db.t3.micro"
  username                = "postgresadmin"
  password                = "Password12345"
  parameter_group_name    = "default.postgres14"
  skip_final_snapshot     = true
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.database_sg.id]
  multi_az                = true
  backup_retention_period = 7
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.db_encryption.arn
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true
  tags = {
    Name        = "mydb-instance"
    Environment = var.environment
  }
}

resource "aws_kms_key" "db_encryption" {
  description = "KMS key for RDS database encryption"
  enable_key_rotation = true
  
}


