-- ============================================
-- Silver: Atribuição de Campanhas
-- Tipagem e padronização
-- ============================================
SELECT
    CAST(atribuicao_id AS INT64) AS atribuicao_id,
    CAST(pedido_id AS INT64) AS pedido_id,
    CAST(campanha_id AS INT64) AS campanha_id,
    UPPER(TRIM(modelo_atribuicao)) AS modelo_atribuicao,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.atribuicao_campanha`
