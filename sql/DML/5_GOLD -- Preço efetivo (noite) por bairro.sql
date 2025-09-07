-- Preço efetivo (noite) por bairro
SELECT
    loc.neighbourhood AS bairro,
    COUNT(*) AS qtde,
    ROUND(AVG( NULLIF(prc.price,0)
              + COALESCE(prc.cleaning_fee,0)
              + COALESCE(prc.security_deposit,0)
             )::numeric, 2) AS preco_efetivo_medio
FROM b_silver."T_DIM_LOCALIZACAO"   AS loc
JOIN b_silver."T_FATO_PRECIFICACAO" AS prc
  ON prc.fk_anuncio = loc.fk_anuncio
WHERE prc.price BETWEEN 30 AND 3000
GROUP BY loc.neighbourhood
HAVING COUNT(*) >= 20
ORDER BY preco_efetivo_medio DESC;
