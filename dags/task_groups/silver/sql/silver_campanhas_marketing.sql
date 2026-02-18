-- ============================================
-- Silver: Campanhas de Marketing
-- Tipagem, métricas derivadas (CTR, CPC, CPA)
-- ============================================
SELECT
    CAST(campanha_id AS INT64) AS campanha_id,
    TRIM(nome_campanha) AS nome_campanha,
    UPPER(TRIM(plataforma)) AS plataforma,
    SAFE.PARSE_DATE('%Y-%m-%d', data_inicio) AS data_inicio,
    SAFE.PARSE_DATE('%Y-%m-%d', data_fim) AS data_fim,
    CAST(investimento AS FLOAT64) AS investimento,
    CAST(impressoes AS INT64) AS impressoes,
    CAST(cliques AS INT64) AS cliques,
    CAST(conversoes AS INT64) AS conversoes,
    -- Métricas derivadas
    SAFE_DIVIDE(CAST(cliques AS INT64), CAST(impressoes AS INT64)) AS ctr,
    SAFE_DIVIDE(CAST(investimento AS FLOAT64), CAST(cliques AS INT64)) AS cpc,
    SAFE_DIVIDE(CAST(investimento AS FLOAT64), CAST(conversoes AS INT64)) AS cpa,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.campanhas_marketing`
