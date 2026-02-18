-- ============================================
-- Gold: Dimensão Cliente
-- Enriquecida com métricas de compra e segmentação
-- ============================================
WITH cliente_base AS (
    SELECT
        cliente_id,
        nome,
        email,
        telefone,
        estado,
        canal_aquisicao,
        data_cadastro,
        fonte_crm
    FROM `teste-dados-feg.silver_ecommerce.clientes`
),

metricas_pedido AS (
    SELECT
        p.cliente_id,
        COUNT(DISTINCT p.pedido_id) AS total_pedidos,
        SUM(ip.subtotal) AS total_gasto,
        ROUND(SAFE_DIVIDE(SUM(ip.subtotal), COUNT(DISTINCT p.pedido_id)), 2) AS ticket_medio,
        MIN(p.data_pedido) AS primeiro_pedido,
        MAX(p.data_pedido) AS ultimo_pedido
    FROM `teste-dados-feg.silver_ecommerce.pedidos` p
    INNER JOIN `teste-dados-feg.silver_ecommerce.itens_pedido` ip
        ON p.pedido_id = ip.pedido_id
    GROUP BY p.cliente_id
)

SELECT
    cb.cliente_id,
    cb.nome,
    cb.email,
    cb.telefone,
    cb.estado,
    cb.canal_aquisicao,
    cb.data_cadastro,
    cb.fonte_crm,
    COALESCE(mp.total_pedidos, 0) AS total_pedidos,
    COALESCE(mp.total_gasto, 0) AS total_gasto,
    COALESCE(mp.ticket_medio, 0) AS ticket_medio,
    mp.primeiro_pedido,
    mp.ultimo_pedido,
    -- Segmentação RFM simplificada
    CASE
        WHEN mp.ultimo_pedido IS NULL THEN 'SEM_COMPRAS'
        WHEN DATE_DIFF(CURRENT_DATE(), mp.ultimo_pedido, DAY) <= 30 THEN 'ATIVO'
        WHEN DATE_DIFF(CURRENT_DATE(), mp.ultimo_pedido, DAY) <= 90 THEN 'EM_RISCO'
        ELSE 'INATIVO'
    END AS segmento_cliente,
    CURRENT_TIMESTAMP() AS data_processamento
FROM cliente_base cb
LEFT JOIN metricas_pedido mp
    ON cb.cliente_id = mp.cliente_id
