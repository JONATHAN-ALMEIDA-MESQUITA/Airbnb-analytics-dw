--- Distribuição de Preços (Quartis e Outliers)

CREATE OR REPLACE VIEW c_gold."VW_DISTRIBUICAO_PRECOS" AS
SELECT
    prc.fk_anuncio,
    loc.neighbourhood AS bairro,
    prc.price,
    NTILE(4) OVER (ORDER BY prc.price) AS quartil
FROM b_silver."T_FATO_PRECIFICACAO" prc
JOIN b_silver."T_DIM_LOCALIZACAO" loc
  ON prc.fk_anuncio = loc.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000;
