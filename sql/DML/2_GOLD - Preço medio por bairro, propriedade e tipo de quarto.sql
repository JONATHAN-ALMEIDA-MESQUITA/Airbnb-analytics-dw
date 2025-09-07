SELECT
	loc.neighbourhood AS bairro,
	prop.property_type_std AS propriedade,
	prop.room_type_std,
	COUNT(*) AS qtde,
	ROUND(AVG(NULLIF(prc.price, 0)):: numeric, 2) AS preco_medio
FROM b_silver."T_DIM_LOCALIZACAO" AS loc
JOIN b_silver."T_DIM_PROPRIEDADE" AS prop
  ON prop.fk_anuncio = loc.fk_anuncio
JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
  ON prc.fk_anuncio = loc.fk_anuncio
WHERE loc.neighbourhood IS NOT NULL 
  AND prc.price BETWEEN 30 AND 3000
GROUP BY loc.neighbourhood, prop.property_type_std, prop.room_type_std
HAVING COUNT(*) >=10
ORDER BY bairro, preco_medio DESC;
	