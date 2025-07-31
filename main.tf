# Define os provedores necessários e suas versões
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }
  }
  required_version = ">= 1.2.0"
}

# Define o provedor AWS (usando a região us-west-1)
provider "aws" {
  region = var.region
}

# Recupera as zonas de disponibilidade da região (ex: us-west-1a, us-west-1b)
data "aws_availability_zones" "available" {}