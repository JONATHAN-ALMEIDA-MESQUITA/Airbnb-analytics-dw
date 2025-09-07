--- Impacto de amenidades (exemplo Wi-Fi, piscina, ar-condicionado)


CREATE OR REPLACE VIEW c_gold."VW_AMENIDADES_IMOVEIS" AS
SELECT
    ROUND(AVG(CASE WHEN prop.has_wifi THEN prc.price END),2) AS preco_wifi,
    ROUND(AVG(CASE WHEN prop.has_pool THEN prc.price END),2) AS preco_piscina,
    ROUND(AVG(CASE WHEN prop.has_ac THEN prc.price END),2) AS preco_arcondicionado
FROM b_silver."T_FATO_PRECIFICACAO" prc
JOIN b_silver."T_DIM_PROPRIEDADE" prop
  ON prc.fk_anuncio = prop.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000;
