--- Avaliações

CREATE OR REPLACE VIEW c_gold."VW_AVALIACOES_PRECO" AS
SELECT
    rev.nota_media_0_10 AS nota,
    ROUND(AVG(NULLIF(prc.price,0)),2) AS preco_medio,
    COUNT(prc.fk_anuncio) AS qtde_anuncios
FROM b_silver."T_FATO_PRECIFICACAO" prc
JOIN b_silver."T_FATO_AVALIACAO" rev
  ON prc.fk_anuncio = rev.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000
GROUP BY rev.nota_media_0_10
ORDER BY nota DESC;
