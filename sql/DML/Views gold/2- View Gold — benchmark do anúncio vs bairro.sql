CREATE OR REPLACE VIEW c_gold."VW_BENCHMARK_ANUNCIO_BAIRRO" AS
WITH bairro AS (
    SELECT
        loc.neighbourhood AS bairro,
        AVG(NULLIF(prc.price,0)) AS preco_medio_bairro
    FROM b_silver."T_DIM_LOCALIZACAO"   AS loc
    JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
      ON prc.fk_anuncio = loc.fk_anuncio
    WHERE prc.price BETWEEN 30 AND 3000
    GROUP BY loc.neighbourhood
),
anuncio AS (
    SELECT
        prc.fk_anuncio,
        loc.neighbourhood AS bairro,
        NULLIF(prc.price,0) AS price
    FROM b_silver."T_DIM_LOCALIZACAO"   AS loc
    JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
      ON prc.fk_anuncio = loc.fk_anuncio
    WHERE prc.price BETWEEN 30 AND 3000
)
SELECT
    a.fk_anuncio,
    a.bairro,
    ROUND(a.price::numeric,2) AS preco_anuncio,
    ROUND(b.preco_medio_bairro::numeric,2) AS preco_medio_bairro,
    ROUND((a.price - b.preco_medio_bairro)::numeric,2) AS dif_para_bairro
FROM anuncio a
JOIN bairro  b ON b.bairro = a.bairro;
