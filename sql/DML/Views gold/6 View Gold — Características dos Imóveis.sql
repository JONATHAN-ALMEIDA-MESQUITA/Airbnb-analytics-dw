--- Características dos Imóveis

CREATE OR REPLACE VIEW c_gold."VW_CARACTERISTICAS_IMOVEIS" AS
SELECT
    prop.room_type_std,
    prop.property_type_std,
    ROUND(AVG(NULLIF(prc.price,0)),2) AS preco_medio,
    COUNT(prc.fk_anuncio) AS qtde_anuncios
FROM b_silver."T_FATO_PRECIFICACAO" prc
JOIN b_silver."T_DIM_PROPRIEDADE" prop
  ON prc.fk_anuncio = prop.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000
GROUP BY prop.room_type_std, prop.property_type_std;
