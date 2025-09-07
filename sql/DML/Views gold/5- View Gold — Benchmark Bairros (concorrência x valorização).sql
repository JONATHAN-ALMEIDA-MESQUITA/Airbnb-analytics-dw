--- Benchmark Bairros (concorrência x valorização)

CREATE OR REPLACE VIEW c_gold."VW_BENCHMARK_BAIRROS" AS
SELECT
    loc.neighbourhood AS bairro,
    ROUND(AVG(NULLIF(prc.price,0)),2) AS preco_medio,
    COUNT(DISTINCT prc.fk_anuncio) AS qtde_anuncios
FROM b_silver."T_FATO_PRECIFICACAO" prc
JOIN b_silver."T_DIM_LOCALIZACAO" loc
  ON prc.fk_anuncio = loc.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000
GROUP BY loc.neighbourhood;
