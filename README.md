# Projeto de Banco de Dados Transacional - Locadora de Veículos

## Equipe
- Wesley Conceição da Silva - 118096333

## Descrição
Este repositório contém o projeto completo do banco de dados relacional para o sistema de reservas e locação de veículos de uma locadora associada a um consórcio de empresas.

## Conteúdo
- PDF do projeto 
- [Modelo conceitual](https://raw.githubusercontent.com/wesleyConceicao/Trabalho_DW_Wesley_conceicao_2025/refs/heads/main/Imagem_modelo_conceitual.png)
- [Modelo lógico](https://raw.githubusercontent.com/wesleyConceicao/Trabalho_DW_Wesley_conceicao_2025/refs/heads/main/Imagem_modelo_l%C3%B3gico.png)
- Script SQL/DDL do modelo físico
  
## Dicionario de dados

Tabela: Cliente

| Campo          | Tipo         | Obrigatório | Restrição de Integridade    | Descrição                                  |
| -------------- | ------------ | ----------- | --------------------------- | ------------------------------------------ |
| id\_cliente    | INT          | Sim         | PK                          | Identificador único do cliente             |
| nome           | VARCHAR(100) | Não         | —                           | Nome completo do cliente                   |
| tipo           | CHAR(2)      | Sim         | CHECK (tipo IN ('PF','PJ')) | Tipo do cliente: Pessoa Física ou Jurídica |
| cpf\_cnpj      | VARCHAR(20)  | Sim         | UNIQUE, NOT NULL            | CPF ou CNPJ, único                         |
| email          | VARCHAR(100) | Não         | —                           | Email de contato                           |
| telefone       | VARCHAR(15)  | Não         | —                           | Telefone de contato                        |
| cnh            | VARCHAR(20)  | Sim         | NOT NULL                    | Número da CNH do cliente                   |
| validade\_cnh  | DATE         | Sim         | NOT NULL                    | Data de validade da CNH                    |
| categoria\_cnh | CHAR(2)      | Não         | —                           | Categoria da CNH (ex: B, C, D)             |

Tabela: Veiculo

| Campo       | Tipo        | Obrigatório | Restrição de Integridade  | Descrição                               |
| ----------- | ----------- | ----------- | ------------------------- | --------------------------------------- |
| id\_veiculo | INT         | Sim         | PK                        | Identificador único do veículo          |
| placa       | VARCHAR(7)  | Não         | UNIQUE                    | Placa do veículo                        |
| marca       | VARCHAR(50) | Não         | —                         | Marca do veículo                        |
| modelo      | VARCHAR(50) | Não         | —                         | Modelo do veículo                       |
| chassi      | VARCHAR(20) | Sim         | UNIQUE, NOT NULL          | Número do chassi, único                 |
| cor         | VARCHAR(20) | Não         | —                         | Cor do veículo                          |
| cliente\_id | INT         | Não         | FK → CLIENTE(id\_cliente) | Cliente associado ao veículo (opcional) |

Tabela: Pátio

| Campo       | Tipo         | Obrigatório | Restrição de Integridade  | Descrição                    |
| ----------- | ------------ | ----------- | ------------------------- | ---------------------------- |
| id\_patio   | INT          | Sim         | PK                        | Identificador único do pátio |
| localizacao | VARCHAR(100) | Não         | —                         | Localização física do pátio  |
| veiculo\_id | INT          | Não         | FK → VEICULO(id\_veiculo) | Veículo atualmente no pátio  |

Tabela: Reserva

| Campo               | Tipo        | Obrigatório | Restrição de Integridade  | Descrição                                  |
| ------------------- | ----------- | ----------- | ------------------------- | ------------------------------------------ |
| id\_reserva         | INT         | Sim         | PK                        | Identificador único da reserva             |
| cliente\_id         | INT         | Sim         | FK → CLIENTE(id\_cliente) | Cliente que realizou a reserva             |
| patio\_retirada\_id | INT         | Sim         | FK → PATIO(id\_patio)     | Pátio de retirada do veículo               |
| veiculo\_id         | INT         | Sim         | FK → VEICULO(id\_veiculo) | Veículo reservado                          |
| data\_inicio        | DATE        | Não         | —                         | Data de início da reserva                  |
| data\_fim           | DATE        | Não         | —                         | Data de término da reserva                 |
| status              | VARCHAR(20) | Não         | —                         | Status atual da reserva (ativo, concluído) |

Tabela: Locação

| Campo              | Tipo | Obrigatório | Restrição de Integridade  | Descrição                      |
| ------------------ | ---- | ----------- | ------------------------- | ------------------------------ |
| id\_locacao        | INT  | Sim         | PK                        | Identificador único da locação |
| reserva\_id        | INT  | Sim         | FK → RESERVA(id\_reserva) | Reserva associada à locação    |
| veiculo\_id        | INT  | Sim         | FK → VEICULO(id\_veiculo) | Veículo alugado                |
| cliente\_id        | INT  | Sim         | FK → CLIENTE(id\_cliente) | Cliente que realizou a locação |
| patio\_entrega\_id | INT  | Sim         | FK → PATIO(id\_patio)     | Pátio de devolução do veículo  |

Tabela: Cobrança

| Campo            | Tipo          | Obrigatório | Restrição de Integridade  | Descrição                                  |
| ---------------- | ------------- | ----------- | ------------------------- | ------------------------------------------ |
| id\_cobranca     | INT           | Sim         | PK                        | Identificador único da cobrança            |
| locacao\_id      | INT           | Sim         | FK → LOCACAO(id\_locacao) | Locação referente à cobrança               |
| data\_pagamento  | DATE          | Não         | —                         | Data em que o pagamento foi realizado      |
| valor\_pago      | DECIMAL(10,2) | Não         | —                         | Valor efetivamente pago                    |
| forma\_pagamento | VARCHAR(20)   | Não         | —                         | Forma de pagamento (cartão, dinheiro etc.) |




