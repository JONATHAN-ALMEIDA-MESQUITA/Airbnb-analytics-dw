CREATE OR REPLACE VIEW c_gold."VW_PRECO_X_DISTANCIA_POI" AS

WITH latest_price AS (
  SELECT DISTINCT ON (prc.fk_anuncio)
         prc.fk_anuncio,
         prc.price,
         prc.last_scraped
  FROM b_silver."T_FATO_PRECIFICACAO" prc
  WHERE prc.price BETWEEN 30 AND 3000
  ORDER BY prc.fk_anuncio, prc.last_scraped DESC
)
SELECT
  loc.nearest_poi_name            AS ponto_turistico,
  COUNT(*)                        AS qtde_anuncios,
  ROUND(AVG(NULLIF(lp.price,0))::numeric, 2) AS preco_medio,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY NULLIF(lp.price,0)) AS mediana
FROM b_silver."T_DIM_LOCALIZACAO" loc
JOIN latest_price lp
  ON lp.fk_anuncio = loc.fk_anuncio
-- Se você tiver a distância ao POI mais próximo, aplique um raio:
-- WHERE loc.nearest_poi_distance_km <= 2
GROUP BY loc.nearest_poi_name
HAVING COUNT(*) >= 30  -- evita POIs com amostra muito pequena
ORDER BY preco_medio DESC;