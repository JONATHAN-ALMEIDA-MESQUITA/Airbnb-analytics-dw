--- Sazonalidade


CREATE OR REPLACE VIEW c_gold."VW_SAZONALIDADE" AS
SELECT
    DATE_TRUNC('month', prc.last_scraped)::DATE AS mes,
    ROUND(AVG(NULLIF(prc.price,0)),2) AS preco_medio,
    COUNT(DISTINCT prc.fk_anuncio) AS qtde_anuncios
FROM b_silver."T_FATO_PRECIFICACAO" prc
WHERE prc.price BETWEEN 30 AND 3000
GROUP BY DATE_TRUNC('month', prc.last_scraped)
ORDER BY mes;
