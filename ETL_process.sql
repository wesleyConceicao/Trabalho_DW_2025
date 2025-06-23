-- 1. Script de Extração – Área de Staging
-- Extração dos dados da empresa do grupo 1 para área de staging
INSERT INTO staging.cliente (id_cliente, nome, cpf, cidade_origem)
SELECT id, nome, cpf, cidade
FROM grupo1.clientes;

INSERT INTO staging.veiculo (id_veiculo, placa, marca, modelo, grupo, tipo_mecanizacao, empresa_id)
SELECT id, placa, marca, modelo, grupo, mecanizacao, empresa_id
FROM grupo1.veiculos;

INSERT INTO staging.locacao (id_locacao, cliente_id, veiculo_id, data_retirada, data_devolucao, patio_retirada_id, patio_entrega_id, valor_total, empresa_id)
SELECT id, cliente_id, veiculo_id, data_retirada, data_devolucao, patio_saida, patio_chegada, valor, empresa_id
FROM grupo1.locacoes;

INSERT INTO staging.patio (id_patio, nome, localizacao, empresa_id)
SELECT id, nome, localizacao, empresa_id
FROM grupo1.patios;

-- 2. Script de Transformação

transformar_clientes.sql
sql
Copiar
Editar
-- Padronização de nomes e cidades dos clientes
INSERT INTO staging.cliente_padronizado (nome, cpf, cidade_origem)
SELECT INITCAP(nome), cpf, INITCAP(cidade_origem)
FROM staging.cliente;

-- Extração de dados únicos de data para criar a dimensão tempo
INSERT INTO staging.tempo (data)
SELECT DISTINCT DATE(data_retirada)
FROM staging.locacao;
transformar_veiculos.sql
sql
Copiar
Editar
-- Padronização do campo grupo e tipo mecanização
UPDATE staging.veiculo
SET grupo = UPPER(grupo),
    tipo_mecanizacao = INITCAP(tipo_mecanizacao);
📦 3. Script de Carga – DW em Esquema Estrela
carga_dim_cliente.sql
sql
Copiar
Editar
-- Inserção dos clientes únicos na dimensão cliente
INSERT INTO dw.dim_cliente (nome, cidade_origem, categoria_cnh)
SELECT DISTINCT nome, cidade_origem, 'B'
FROM staging.cliente_padronizado;
carga_dim_veiculo.sql
sql
Copiar
Editar
-- Carga da dimensão de veículos
INSERT INTO dw.dim_veiculo (grupo, marca, modelo, tipo_mecanizacao)
SELECT DISTINCT grupo, marca, modelo, tipo_mecanizacao
FROM staging.veiculo;
carga_dim_tempo.sql
sql
Copiar
Editar
-- Inserção na dimensão tempo
INSERT INTO dw.dim_tempo (data, dia, mes, ano)
SELECT data, EXTRACT(DAY FROM data), EXTRACT(MONTH FROM data), EXTRACT(YEAR FROM data)
FROM staging.tempo;
carga_dim_patio.sql
sql
Copiar
Editar
-- Carga dos pátios
INSERT INTO dw.dim_patio (nome_patio, localizacao)
SELECT DISTINCT nome, localizacao
FROM staging.patio;
carga_dim_empresa.sql
sql
Copiar
Editar
-- Carga das empresas
INSERT INTO dw.dim_empresa (nome_fantasia, cnpj)
SELECT DISTINCT nome_fantasia, cnpj
FROM grupo1.empresas;
carga_fato_locacao.sql
sql
Copiar
Editar
-- Populando a tabela fato de locações
INSERT INTO dw.fato_locacao (
    id_cliente, id_tempo, id_veiculo, id_patio_retirada, id_patio_entrega,
    id_empresa, valor_total, status, tempo_locacao
)
SELECT 
    c.id_cliente,
    t.id_tempo,
    v.id_veiculo,
    pr.id_patio,
    pe.id_patio,
    e.id_empresa,
    l.valor_total,
    'Finalizada',
    DATEDIFF(DAY, l.data_retirada, l.data_devolucao)
FROM staging.locacao l
JOIN dw.dim_cliente c ON c.nome = l.nome_cliente
JOIN dw.dim_veiculo v ON v.id_veiculo = l.veiculo_id
JOIN dw.dim_patio pr ON pr.nome_patio = l.patio_retirada
JOIN dw.dim_patio pe ON pe.nome_patio = l.patio_entrega
JOIN dw.dim_empresa e ON e.id_empresa = l.empresa_id
JOIN dw.dim_tempo t ON t.data = DATE(l.data_retirada);
