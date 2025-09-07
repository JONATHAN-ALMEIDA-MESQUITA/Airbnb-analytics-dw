CREATE OR REPLACE VIEW c_gold."VW_PRECO_BAIRRO" AS
WITH base AS (
    SELECT
        loc.neighbourhood AS bairro,
        NULLIF(prc.price,0) AS price,
        COALESCE(prc.cleaning_fee,0)      AS cleaning_fee,
        COALESCE(prc.security_deposit,0)  AS security_deposit
    FROM b_silver."T_DIM_LOCALIZACAO"   AS loc
    JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
      ON prc.fk_anuncio = loc.fk_anuncio
    WHERE prc.price BETWEEN 30 AND 3000
),
agg AS (
    SELECT
        bairro,
        COUNT(*) AS qtde,
        AVG(price) AS preco_medio,
        AVG(price + cleaning_fee + security_deposit) AS preco_efetivo_medio,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS mediana,
        STDDEV_POP(price) AS desvio_padrao
    FROM base
    GROUP BY bairro
)
SELECT
    bairro,
    qtde,
    ROUND(preco_medio::numeric,2)         AS preco_medio,
    ROUND(preco_efetivo_medio::numeric,2) AS preco_efetivo_medio,
    ROUND(mediana::numeric,2)             AS mediana,
    ROUND(desvio_padrao::numeric,2)       AS desvio_padrao,
    RANK() OVER (ORDER BY preco_medio DESC) AS rank_preco
FROM agg;
