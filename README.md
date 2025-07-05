# 🛍️ Projeto de Banco de Dados para E-commerce

Este repositório contém a modelagem lógica, o script SQL de criação de esquema (DDL) e de persistência de dados (DML), além de queries SQL complexas para um cenário de e-commerce. O objetivo é demonstrar a aplicação de conceitos de modelagem de banco de dados, incluindo relacionamentos avançados (como especialização/generalização) e a criação de consultas elaboradas.

---

## 🚀 Sobre o Projeto

Este projeto foi desenvolvido como parte de um desafio para replicar e refinar a modelagem de um banco de dados lógico para um e-commerce. Ele aborda requisitos específicos, como:

- **Clientes PJ e PF**: Uma conta de cliente pode ser Pessoa Jurídica (PJ) ou Pessoa Física (PF), mas não ambas, com atributos específicos para cada tipo.
- **Múltiplas Formas de Pagamento**: Um pedido pode ter mais de uma forma de pagamento associada.
- **Detalhes da Entrega**: As entregas possuem status e código de rastreio.

O esquema foi projetado para ser robusto e flexível, permitindo análises complexas sobre vendas, produtos, clientes e logística.

---

## 🗄️ Modelagem Lógica do Banco de Dados

A modelagem lógica foi concebida para refletir um sistema de e-commerce abrangente, com as seguintes **entidades principais** e seus relacionamentos:

### 📌 Entidades e Atributos Chave

- **Cliente**: `idCliente (PK)`, `Endereco`, `Contato`, `TipoCliente (PF/PJ)`
- **Cliente_PF**: `idCliente (PK, FK)`, `NomeCompleto`, `CPF (UNIQUE)`
- **Cliente_PJ**: `idCliente (PK, FK)`, `RazaoSocial`, `CNPJ (UNIQUE)`
- **Produto**: `idProduto (PK)`, `NomeProduto`, `Descricao`, `Valor`, `Categoria`
- **Pedido**: `idPedido (PK)`, `idCliente (FK)`, `StatusPedido`, `Descricao`, `Frete`, `DataPedido`
- **Entrega**: `idEntrega (PK)`, `idPedido (FK, UNIQUE)`, `StatusEntrega`, `CodigoRastreio (UNIQUE)`, `DataEstimadaEntrega`
- **Pagamento**: `idPagamento (PK)`, `idPedido (FK)`, `TipoPagamento`, `ValorPagamento`, `DataPagamento`
- **Estoque**: `idEstoque (PK)`, `Local`
- **Fornecedor**: `idFornecedor (PK)`, `RazaoSocial`, `CNPJ (UNIQUE)`, `Contato`
- **Vendedor**: `idVendedor (PK)`, `RazaoSocial`, `NomeFantasia`, `CNPJ (UNIQUE)`, `Local`, `Contato`

### 🔗 Relacionamentos (Tabelas Associativas)

- **Produto_Pedido**: `idProduto (FK)`, `idPedido (FK)`, `Quantidade`
- **Produto_Estoque**: `idProduto (FK)`, `idEstoque (FK)`, `Quantidade`
- **Fornecedor_Produto**: `idFornecedor (FK)`, `idProduto (FK)`
- **Produto_Vendedor**: `idProduto (FK)`, `idVendedor (FK)`, `PrecoVenda`

---

## ⚙️ Tecnologias Utilizadas

- **MySQL**: Sistema Gerenciador de Banco de Dados (SGBD) relacional

---

## 🧪 Como Rodar o Projeto

Siga os passos abaixo para configurar e executar o banco de dados em sua máquina:

### ✅ Pré-requisitos

- MySQL Server instalado (ou outro SGBD relacional, com as devidas adaptações no SQL).
- Um cliente SQL (ex: MySQL Workbench, DBeaver, HeidiSQL) para executar os scripts e interagir com o banco.

### 📌 Passo a Passo

#### 1. Crie um Banco de Dados

```sql
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;
```

#### 2. Crie as Tabelas (DDL)

- Localize o arquivo `schema_creation.sql`.
- Copie o conteúdo e execute no seu cliente SQL.

#### 3. Popule as Tabelas (DML)

- Localize o arquivo `data_insertion.sql`.
- Copie o conteúdo e execute no seu cliente SQL.

#### 4. Execute as Queries Complexas

- Localize o arquivo `complex_queries.sql`.
- Copie e execute as queries individualmente em seu cliente SQL.

---

## 📊 Queries SQL Complexas (Exemplos)

O arquivo `complex_queries.sql` contém diversas consultas SQL, como:

- **SELECT Simples**: Recuperações básicas de dados
- **WHERE Statement**: Filtragem com condições
- **Atributos Derivados**: Cálculo de colunas (ex: valor total do pedido)
- **ORDER BY**: Ordenação dos dados
- **HAVING Statement**: Filtragem de grupos
- **JOINs entre Tabelas**:

Exemplos:
- Quantos pedidos foram feitos por cada cliente?
- Algum vendedor também é fornecedor?
- Relação de produtos, fornecedores e estoques
- Relação de nomes dos fornecedores e nomes dos produtos

---

## 🤝 Contribuições

Sinta-se à vontade para explorar o código, sugerir melhorias ou reportar problemas.  
**Sua contribuição é muito bem-vinda!**

---
