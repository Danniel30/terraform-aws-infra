# 🌐 Infraestrutura AWS com Terraform

Este projeto cria uma infraestrutura básica na AWS utilizando Terraform, incluindo:

- ✅ VPC
- ✅ 2 Subnets Públicas (em AZs diferentes)
- ✅ 2 Subnets Privadas (em AZs diferentes)
- ✅ Internet Gateway
- ✅ 1 NAT Gateway (mais econômico)
- ✅ Tabelas de Roteamento e Associações

---

## 📁 Estrutura dos arquivos

RECURSOS-AWS/
├── main.tf
├── network.tf
├── variables.tf


---

## 📦 Pré-requisitos

- Terraform instalado (versão 1.2.0 ou superior)
- Conta na AWS com acesso programático (access key + secret key)
- PowerShell, CMD, ou terminal Linux/macOS

---

## 🔐 Configurando credenciais AWS

### ✅ Variáveis de ambiente (válido apenas na sessão atual)

No PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID = "SUA_ACCESS_KEY"
$env:AWS_SECRET_ACCESS_KEY = "SUA_SECRET_KEY"
$env:AWS_DEFAULT_REGION = "us-west-1"

🚀 Comandos Terraform
🔧 Inicializar o ambiente Terraform
terraform init

📋 Verificar os recursos que serão criados
terraform plan

🚀 Aplicar o plano (criar infraestrutura)
terraform apply
Digite yes quando solicitado.

🧹 Destruir toda a infraestrutura
terraform destroy
Digite yes quando solicitado.

💡 Observações
As subnets públicas permitem instâncias EC2 com IP público acessarem a internet.

As subnets privadas têm acesso à internet somente via o NAT Gateway.

O projeto utiliza apenas 1 NAT Gateway para reduzir custos (~USD 32/mês).

