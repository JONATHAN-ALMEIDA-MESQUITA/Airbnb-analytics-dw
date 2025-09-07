--- Visão Geral
CREATE OR REPLACE VIEW c_gold."VW_VISAO_GERAL" AS
SELECT
    COUNT(DISTINCT prc.fk_anuncio) AS total_anuncios,
    ROUND(AVG(NULLIF(prc.price, 0)), 2) AS preco_medio_geral,
    MIN(NULLIF(prc.price, 0)) AS preco_minimo,
    MAX(NULLIF(prc.price, 0)) AS preco_maximo
FROM b_silver."T_FATO_PRECIFICACAO" prc;


