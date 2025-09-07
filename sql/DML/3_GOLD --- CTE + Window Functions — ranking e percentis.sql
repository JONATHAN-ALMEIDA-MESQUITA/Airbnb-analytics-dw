--- — Ranking e percentis
WITH base AS (
    SELECT
        loc.neighbourhood AS bairro,
        NULLIF(prc.price,0) AS price
    FROM b_silver."T_DIM_LOCALIZACAO"  AS loc
    JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
      ON prc.fk_anuncio = loc.fk_anuncio
    WHERE prc.price BETWEEN 30 AND 3000
),
agg AS (
    SELECT
        bairro,
        COUNT(*)                                   AS qtde,
        AVG(price)                                 AS preco_medio,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS mediana
    FROM base
    GROUP BY bairro
    HAVING COUNT(*) >= 20
),
ranked AS (
    SELECT
        a.*,
        RANK() OVER (ORDER BY preco_medio DESC)                 AS rank_preco,
        NTILE(4) OVER (ORDER BY preco_medio DESC)               AS quartil,
        CUME_DIST() OVER (ORDER BY preco_medio)                 AS cume_dist
    FROM agg a
)
SELECT
    bairro, qtde,
    ROUND(preco_medio::numeric,2) AS preco_medio,
    ROUND(mediana::numeric,2)     AS mediana,
    rank_preco,
    quartil,
    ROUND(cume_dist::numeric,3)   AS cume_dist
FROM ranked
ORDER BY rank_preco;
