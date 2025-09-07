--- Análise descritiva:
--- 1)Preço médio por bairro → Quais bairros são mais caros/baratos?
--- a)tratamento de outliers valores zerados/nulos
SELECT
	loc.neighbourhood AS bairro,
	COUNT(*) AS qtd_anuncios,
	ROUND(AVG(prc.price):: numeric, 2) AS preco_medio,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY NULLIF(prc.price,0))::numeric, 2) AS mediana,
	ROUND(STDDEV_POP(NULLIF(prc.price, 0)):: numeric, 2) AS desvio_padrao
FROM b_silver."T_DIM_LOCALIZACAO" AS loc
JOIN b_silver."T_FATO_PRECIFICACAO" as prc
ON prc.fk_anuncio = loc.fk_anuncio
WHERE prc.price IS NOT NULL
AND prc.price BETWEEN 30 AND 3000
GROUP BY loc.neighbourhood
HAVING COUNT(*) >=20
ORDER BY preco_medio DESC;
	