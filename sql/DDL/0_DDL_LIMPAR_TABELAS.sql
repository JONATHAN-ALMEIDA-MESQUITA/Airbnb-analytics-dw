TRUNCATE TABLE
  a_bronze."T_FATO_AVALIACAO",
  a_bronze."T_FATO_PRECIFICACAO", 
  a_bronze."T_DIM_LOCALIZACAO",
  a_bronze."T_DIM_PROPRIEDADE",
  a_bronze."T_DIM_REGRAS",
  a_bronze."T_DIM_ANUNCIO",
  a_bronze."T_DIM_ANFITRIAO",
  a_bronze."processamento_arquivos"
RESTART IDENTITY CASCADE;