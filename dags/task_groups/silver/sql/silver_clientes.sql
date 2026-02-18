-- ============================================
-- Silver: Clientes
-- Limpeza, tipagem e deduplicação
-- ============================================
SELECT
    CAST(cliente_id AS INT64) AS cliente_id,
    TRIM(nome) AS nome,
    LOWER(TRIM(email)) AS email,
    TRIM(telefone) AS telefone,
    UPPER(TRIM(estado)) AS estado,
    UPPER(TRIM(canal_aquisicao)) AS canal_aquisicao,
    SAFE.PARSE_DATE('%Y-%m-%d', data_cadastro) AS data_cadastro,
    TRIM(fonte_crm) AS fonte_crm,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.clientes`
-- Remove duplicatas mantendo o primeiro registro por nome
QUALIFY ROW_NUMBER() OVER (PARTITION BY nome ORDER BY CAST(cliente_id AS INT64)) = 1
