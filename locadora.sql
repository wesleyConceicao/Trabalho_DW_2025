CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo CHAR(2) CHECK (tipo IN ('PF', 'PJ')) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Condutor (
    id_condutor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnh VARCHAR(20) NOT NULL,
    validade_cnh DATE NOT NULL,
    categoria_cnh CHAR(2),
    id_cliente INT REFERENCES Cliente(id_cliente)
);

CREATE TABLE GrupoVeiculo (
    id_grupo SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    faixa_preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE Veiculo (
    id_veiculo SERIAL PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    chassi VARCHAR(20) UNIQUE NOT NULL,
    cor VARCHAR(20),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    tipo_mecanizacao VARCHAR(20),
    id_grupo INT REFERENCES GrupoVeiculo(id_grupo),
    status VARCHAR(20)
);

CREATE TABLE Acessorio (
    id_acessorio SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE VeiculoAcessorio (
    id_veiculo INT REFERENCES Veiculo(id_veiculo),
    id_acessorio INT REFERENCES Acessorio(id_acessorio),
    PRIMARY KEY (id_veiculo, id_acessorio)
);

CREATE TABLE Patio (
    id_patio SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    localizacao VARCHAR(100)
);

CREATE TABLE Vaga (
    id_vaga SERIAL PRIMARY KEY,
    codigo_vaga VARCHAR(10),
    status VARCHAR(20),
    id_patio INT REFERENCES Patio(id_patio)
);

CREATE TABLE FotoVeiculo (
    id_foto SERIAL PRIMARY KEY,
    id_veiculo INT REFERENCES Veiculo(id_veiculo),
    url VARCHAR(255),
    tipo VARCHAR(20),
    data_foto DATE
);

CREATE TABLE Reserva (
    id_reserva SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Cliente(id_cliente),
    id_grupo INT REFERENCES GrupoVeiculo(id_grupo),
    data_inicio DATE,
    data_fim DATE,
    id_patio_retirada INT REFERENCES Patio(id_patio),
    status VARCHAR(20)
);

CREATE TABLE Locacao (
    id_locacao SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Cliente(id_cliente),
    id_condutor INT REFERENCES Condutor(id_condutor),
    id_veiculo INT REFERENCES Veiculo(id_veiculo),
    id_reserva INT REFERENCES Reserva(id_reserva),
    data_retirada_prev TIMESTAMP,
    data_retirada_real TIMESTAMP,
    data_devolucao_prev TIMESTAMP,
    data_devolucao_real TIMESTAMP,
    id_patio_saida INT REFERENCES Patio(id_patio),
    id_patio_chegada INT REFERENCES Patio(id_patio),
    status VARCHAR(20)
);

CREATE TABLE Protecao (
    id_protecao SERIAL PRIMARY KEY,
    tipo VARCHAR(50),
    valor_diario DECIMAL(10,2)
);

CREATE TABLE LocacaoProtecao (
    id_locacao INT REFERENCES Locacao(id_locacao),
    id_protecao INT REFERENCES Protecao(id_protecao),
    PRIMARY KEY (id_locacao, id_protecao)
);

CREATE TABLE Cobranca (
    id_cobranca SERIAL PRIMARY KEY,
    id_locacao INT REFERENCES Locacao(id_locacao),
    valor_previsto DECIMAL(10,2),
    valor_final DECIMAL(10,2),
    forma_pagamento VARCHAR(50),
    status VARCHAR(20)
);
