-- ============================================
-- Gold: Dimensão Produto
-- Enriquecida com métricas de venda
-- ============================================
WITH produto_base AS (
    SELECT
        produto_id,
        nome_produto,
        categoria,
        preco_unitario,
        custo,
        estoque_atual,
        margem_unitaria
    FROM `teste-dados-feg.silver_ecommerce.produtos`
),

metricas_venda AS (
    SELECT
        ip.produto_id,
        SUM(ip.quantidade) AS total_quantidade_vendida,
        SUM(ip.subtotal) AS receita_total,
        COUNT(DISTINCT ip.pedido_id) AS total_pedidos_com_produto,
        ROUND(AVG(ip.preco_unitario), 2) AS preco_medio_venda
    FROM `teste-dados-feg.silver_ecommerce.itens_pedido` ip
    GROUP BY ip.produto_id
)

SELECT
    pb.produto_id,
    pb.nome_produto,
    pb.categoria,
    pb.preco_unitario,
    pb.custo,
    pb.estoque_atual,
    pb.margem_unitaria,
    COALESCE(mv.total_quantidade_vendida, 0) AS total_quantidade_vendida,
    COALESCE(mv.receita_total, 0) AS receita_total,
    COALESCE(mv.total_pedidos_com_produto, 0) AS total_pedidos_com_produto,
    COALESCE(mv.preco_medio_venda, 0) AS preco_medio_venda,
    -- Flags
    CASE WHEN pb.margem_unitaria < 0 THEN TRUE ELSE FALSE END AS flag_margem_negativa,
    CASE WHEN pb.estoque_atual <= 5 THEN TRUE ELSE FALSE END AS flag_estoque_baixo,
    CURRENT_TIMESTAMP() AS data_processamento
FROM produto_base pb
LEFT JOIN metricas_venda mv
    ON pb.produto_id = mv.produto_id
