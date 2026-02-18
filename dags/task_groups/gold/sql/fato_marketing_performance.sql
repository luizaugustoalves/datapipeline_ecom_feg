-- ============================================
-- Gold: Fato Marketing Performance
-- Performance de campanhas com receita atribuída e ROAS
-- ============================================
WITH receita_por_pedido AS (
    SELECT
        pedido_id,
        SUM(subtotal) AS receita_pedido
    FROM `teste-dados-feg.silver_ecommerce.itens_pedido`
    GROUP BY pedido_id
),

atribuicao_com_receita AS (
    SELECT
        ac.campanha_id,
        ac.modelo_atribuicao,
        ac.pedido_id,
        rp.receita_pedido AS receita_atribuida
    FROM `teste-dados-feg.silver_ecommerce.atribuicao_campanha` ac
    INNER JOIN receita_por_pedido rp
        ON ac.pedido_id = rp.pedido_id
),

metricas_campanha AS (
    SELECT
        campanha_id,
        COUNT(DISTINCT pedido_id) AS pedidos_atribuidos,
        SUM(receita_atribuida) AS receita_total_atribuida
    FROM atribuicao_com_receita
    GROUP BY campanha_id
)

SELECT
    cm.campanha_id,
    cm.nome_campanha,
    cm.plataforma,
    cm.data_inicio,
    cm.data_fim,
    cm.investimento,
    cm.impressoes,
    cm.cliques,
    cm.conversoes,
    cm.ctr,
    cm.cpc,
    cm.cpa,
    -- Métricas de receita atribuída
    COALESCE(mc.pedidos_atribuidos, 0) AS pedidos_atribuidos,
    COALESCE(mc.receita_total_atribuida, 0) AS receita_total_atribuida,
    -- ROAS (Return on Ad Spend)
    ROUND(SAFE_DIVIDE(COALESCE(mc.receita_total_atribuida, 0), cm.investimento), 2) AS roas,
    -- Custo por pedido atribuído
    ROUND(SAFE_DIVIDE(cm.investimento, COALESCE(mc.pedidos_atribuidos, 0)), 2) AS custo_por_pedido,
    -- Eficiência da campanha
    CASE
        WHEN SAFE_DIVIDE(COALESCE(mc.receita_total_atribuida, 0), cm.investimento) >= 3 THEN 'ALTA'
        WHEN SAFE_DIVIDE(COALESCE(mc.receita_total_atribuida, 0), cm.investimento) >= 1 THEN 'MEDIA'
        ELSE 'BAIXA'
    END AS eficiencia_campanha,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.silver_ecommerce.campanhas_marketing` cm
LEFT JOIN metricas_campanha mc
    ON cm.campanha_id = mc.campanha_id
