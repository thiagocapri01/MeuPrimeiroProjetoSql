USE MeuPrimeiroBanco;
GO

CREATE TABLE clientes (
ClienteID INT IDENTITY(1,1) PRIMARY KEY,
Nome VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE,
Idade INT,
DataCadastro DATETIME DEFAULT GETDATE()
);
GO

SELECT * 
FROM Clientes;

INSERT INTO Clientes (Nome, Email, Idade)
VALUES ('João Silva', 'joão@email.com', 25)

SELECT *
FROM Clientes;

INSERT INTO Clientes (Nome,Email, Idade)
VALUES ('Thiago Pereira', 'thiago@email.com', 30)

INSERT INTO Clientes (Nome, Email, Idade)
VALUES ('Thais Fernandes', 'thais@email.com', 31)

INSERT INTO Clientes (Nome, Email, Idade)
VALUES ('Fernando Fernandes', 'fernando@email.com', 12)

SELECT *
FROM Clientes;

SELECT Nome, Email, Idade
FROM Clientes
WHERE Idade >= 18

SELECT Nome, Email, Idade
FROM Clientes
WHERE Idade = 18

SELECT Nome, Email, Idade
FROM Clientes
WHERE Nome like 'T%'

SELECT Nome, Email, Idade
FROM Clientes
ORDER BY Idade;

UPDATE Clientes
SET Email = 'thiago.pereira@email.com'
WHERE Nome = 'Thiago Pereira'

SELECT *
FROM clientes;

UPDATE Clientes
SET Email = 'thiago.p@email.com'
WHERE ClienteID = 2;

SELECT *
FROM clientes

SELECT * 
FROM Clientes
WHERE Nome = 'Thiago Pereira'

UPDATE clientes
SET Idade = Idade + 1
WHERE Idade >= 18

SELECT *
FROM Clientes

DELETE FROM Clientes
WHERE Nome = 'Fernando Fernandes';

SELECT *
FROM Clientes

UPDATE Clientes 
SET Idade = Idade - 1
WHERE Idade >= 18

INSERT INTO Clientes (Nome, Email, Idade)
VALUES ('Fernando Fernandes', 'fernando@email.com', 12)

SELECT * 
FROM Clientes

DELETE FROM Clientes
WHERE ClienteID = 1

SELECT * 
FROM Clientes

INSERT INTO Clientes (Nome, Email, Idade)
VALUES ('Bernardo Nascimento', 'bernardo.n@email.com', 1)

SELECT *
FROM Clientes

SELECT COUNT(*) AS Totalclientes
FROM Clientes;

SELECT COUNT(*) AS Adultos
FROM Clientes
WHERE Idade >= 18;

SELECT AVG(Idade) AS IdadeMedia
FROM Clientes;

SELECT 
COUNT(*) AS Total,
AVG(Idade) AS IdadeMedia,
MAX(Idade) AS MaisVelho,
MIN(Idade) AS MaisNovo
FROM Clientes;