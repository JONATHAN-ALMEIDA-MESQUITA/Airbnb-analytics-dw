-- 0) garanta que não há transação com erro ativa
-- (se aparecer 25P02 de novo, execute ROLLBACK; e rode de novo)
-- ROLLBACK;

-- 1) criar coluna host_id, se ainda não existir
ALTER TABLE b_silver."T_DIM_ANUNCIO"
ADD COLUMN IF NOT EXISTS host_id BIGINT;

-- 2) (opcional) veja se tem mais de 1 host por anúncio no Bronze
-- para inspecionar a regra de escolha
-- SELECT fk_anuncio, COUNT(*) c
-- FROM a_bronze."T_DIM_ANFITRIAO"
-- GROUP BY fk_anuncio
-- HAVING COUNT(*) > 1
-- ORDER BY c DESC
-- LIMIT 20;

-- 3) escolha do host por anúncio
-- regra simples: menor host_id por anúncio (determinística)
WITH escolha AS (
  SELECT fk_anuncio AS id_anuncio, MIN(host_id) AS host_id
  FROM a_bronze."T_DIM_ANFITRIAO"
  GROUP BY fk_anuncio
)
UPDATE b_silver."T_DIM_ANUNCIO" s
SET host_id = e.host_id
FROM escolha e
WHERE s.id_anuncio = e.id_anuncio
  AND (s.host_id IS DISTINCT FROM e.host_id);

-- 4) índice para acelerar joins e a futura FK
CREATE INDEX IF NOT EXISTS idx_dim_anuncio_host_id
  ON b_silver."T_DIM_ANUNCIO"(host_id);

-- 5) checar inconsistências antes de criar a FK
-- anúncios que ficaram sem host_id (sem correspondência no Bronze)
WITH sem_host AS (
  SELECT id_anuncio FROM b_silver."T_DIM_ANUNCIO"
  WHERE host_id IS NULL
),
host_inexistente AS (
  SELECT a.id_anuncio, a.host_id
  FROM b_silver."T_DIM_ANUNCIO" a
  LEFT JOIN b_silver."T_DIM_ANFITRIAO" h ON h.host_id = a.host_id
  WHERE a.host_id IS NOT NULL AND h.host_id IS NULL
)
SELECT
  (SELECT COUNT(*) FROM sem_host)           AS anuncios_sem_host,
  (SELECT COUNT(*) FROM host_inexistente)   AS host_ids_inexistentes_no_dim_anfitriao;

-- Se "host_ids_inexistentes_no_dim_anfitriao" > 0,
-- significa que você ainda NÃO carregou a dimensão de anfitrião no b_silver,
-- ou que há divergência de keys. Corrija isso antes da FK.

-- 6) criar a FK somente se ainda não existir e se não houver host inexistente
DO $$
DECLARE
  v_missing_hosts INT;
  v_exists INT;
BEGIN
  SELECT COUNT(*) INTO v_missing_hosts
  FROM b_silver."T_DIM_ANUNCIO" a
  LEFT JOIN b_silver."T_DIM_ANFITRIAO" h ON h.host_id = a.host_id
  WHERE a.host_id IS NOT NULL AND h.host_id IS NULL;

  -- verifica se a constraint já existe
  SELECT COUNT(*) INTO v_exists
  FROM pg_constraint
  WHERE conname = 'fk_anuncio_host';

  IF v_missing_hosts = 0 AND v_exists = 0 THEN
    ALTER TABLE b_silver."T_DIM_ANUNCIO"
      ADD CONSTRAINT fk_anuncio_host
      FOREIGN KEY (host_id)
      REFERENCES b_silver."T_DIM_ANFITRIAO"(host_id)
      DEFERRABLE INITIALLY DEFERRED;
  ELSIF v_missing_hosts > 0 THEN
    RAISE NOTICE 'FK NÃO criada: % host_id(s) de anúncio não existem na dimensão de anfitrião.',
      v_missing_hosts;
  ELSE
    RAISE NOTICE 'FK já existe ou não é necessária criar novamente.';
  END IF;
END $$;

-- 7) (opcional) estatísticas
-- ANALYZE b_silver."T_DIM_ANUNCIO";
