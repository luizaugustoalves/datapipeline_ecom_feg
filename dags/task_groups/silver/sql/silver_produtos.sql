-- ============================================
-- Silver: Produtos
-- Tipagem e cálculo de margem unitária
-- ============================================
SELECT
    CAST(produto_id AS INT64) AS produto_id,
    TRIM(nome_produto) AS nome_produto,
    UPPER(TRIM(categoria)) AS categoria,
    CAST(preco_unitario AS FLOAT64) AS preco_unitario,
    CAST(custo AS FLOAT64) AS custo,
    CAST(estoque_atual AS INT64) AS estoque_atual,
    ROUND(CAST(preco_unitario AS FLOAT64) - CAST(custo AS FLOAT64), 2) AS margem_unitaria,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.produtos`
