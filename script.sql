CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Criação do esquema do banco de dados para e-commerce

-- Remover tabelas existentes para garantir um ambiente limpo (opcional, para testes)
DROP TABLE IF EXISTS Produto_Vendedor;
DROP TABLE IF EXISTS Fornecedor_Produto;
DROP TABLE IF EXISTS Produto_Estoque;
DROP TABLE IF EXISTS Produto_Pedido;
DROP TABLE IF EXISTS Entrega;
DROP TABLE IF EXISTS Pagamento;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Cliente_PF;
DROP TABLE IF EXISTS Cliente_PJ;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Fornecedor;
DROP TABLE IF EXISTS Vendedor;


-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    Endereco VARCHAR(255) NOT NULL,
    Contato VARCHAR(45) NOT NULL,
    TipoCliente ENUM('PF', 'PJ') NOT NULL
);

-- Tabela Cliente Pessoa Física (PF)
CREATE TABLE Cliente_PF (
    idCliente INT PRIMARY KEY,
    NomeCompleto VARCHAR(100) NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    CONSTRAINT fk_cliente_pf FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Cliente Pessoa Jurídica (PJ)
CREATE TABLE Cliente_PJ (
    idCliente INT PRIMARY KEY,
    RazaoSocial VARCHAR(100) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE,
    CONSTRAINT fk_cliente_pj FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Produto
CREATE TABLE Produto (
    idProduto INT PRIMARY KEY AUTO_INCREMENT,
    NomeProduto VARCHAR(100) NOT NULL,
    Descricao VARCHAR(255),
    Valor DECIMAL(10, 2) NOT NULL,
    Categoria VARCHAR(45) NOT NULL
);

-- Tabela Pedido
CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    StatusPedido ENUM('Em processamento', 'Processado', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Em processamento',
    Descricao VARCHAR(255),
    Frete DECIMAL(10, 2) DEFAULT 0,
    DataPedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Entrega
CREATE TABLE Entrega (
    idEntrega INT PRIMARY KEY AUTO_INCREMENT,
    idPedido INT UNIQUE NOT NULL,
    StatusEntrega ENUM('Preparando envio', 'Em transporte', 'Saiu para entrega', 'Entregue', 'Problema na entrega') DEFAULT 'Preparando envio',
    CodigoRastreio VARCHAR(45) UNIQUE NOT NULL,
    DataEstimadaEntrega DATE,
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    idPagamento INT PRIMARY KEY AUTO_INCREMENT,
    idPedido INT NOT NULL,
    TipoPagamento VARCHAR(45) NOT NULL, -- Ex: Cartão de Crédito, Boleto, Pix
    ValorPagamento DECIMAL(10, 2) NOT NULL,
    DataPagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);

-- Tabela Estoque
CREATE TABLE Estoque (
    idEstoque INT PRIMARY KEY AUTO_INCREMENT,
    Local VARCHAR(255) NOT NULL
);

-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    idFornecedor INT PRIMARY KEY AUTO_INCREMENT,
    RazaoSocial VARCHAR(100) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE,
    Contato VARCHAR(45)
);

-- Tabela Vendedor
CREATE TABLE Vendedor (
    idVendedor INT PRIMARY KEY AUTO_INCREMENT,
    RazaoSocial VARCHAR(100) NOT NULL,
    NomeFantasia VARCHAR(100),
    CNPJ CHAR(14) NOT NULL UNIQUE,
    Local VARCHAR(255),
    Contato VARCHAR(45)
);

-- Tabelas de Relacionamento N:M

-- Produto_Pedido (Itens do Pedido)
CREATE TABLE Produto_Pedido (
    idProduto INT NOT NULL,
    idPedido INT NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idProduto, idPedido),
    CONSTRAINT fk_prodped_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_prodped_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);

-- Produto_Estoque
CREATE TABLE Produto_Estoque (
    idProduto INT NOT NULL,
    idEstoque INT NOT NULL,
    Quantidade INT NOT NULL,
    PRIMARY KEY (idProduto, idEstoque),
    CONSTRAINT fk_prod_est_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_prod_est_estoque FOREIGN KEY (idEstoque) REFERENCES Estoque(idEstoque)
);

-- Fornecedor_Produto
CREATE TABLE Fornecedor_Produto (
    idFornecedor INT NOT NULL,
    idProduto INT NOT NULL,
    PRIMARY KEY (idFornecedor, idProduto),
    CONSTRAINT fk_forn_prod_fornecedor FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor),
    CONSTRAINT fk_forn_prod_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
);

-- Produto_Vendedor
CREATE TABLE Produto_Vendedor (
    idProduto INT NOT NULL,
    idVendedor INT NOT NULL,
    PrecoVenda DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idProduto, idVendedor),
    CONSTRAINT fk_prod_vend_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_prod_vend_vendedor FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor)
);

-- Inserção de dados para testes

-- Clientes
INSERT INTO Cliente (Endereco, Contato, TipoCliente) VALUES
('Rua A, 123, Cidade X', '11987654321', 'PF'),
('Av. B, 456, Cidade Y', '21998765432', 'PJ'),
('Rua C, 789, Cidade Z', '31976543210', 'PF'),
('Travessa D, 101, Cidade W', '41965432109', 'PJ'),
('Praça E, 202, Cidade K', '51954321098', 'PF');

-- Clientes PF
INSERT INTO Cliente_PF (idCliente, NomeCompleto, CPF) VALUES
(1, 'João Silva', '11122233344'),
(3, 'Maria Souza', '55566677788'),
(5, 'Carlos Pereira', '99900011122');

-- Clientes PJ
INSERT INTO Cliente_PJ (idCliente, RazaoSocial, CNPJ) VALUES
(2, 'Tech Solutions Ltda.', '00111222000133'),
(4, 'Fast Delivery S.A.', '44555666000177');

-- Produtos
INSERT INTO Produto (NomeProduto, Descricao, Valor, Categoria) VALUES
('Smartphone X', 'Celular de última geração', 2500.00, 'Eletrônicos'),
('Notebook Gamer', 'Notebook de alta performance para jogos', 7000.00, 'Eletrônicos'),
('Mouse Sem Fio', 'Mouse ergonômico para produtividade', 150.00, 'Acessórios'),
('Teclado Mecânico', 'Teclado com switches mecânicos RGB', 300.00, 'Acessórios'),
('Smart TV 55"', 'TV inteligente 4K', 3500.00, 'Eletrônicos');

-- Pedidos
INSERT INTO Pedido (idCliente, StatusPedido, Descricao, Frete) VALUES
(1, 'Entregue', 'Pedido de celular e acessórios', 25.00),
(2, 'Em processamento', 'Pedido de notebooks para a empresa', 50.00),
(3, 'Enviado', 'Pedido de TV para sala', 35.00),
(1, 'Processado', 'Pedido adicional de acessórios', 15.00),
(5, 'Cancelado', 'Pedido de teste', 0.00);

-- Entregas
INSERT INTO Entrega (idPedido, StatusEntrega, CodigoRastreio, DataEstimadaEntrega) VALUES
(1, 'Entregue', 'BR123456789BR', '2025-07-10'),
(3, 'Saiu para entrega', 'BR987654321BR', '2025-07-08');

-- Pagamentos
INSERT INTO Pagamento (idPedido, TipoPagamento, ValorPagamento) VALUES
(1, 'Cartão de Crédito', 2675.00),
(1, 'Pix', 50.00), -- Exemplo de mais de uma forma de pagamento para um pedido
(2, 'Boleto', 7050.00),
(3, 'Cartão de Crédito', 3535.00);

-- Estoques
INSERT INTO Estoque (Local) VALUES
('São Paulo - SP'),
('Rio de Janeiro - RJ'),
('Belo Horizonte - MG');

-- Fornecedores
INSERT INTO Fornecedor (RazaoSocial, CNPJ, Contato) VALUES
('Eletronics Supply Co.', '11222333000144', 'fornecedor1@email.com'),
('Gadget Distribuidora', '22333444000155', 'fornecedor2@email.com');

-- Vendedores
INSERT INTO Vendedor (RazaoSocial, NomeFantasia, CNPJ, Local, Contato) VALUES
('E-Vendas Online Ltda.', 'E-Vendas', '33444555000166', 'Curitiba - PR', 'vendas@ecom.com'),
('MegaTech Vendas', 'MegaTech', '44555666000177', 'Porto Alegre - RS', 'contato@megatech.com.br'); -- CNPJ igual ao de uma PJ, para teste de query

-- Produto_Pedido
INSERT INTO Produto_Pedido (idProduto, idPedido, Quantidade) VALUES
(1, 1, 1),
(3, 1, 1),
(2, 2, 2),
(5, 3, 1),
(3, 4, 2);

-- Produto_Estoque
INSERT INTO Produto_Estoque (idProduto, idEstoque, Quantidade) VALUES
(1, 1, 100),
(2, 1, 50),
(3, 2, 200),
(4, 3, 150),
(5, 1, 75);

-- Fornecedor_Produto
INSERT INTO Fornecedor_Produto (idFornecedor, idProduto) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(1, 5);

-- Produto_Vendedor
INSERT INTO Produto_Vendedor (idProduto, idVendedor, PrecoVenda) VALUES
(1, 1, 2600.00),
(2, 1, 7200.00),
(3, 2, 160.00),
(5, 1, 3600.00);

SELECT
    C.idCliente,
    CASE
        WHEN C.TipoCliente = 'PF' THEN CPF.NomeCompleto
        WHEN C.TipoCliente = 'PJ' THEN CPJ.RazaoSocial
    END AS NomeCliente,
    COUNT(P.idPedido) AS TotalPedidos
FROM Cliente AS C
LEFT JOIN Cliente_PF AS CPF ON C.idCliente = CPF.idCliente
LEFT JOIN Cliente_PJ AS CPJ ON C.idCliente = CPJ.idCliente
JOIN Pedido AS P ON C.idCliente = P.idCliente
GROUP BY C.idCliente, NomeCliente
HAVING TotalPedidos > 1;