-- ============================================
-- Silver: Eventos Google Analytics
-- Tipagem com SAFE_CAST para cliente_id nullable
-- ============================================
SELECT
    CAST(evento_id AS INT64) AS evento_id,
    TRIM(session_id) AS session_id,
    SAFE_CAST(cliente_id AS INT64) AS cliente_id,
    UPPER(TRIM(evento)) AS evento,
    TRIM(pagina) AS pagina,
    UPPER(TRIM(dispositivo)) AS dispositivo,
    SAFE.PARSE_DATE('%Y-%m-%d', data_evento) AS data_evento,
    CURRENT_TIMESTAMP() AS data_processamento
FROM `teste-dados-feg.bronze_ecommerce.eventos_google_analytics`
