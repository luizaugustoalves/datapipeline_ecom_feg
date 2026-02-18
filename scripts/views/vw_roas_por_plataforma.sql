-- ============================================
-- View: ROAS por Plataforma de Marketing
-- ROAS = Receita Atribuída / Investimento
-- ============================================
CREATE OR REPLACE VIEW `teste-dados-feg.gold_ecommerce.vw_roas_por_plataforma` AS
WITH receita_por_pedido AS (
    SELECT
        pedido_id,
        SUM(subtotal) AS receita_pedido
    FROM `teste-dados-feg.silver_ecommerce.itens_pedido`
    GROUP BY pedido_id
),
receita_por_campanha AS (
    SELECT
        ac.campanha_id,
        SUM(rp.receita_pedido) AS receita_atribuida,
        COUNT(DISTINCT ac.pedido_id) AS pedidos_atribuidos
    FROM `teste-dados-feg.silver_ecommerce.atribuicao_campanha` ac
    INNER JOIN receita_por_pedido rp
        ON ac.pedido_id = rp.pedido_id
    GROUP BY ac.campanha_id
)
SELECT
    cm.plataforma,
    COUNT(DISTINCT cm.campanha_id) AS total_campanhas,
    SUM(cm.investimento) AS investimento_total,
    SUM(cm.impressoes) AS impressoes_total,
    SUM(cm.cliques) AS cliques_total,
    SUM(cm.conversoes) AS conversoes_total,
    COALESCE(SUM(rc.receita_atribuida), 0) AS receita_atribuida_total,
    COALESCE(SUM(rc.pedidos_atribuidos), 0) AS pedidos_atribuidos_total,
    ROUND(SAFE_DIVIDE(COALESCE(SUM(rc.receita_atribuida), 0), SUM(cm.investimento)), 2) AS roas,
    ROUND(SAFE_DIVIDE(SUM(cm.cliques), SUM(cm.impressoes)) * 100, 2) AS ctr_medio_pct,
    ROUND(SAFE_DIVIDE(SUM(cm.investimento), SUM(cm.cliques)), 2) AS cpc_medio,
    ROUND(SAFE_DIVIDE(SUM(cm.investimento), SUM(cm.conversoes)), 2) AS cpa_medio,
    CASE
        WHEN SAFE_DIVIDE(COALESCE(SUM(rc.receita_atribuida), 0), SUM(cm.investimento)) >= 5 THEN 'EXCELENTE'
        WHEN SAFE_DIVIDE(COALESCE(SUM(rc.receita_atribuida), 0), SUM(cm.investimento)) >= 3 THEN 'BOM'
        WHEN SAFE_DIVIDE(COALESCE(SUM(rc.receita_atribuida), 0), SUM(cm.investimento)) >= 1 THEN 'REGULAR'
        ELSE 'NEGATIVO'
    END AS classificacao_roas
FROM `teste-dados-feg.silver_ecommerce.campanhas_marketing` cm
LEFT JOIN receita_por_campanha rc
    ON cm.campanha_id = rc.campanha_id
GROUP BY cm.plataforma;
