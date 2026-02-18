-- ============================================
-- View: LTV por Canal de Aquisição
-- LTV = soma de pedidos ENTREGUES por cliente
-- ============================================
CREATE OR REPLACE VIEW `teste-dados-feg.gold_ecommerce.vw_ltv_por_canal` AS
WITH ltv_cliente AS (
    SELECT
        c.cliente_id,
        c.canal_aquisicao,
        c.data_cadastro,
        COUNT(DISTINCT p.pedido_id) AS total_pedidos_entregues,
        SUM(ip.subtotal) AS ltv
    FROM `teste-dados-feg.silver_ecommerce.clientes` c
    INNER JOIN `teste-dados-feg.silver_ecommerce.pedidos` p
        ON c.cliente_id = p.cliente_id
        AND UPPER(p.status) = 'ENTREGUE'
    INNER JOIN `teste-dados-feg.silver_ecommerce.itens_pedido` ip
        ON p.pedido_id = ip.pedido_id
    GROUP BY c.cliente_id, c.canal_aquisicao, c.data_cadastro
)
SELECT
    canal_aquisicao,
    COUNT(DISTINCT cliente_id) AS total_clientes,
    ROUND(AVG(ltv), 2) AS ltv_medio,
    ROUND(MIN(ltv), 2) AS ltv_minimo,
    ROUND(MAX(ltv), 2) AS ltv_maximo,
    ROUND(SUM(ltv), 2) AS receita_total,
    ROUND(AVG(total_pedidos_entregues), 1) AS media_pedidos_por_cliente
FROM ltv_cliente
GROUP BY canal_aquisicao;
