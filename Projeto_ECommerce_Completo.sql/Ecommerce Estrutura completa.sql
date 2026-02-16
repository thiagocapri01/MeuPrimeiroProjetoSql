-- ====================================================
-- PROJETO: ANÁLISE DE PERFORMANCE E SAÚDE DO E-COMMERCE
-- AUTOR: Thiago Pereira
-- DATA: 16-02-2026
-- DESCRIÇÃO: Implementação completa do banco de dados
--            seguindo arquitetura em camadas:
--            FUNDAÇÃO > OPERACIONAL > ANALÍTICO > OTIMIZAÇÃO
-- ====================================================
GO

	-- ====================================================
-- FUNDAÇÃO 1.1: Criação do banco de dados
-- ====================================================

-- Verifica se o banco já existe e remove (para começar do zero)
DROP DATABASE IF EXISTS ECommerce;
GO

-- Cria o banco novo
CREATE DATABASE ECommerce;
GO

-- Seleciona o banco para trabalhar
USE ECommerce;
GO

-- ====================================================
-- FUNDAÇÃO 1.1: Tabela Clientes
-- ====================================================

USE ECommerce;
GO

CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    NomeCompleto VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    DataNascimento DATE,
    Genero CHAR(1),
    DataCadastro DATETIME DEFAULT GETDATE(),
    Ativo BIT DEFAULT 1
);
GO

-- ====================================================
-- FUNDAÇÃO 1.1: Tabela Categorias
-- ====================================================
USE ECommerce;
GO

CREATE TABLE Categorias (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Descricao VARCHAR(200),
    Ativo BIT DEFAULT 1,
    DataCriacao DATETIME DEFAULT GETDATE()
);
GO

-- ====================================================
-- FUNDAÇÃO 1.1: Tabela Produtos (com chave estrangeira)
-- ====================================================
USE ECommerce;
GO

CREATE TABLE Produtos (
    ProdutoID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao VARCHAR(500),
    Preco DECIMAL(10,2) NOT NULL,
    Estoque INT NOT NULL DEFAULT 0,
    CategoriaID INT,
    DataCriacao DATETIME DEFAULT GETDATE(),
    Ativo BIT DEFAULT 1,
    
    -- Criando o relacionamento (FOREIGN KEY)
    CONSTRAINT FK_Produtos_Categorias 
        FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);
GO

-- ====================================================
-- FUNDAÇÃO 1.1: Tabela Pedidos
-- ====================================================
USE ECommerce;
GO

CREATE TABLE Pedidos (
    PedidoID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    DataPedido DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Pendente',
    Total DECIMAL(10,2),
    Observacoes VARCHAR(500),
    
    -- Relacionamento com Clientes
    CONSTRAINT FK_Pedidos_Clientes 
        FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);
GO

-- ====================================================
-- FUNDAÇÃO 1.1: Tabela Itens do Pedido (tabela fraca)
-- ====================================================
USE ECommerce;
GO

CREATE TABLE ItensPedido (
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL,
    
    -- Subtotal calculado automaticamente
    Subtotal AS (Quantidade * PrecoUnitario) PERSISTED,
    
    -- Relacionamentos
    CONSTRAINT FK_Itens_Pedidos 
        FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
        
    CONSTRAINT FK_Itens_Produtos 
        FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);
GO

-- ====================================================
-- OPERACIONAL 2.0: Inserindo dados de exemplo
-- ====================================================
USE ECommerce;
GO

-- Inserir Categorias
INSERT INTO Categorias (Nome, Descricao) 
VALUES
('Eletrônicos', 'Produtos eletrônicos em geral'),
('Vestuário', 'Roupas, calçados e acessórios'),
('Alimentos', 'Produtos alimentícios e bebidas'),
('Livros', 'Livros, revistas e publicações'),
('Casa e Decoração', 'Móveis e itens de decoração');
GO

-- ====================================================
-- OPERACIONAL 2.0: Inserindo clientes
-- ====================================================
USE ECommerce;
GO

INSERT INTO Clientes (NomeCompleto, Email, Telefone, DataNascimento, Genero) VALUES
('Thiago Pereira', 'thiago@email.com', '11999990001', '1995-12-22', 'M'),
('Thais Fernandes', 'thais@email.com', '11999990002', '1994-03-03', 'F'),
('Fernando Fernandes', 'fernando@email,com', '11999990003', '2013-10-05', 'M'),
('Bernardo Nascimento', 'bernardo@email.com', '11999990003', '2026-01-17', 'M'),
('João Silva', 'joao@email.com', '11999990004', '1985-03-10', 'M'),
('Maria Santos', 'maria@email.com', '11999990005', '1988-07-30', 'F'),
('Fernando Oliveira', 'fernando@email.com', '11999990006', '1995-11-12', 'M'),
('Ana Costa', 'ana@email.com', '11999990007', '1992-04-25', 'F'),
('Carlos Souza', 'carlos@email.com', '11999990008', '1982-09-18', 'M');
GO

-- ====================================================
-- OPERACIONAL 2.0: Inserindo produtos
-- ====================================================
USE ECommerce;
GO

INSERT INTO Produtos (Nome, Descricao, Preco, Estoque, CategoriaID) VALUES
-- Eletrônicos (CategoriaID = 1)
('Smartphone XYZ', 'Smartphone 128GB, 5G', 2500.00, 50, 1),
('Notebook ABC', '16GB RAM, SSD 512GB', 4500.00, 20, 1),
('Fone de Ouvido', 'Bluetooth, cancelamento de ruído', 350.00, 100, 1),

-- Vestuário (CategoriaID = 2)
('Camiseta Básica', 'Algodão, várias cores', 49.90, 200, 2),
('Calça Jeans', 'Azul, tamanhos P ao GG', 129.90, 80, 2),
('Tênis Esportivo', 'Confortável para corrida', 299.90, 40, 2),

-- Alimentos (CategoriaID = 3)
('Café Especial', 'Grãos selecionados, 500g', 25.90, 150, 3),
('Chocolate Artesanal', '70% cacau, 100g', 15.90, 200, 3),

-- Livros (CategoriaID = 4)
('SQL para Iniciantes', 'Aprenda SQL do zero', 89.90, 30, 4),
('Banco de Dados Avançado', 'Modelagem e performance', 120.00, 25, 4),

-- Casa e Decoração (CategoriaID = 5)
('Abajur Moderno', 'LED, dimmer ajustável', 180.00, 15, 5),
('Jogo de Toalhas', '4 peças, algodão egípcio', 220.00, 30, 5);
GO

-- ====================================================
-- OPERACIONAL 2.0: Inserindo pedidos com itens
-- ====================================================
USE ECommerce;
GO


-- Pedido 1: Thiago (ClienteID=1)
INSERT INTO Pedidos (ClienteID, DataPedido, Status) 
VALUES (1, '15/02/2026 10:30:00', 'Entregue');

DECLARE @Pedido1 INT = SCOPE_IDENTITY();

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES
(@Pedido1, 1, 2, 2500.00),  -- 2 Smartphones
(@Pedido1, 3, 1, 350.00);    -- 1 Fone

UPDATE Pedidos SET Total = (SELECT SUM(Subtotal) FROM ItensPedido WHERE PedidoID = @Pedido1)
WHERE PedidoID = @Pedido1;

-- Pedido 2: Thais (ClienteID=2)
INSERT INTO Pedidos (ClienteID, DataPedido, Status) 
VALUES (2, '15/02/2026 14:45:00', 'Entregue');

DECLARE @Pedido2 INT = SCOPE_IDENTITY();

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES
(@Pedido2, 4, 3, 49.90),   -- 3 Camisetas
(@Pedido2, 5, 1, 129.90),  -- 1 Calça
(@Pedido2, 9, 1, 89.90);   -- 1 Livro SQL

UPDATE Pedidos SET Total = (SELECT SUM(Subtotal) FROM ItensPedido WHERE PedidoID = @Pedido2)
WHERE PedidoID = @Pedido2;

-- Pedido 3: Bernardo (ClienteID=3)
INSERT INTO Pedidos (ClienteID, DataPedido, Status) 
VALUES (3, '16/02/2026 09:00:00', 'Pendente');

DECLARE @Pedido3 INT = SCOPE_IDENTITY();

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES
(@Pedido3, 8, 5, 15.90);    -- 5 Chocolates

UPDATE Pedidos SET Total = (SELECT SUM(Subtotal) FROM ItensPedido WHERE PedidoID = @Pedido3)
WHERE PedidoID = @Pedido3;

-- Pedido 4: João (ClienteID=4)
INSERT INTO Pedidos (ClienteID, DataPedido, Status) 
VALUES (4, '14/02/2026 11:20:00', 'Enviado');

DECLARE @Pedido4 INT = SCOPE_IDENTITY();

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES
(@Pedido4, 2, 1, 4500.00);   -- 1 Notebook

UPDATE Pedidos SET Total = (SELECT SUM(Subtotal) FROM ItensPedido WHERE PedidoID = @Pedido4)
WHERE PedidoID = @Pedido4;

-- Pedido 5: Maria (ClienteID=5)
INSERT INTO Pedidos (ClienteID, DataPedido, Status) 
VALUES (5, '13/02/2026 16:30:00', 'Entregue');

DECLARE @Pedido5 INT = SCOPE_IDENTITY();

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario) VALUES
(@Pedido5, 11, 1, 180.00),   -- 1 Abajur
(@Pedido5, 12, 2, 220.00);   -- 2 Jogos de Toalha

UPDATE Pedidos SET Total = (SELECT SUM(Subtotal) FROM ItensPedido WHERE PedidoID = @Pedido5)
WHERE PedidoID = @Pedido5;
GO

-- ====================================================
-- OPERACIONAL 2.0: Conferindo pedidos e faturamento
-- ====================================================
USE ECommerce;
GO

SELECT COUNT(*) AS TotalPedidos FROM Pedidos;
SELECT FORMAT(SUM(Total), 'C', 'pt-BR') AS Faturamento FROM Pedidos;
GO

-- ====================================================
-- ANALÍTICO 3.0: Ticket médio (valor médio por pedido)
-- ====================================================
USE ECommerce;
GO

SELECT 
    FORMAT(AVG(Total), 'C', 'pt-BR') AS TicketMedio
FROM Pedidos;
GO

-- ====================================================
-- ANALÍTICO 3.0: TOP 1 cliente que mais gastou
-- ====================================================
USE ECommerce;
GO

SELECT TOP 1
    c.NomeCompleto AS Cliente,
    FORMAT(SUM(p.Total), 'C', 'pt-BR') AS TotalGasto
FROM Clientes c
INNER JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.NomeCompleto
ORDER BY SUM(p.Total) DESC;
GO

-- ====================================================
-- ANALÍTICO 3.0: Categoria mais vendida (por receita)
-- ====================================================
USE ECommerce;
GO

SELECT TOP 1
    cat.Nome AS Categoria,
    FORMAT(SUM(i.Subtotal), 'C', 'pt-BR') AS ReceitaGerada
FROM ItensPedido i
INNER JOIN Produtos p ON i.ProdutoID = p.ProdutoID
INNER JOIN Categorias cat ON p.CategoriaID = cat.CategoriaID
GROUP BY cat.Nome
ORDER BY SUM(i.Subtotal) DESC;
GO

-- ====================================================
-- ANALÍTICO 3.0: Produto mais vendido (por quantidade)
-- ====================================================
USE ECommerce;
GO

SELECT TOP 1
    p.Nome AS Produto,
    SUM(i.Quantidade) AS QuantidadeVendida,
    FORMAT(SUM(i.Subtotal), 'C', 'pt-BR') AS ReceitaGerada
FROM ItensPedido i
INNER JOIN Produtos p ON i.ProdutoID = p.ProdutoID
GROUP BY p.Nome
ORDER BY SUM(i.Quantidade) DESC;
GO

-- ====================================================
-- ANALÍTICO 3.0: Distribuição dos status dos pedidos
-- ====================================================
USE ECommerce;
GO

SELECT 
    Status,
    COUNT(*) AS Quantidade,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Pedidos), 'N2') + '%' AS Percentual
FROM Pedidos
GROUP BY Status
ORDER BY Quantidade DESC;
GO

-- ====================================================
-- ANALÍTICO 3.0: Vendas por dia (agrupado)
-- ====================================================
USE ECommerce;
GO

SELECT 
    FORMAT(DataPedido, 'dd/MM/yyyy') AS Dia,
    COUNT(*) AS TotalPedidos,
    FORMAT(SUM(Total), 'C', 'pt-BR') AS FaturamentoDia
FROM Pedidos
GROUP BY FORMAT(DataPedido, 'dd/MM/yyyy')
ORDER BY SUM(Total) DESC;
GO