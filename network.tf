# Cria uma VPC com bloco CIDR grande (65536 IPs)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.default_tags, { Name = "main-vpc" })
}

# Cria um Internet Gateway para permitir acesso à internet a partir das subnets públicas
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Cria 2 subnets públicas (em 2 zonas de disponibilidade diferentes)
# Estas subnets terão IP público atribuído automaticamente
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(var.default_tags, { Name = "public-subnet-${count.index}" })
}

# Cria 2 subnets privadas (também em 2 AZs diferentes)
# Estas subnets não recebem IP público automaticamente
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = merge(var.default_tags, { Name = "private-subnet-${count.index}" })
}

# Cria apenas 1 Elastic IP para ser associado ao NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# Cria um único NAT Gateway para permitir saída à internet das subnets privadas
# O NAT fica em uma das subnets públicas (public[0])
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # NAT na primeira subnet pública

  tags = {
    Name = "nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]  # Garante que o IGW já exista antes de criar o NAT
}

# Cria uma tabela de rota pública com saída para a internet via IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  # Rota para qualquer lugar (internet)
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associa as 2 subnets públicas à tabela de rota pública
resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Cria uma tabela de rota privada com saída para a internet via o único NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"  # Rota para internet
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Associa as 2 subnets privadas à tabela de rota privada
# Todas usam a mesma rota via o NAT Gateway
resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}