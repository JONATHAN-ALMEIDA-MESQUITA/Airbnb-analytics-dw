-- Cricação das tabelas silver e 

CREATE SCHEMA IF NOT EXISTS b_silver;

CREATE TABLE IF NOT EXISTS b_silver."T_DIM_ANUNCIO" (
  id_anuncio      BIGINT PRIMARY KEY,
  listing_url     TEXT,
  scrape_id       BIGINT,
  name            TEXT,
  summary         TEXT,
  space           TEXT,
  description     TEXT,
  neighborhood_overview TEXT,
  transit         TEXT,
  access          TEXT,
  interaction     TEXT,
  house_rules     TEXT,
  picture_url     TEXT,
  -- Auditoria
  fonte           TEXT DEFAULT 'Airbnb_bronze',
  dt_ingestao     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

-- Índices úteis para busca/BI (opcional)
CREATE INDEX IF NOT EXISTS idx_anuncio_scrape ON b_silver."T_DIM_ANUNCIO"(scrape_id);
