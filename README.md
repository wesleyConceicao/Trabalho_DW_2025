# Projeto de Banco de Dados Transacional - Locadora de Veículos

## Equipe
- Wesley Conceição da Silva - 118096333

## Descrição
Este repositório contém o projeto completo do banco de dados relacional para o sistema de reservas e locação de veículos de uma locadora associada a um consórcio de empresas.

## Conteúdo
- PDF do projeto com justificativa e explicação
- Modelo conceitual 
- Modelo lógico 
- Script SQL/DDL do modelo físico
## Dicionario de dados
Tabela: CLIENTE
Campo
Tipo
Obrigatório
Restrição de Integridade
Descrição
id_cliente
INT
Sim
PK
Identificador único do cliente
nome
VARCHAR(100)
Não
—
Nome completo do cliente
tipo
CHAR(2)
Sim
CHECK (tipo IN ('PF','PJ'))
Tipo do cliente: Pessoa Física ou Jurídica
cpf_cnpj
VARCHAR(20)
Sim
UNIQUE, NOT NULL
CPF ou CNPJ, único
email
VARCHAR(100)
Não
—
Email de contato
telefone
VARCHAR(15)
Não
—
Telefone de contato
cnh
VARCHAR(20)
Sim
NOT NULL
Número da CNH do cliente
validade_cnh
DATE
Sim
NOT NULL
Data de validade da CNH
categoria_cnh
CHAR(2)
Não
—
Categoria da CNH (ex: B, C, D)


Tabela: VEÍCULO
Campo
Tipo
Obrigatório
Restrição de Integridade
Descrição
id_veiculo
INT
Sim
PK
Identificador único do veículo
placa
VARCHAR(7)
Não
UNIQUE
Placa do veículo
marca
VARCHAR(50)
Não
—
Marca do veículo
modelo
VARCHAR(50)
Não
—
Modelo do veículo
chassi
VARCHAR(20)
Sim
UNIQUE, NOT NULL
Número do chassi, único
cor
VARCHAR(20)
Não
—
Cor do veículo
cliente_id
INT
Não
FK → CLIENTE(id_cliente)
Cliente associado ao veículo (opcional)


Tabela: PÁTIO
Campo
Tipo
Obrigatório
Restrição de Integridade
Descrição
id_patio
INT
Sim
PK
Identificador único do pátio
localizacao
VARCHAR(100)
Não
—
Localização física do pátio
veiculo_id
INT
Não
FK → VEICULO(id_veiculo)
Veículo atualmente no pátio


Tabela: RESERVA
Campo
Tipo
Obrigatório
Restrição de Integridade
Descrição
id_reserva
INT
Sim
PK
Identificador único da reserva
cliente_id
INT
Sim
FK → CLIENTE(id_cliente)
Cliente que realizou a reserva
patio_retirada_id
INT
Sim
FK → PATIO(id_patio)
Pátio de retirada do veículo
veiculo_id
INT
Sim
FK → VEICULO(id_veiculo)
Veículo reservado
data_inicio
DATE
Não
—
Data de início da reserva
data_fim
DATE
Não
—
Data de término da reserva
status
VARCHAR(20)
Não
—
Status atual da reserva (ativo, concluído)


Tabela: LOCACAO
Campo
Tipo
Obrigatório
Restrição de Integridade
Descrição
id_locacao
INT
Sim
PK
Identificador único da locação
reserva_id
INT
Sim
FK → RESERVA(id_reserva)
Reserva associada à locação
veiculo_id
INT
Sim
FK → VEICULO(id_veiculo)
Veículo alugado
cliente_id
INT
Sim
FK → CLIENTE(id_cliente)
Cliente que realizou a locação
patio_entrega_id
INT
Sim
FK → PATIO(id_patio)
Pátio de devolução do veículo

Tabela: COBRANCA
Campo
Tipo
Obrigatório
Restrição de Integridade
Descrição
id_cobranca
INT
Sim
PK
Identificador único da cobrança
locacao_id
INT
Sim
FK → LOCACAO(id_locacao)
Locação referente à cobrança
data_pagamento
DATE
Não
—
Data em que o pagamento foi realizado
valor_pago
DECIMAL(10,2)
Não
—
Valor efetivamente pago
forma_pagamento
VARCHAR(20)
Não
—
Forma de pagamento (cartão, dinheiro etc.)

