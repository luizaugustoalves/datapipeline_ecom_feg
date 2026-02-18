-- ============================================
-- Silver: Pedidos
-- Tipagem e padronização de campos textuais
-- ============================================
SELECT
    CAST(pedido_id AS INT64) AS pedido_id,
    CAST(cliente_id AS INT64) AS cliente_id,
    SAFE.PARSE_DATE('%Y-%m-%d', data_pedido) AS data_pedido,
    UPPER(TRIM(canal_venda)) AS canal_venda,
    UPPER(TRIM(status)) AS status,
    CAST(valor_frete AS FLOAT64) AS valor_frete,
    CAST(desconto_aplicado AS FLOAT64) AS desconto_aplicado,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.pedidos`
