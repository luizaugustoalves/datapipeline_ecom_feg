-- ============================================
-- Silver: Itens de Pedido
-- Tipagem de campos numéricos
-- ============================================
SELECT
    CAST(item_id AS INT64) AS item_id,
    CAST(pedido_id AS INT64) AS pedido_id,
    CAST(produto_id AS INT64) AS produto_id,
    CAST(quantidade AS INT64) AS quantidade,
    CAST(preco_unitario AS FLOAT64) AS preco_unitario,
    CAST(subtotal AS FLOAT64) AS subtotal,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.itens_pedido`
