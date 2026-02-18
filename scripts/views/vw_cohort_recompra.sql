-- ============================================
-- View: Taxa de Recompra por Cohort Mensal
-- Cohort = mês do primeiro pedido do cliente
-- ============================================
CREATE OR REPLACE VIEW `teste-dados-feg.gold_ecommerce.vw_cohort_recompra` AS
WITH primeiro_pedido AS (
    SELECT
        cliente_id,
        MIN(data_pedido) AS data_primeiro_pedido,
        FORMAT_DATE('%Y-%m', MIN(data_pedido)) AS cohort_mes
    FROM `teste-dados-feg.silver_ecommerce.pedidos`
    GROUP BY cliente_id
),
pedidos_por_cliente AS (
    SELECT
        p.cliente_id,
        pp.cohort_mes,
        pp.data_primeiro_pedido,
        COUNT(DISTINCT p.pedido_id) AS total_pedidos
    FROM `teste-dados-feg.silver_ecommerce.pedidos` p
    INNER JOIN primeiro_pedido pp
        ON p.cliente_id = pp.cliente_id
    GROUP BY p.cliente_id, pp.cohort_mes, pp.data_primeiro_pedido
)
SELECT
    cohort_mes,
    COUNT(DISTINCT cliente_id) AS total_clientes_cohort,
    COUNTIF(total_pedidos > 1) AS clientes_recompra,
    COUNTIF(total_pedidos = 1) AS clientes_compra_unica,
    ROUND(SAFE_DIVIDE(COUNTIF(total_pedidos > 1), COUNT(DISTINCT cliente_id)) * 100, 2) AS taxa_recompra_pct,
    ROUND(AVG(total_pedidos), 2) AS media_pedidos_por_cliente
FROM pedidos_por_cliente
GROUP BY cohort_mes;
