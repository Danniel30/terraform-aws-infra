# Região da AWS
variable "region" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "us-west-1"
}

# Bloco CIDR da VPC
variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnets públicas
variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para as subnets públicas"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

# Subnets privadas
variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para as subnets privadas"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

# Tags padrão
variable "default_tags" {
  description = "Tags padrão para todos os recursos"
  type        = map(string)
  default     = {
    Projeto = "Rede-VPC",
    Ambiente = "Dev"
  }
}
