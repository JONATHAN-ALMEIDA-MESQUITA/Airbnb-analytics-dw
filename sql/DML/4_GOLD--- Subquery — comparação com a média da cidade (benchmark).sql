--- Subquery — comparação com a média da cidade (benchmark)

WITH cidade AS (
	SELECT AVG(NULLIF(price, 0)) AS media_cidade
	FROM b_silver."T_FATO_PRECIFICACAO"
	WHERE price BETWEEN 30 AND 3000
)
SELECT
	loc.neighbourhood AS bairro,
	ROUND(AVG(NULLIF(prc.price,0)):: numeric, 2) AS preco_bairro,
	ROUND((AVG(NULLIF(prc.price,0)) - (SELECT media_cidade FROM cidade))::numeric, 2) AS dif_para_cidade	
FROM b_silver."T_DIM_LOCALIZACAO" AS loc
JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
  ON loc.fk_anuncio = prc.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000
GROUP BY loc.neighbourhood
ORDER BY dif_para_cidade  DESC;
