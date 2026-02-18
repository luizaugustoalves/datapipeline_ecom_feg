-- ============================================
-- Gold: Anomalias nas Vendas Diárias
-- Método: Z-Score (desvio padrão)
-- Anomalia = Z-Score > 2 ou < -2
-- ============================================
WITH vendas_diarias AS (
    SELECT
        p.data_pedido,
        COUNT(DISTINCT p.pedido_id) AS total_pedidos,
        SUM(ip.subtotal) AS receita_total,
        COUNT(DISTINCT p.cliente_id) AS clientes_unicos
    FROM `teste-dados-feg.silver_ecommerce.pedidos` p
    INNER JOIN `teste-dados-feg.silver_ecommerce.itens_pedido` ip
        ON p.pedido_id = ip.pedido_id
    GROUP BY p.data_pedido
),

estatisticas AS (
    SELECT
        AVG(receita_total) AS media_receita,
        STDDEV(receita_total) AS desvio_padrao_receita,
        AVG(total_pedidos) AS media_pedidos,
        STDDEV(total_pedidos) AS desvio_padrao_pedidos
    FROM vendas_diarias
)

SELECT
    vd.data_pedido,
    vd.total_pedidos,
    vd.receita_total,
    vd.clientes_unicos,
    ROUND(e.media_receita, 2) AS media_receita,
    ROUND(e.desvio_padrao_receita, 2) AS desvio_padrao_receita,
    -- Z-Score da receita
    ROUND(SAFE_DIVIDE(vd.receita_total - e.media_receita, e.desvio_padrao_receita), 2) AS z_score_receita,
    -- Z-Score dos pedidos
    ROUND(SAFE_DIVIDE(vd.total_pedidos - e.media_pedidos, e.desvio_padrao_pedidos), 2) AS z_score_pedidos,
    -- Classificação da anomalia
    CASE
        WHEN SAFE_DIVIDE(vd.receita_total - e.media_receita, e.desvio_padrao_receita) > 2 THEN 'ACIMA_NORMAL'
        WHEN SAFE_DIVIDE(vd.receita_total - e.media_receita, e.desvio_padrao_receita) < -2 THEN 'ABAIXO_NORMAL'
        ELSE 'NORMAL'
    END AS classificacao_anomalia,
    -- Variação percentual em relação à média
    ROUND(SAFE_DIVIDE(vd.receita_total - e.media_receita, e.media_receita) * 100, 2) AS variacao_pct_media,
    CURRENT_TIMESTAMP() AS data_processamento
FROM vendas_diarias vd
CROSS JOIN estatisticas e
ORDER BY vd.data_pedido
