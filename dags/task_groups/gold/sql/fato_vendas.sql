-- ============================================
-- Gold: Fato Vendas
-- Granularidade: 1 linha por item de pedido
-- JOIN com pedidos, clientes e produtos
-- ============================================
SELECT
    ip.item_id,
    ip.pedido_id,
    ip.produto_id,
    p.cliente_id,
    -- Datas
    p.data_pedido,
    -- Dimensões
    c.nome AS nome_cliente,
    c.estado AS estado_cliente,
    c.canal_aquisicao,
    pr.nome_produto,
    pr.categoria AS categoria_produto,
    p.canal_venda,
    p.status AS status_pedido,
    -- Métricas do item
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal AS valor_bruto,
    -- Rateio proporional do desconto do pedido por item
    ROUND(
        ip.subtotal * SAFE_DIVIDE(p.desconto_aplicado,
            SUM(ip.subtotal) OVER (PARTITION BY ip.pedido_id)),
        2
    ) AS valor_desconto_rateado,
    -- Valor líquido (subtotal - desconto rateado)
    ROUND(
        ip.subtotal - ip.subtotal * SAFE_DIVIDE(p.desconto_aplicado,
            SUM(ip.subtotal) OVER (PARTITION BY ip.pedido_id)),
        2
    ) AS valor_liquido,
    -- Rateio proporcional do frete por item
    ROUND(
        ip.subtotal * SAFE_DIVIDE(p.valor_frete,
            SUM(ip.subtotal) OVER (PARTITION BY ip.pedido_id)),
        2
    ) AS valor_frete_rateado,
    -- Custo do item
    pr.custo * ip.quantidade AS custo_total_item,
    -- Margem bruta do item
    ROUND(ip.subtotal - (pr.custo * ip.quantidade), 2) AS margem_bruta_item,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.silver_ecommerce.itens_pedido` ip
INNER JOIN `teste-dados-feg.silver_ecommerce.pedidos` p
    ON ip.pedido_id = p.pedido_id
INNER JOIN `teste-dados-feg.silver_ecommerce.clientes` c
    ON p.cliente_id = c.cliente_id
INNER JOIN `teste-dados-feg.silver_ecommerce.produtos` pr
    ON ip.produto_id = pr.produto_id
