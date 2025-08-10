import pandas as pd
import os
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import execute_batch
import pathlib

#carregar as variáveis de ambiente
load_dotenv()

#configurar a conexão com o banco de dados
conn = psycopg2.connect(
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT"),
    database=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),  
    password=os.getenv("DB_PASSWORD")
)

#criar um cursor para executar as queries
cursor = conn.cursor()

#listar todos os arquivos csv na pasta data
files_path = "./dados/row/"
csv_files = [f for f in os.listdir(files_path) if f.endswith('.csv')]



#Função para verificar arquivos ja processados
def files_already_processed(cursor, nome_arquivo):
    cursor.execute("""
    SELECT * FROM a_bronze.processamento_arquivos WHERE nome_arquivo = %s
""",(nome_arquivo,))
    return cursor.fetchone() is not None


#Função para registrar o arquivo processado no banco
def insert_file_processd(curso, nome_arquivo):
    cursor.execute("""INSERT INTO a_bronze.processamento_arquivos (nome_arquivo)
                   VALUES(%s)
                   ON CONFLICT (nome_arquivo) DO NOTHING
""", (nome_arquivo,))



#função para carregar os dados do csv para o banco de dados

def load_csv_to_db(df, table, columns, sql):

    # Garante que todas as colunas da lista existam no DataFrame
    for col in columns:
        if col not in df.columns:
            df[col] = None
    #Selecionar as colunas e remover as linhas com valores nulos na primeira coluna
    dados = df[columns].dropna(subset=[columns[0]]).values.tolist()

    #Executar a query SQL para inserir os dados no banco de dados
    execute_batch(cursor, sql, dados)


#Colunas e comando sql para inserir os dados na tabela T_DIM_ANUNCIO

columns_anuncio = ['id','listing_url','scrape_id','name','summary','space','description',
                   'experiences_offered','neighborhood_overview','notes','transit',
                   'access','interaction','house_rules','picture_url']


sql_anuncio = """ INSERT INTO a_bronze."T_DIM_ANUNCIO"(id_anuncio, listing_url, scrape_id,
                  name, summary, space,description, experiences_offered, 
                  neighborhood_overview,notes, transit,
                  access, interaction, house_rules, picture_url)
                  VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                  ON CONFLICT (id_anuncio) DO NOTHING
"""


#Colunas e comando sql para inserir os dados na tabela T_DIM_ANFITRIAO

columns_anfitriao = ['host_id','id','host_url','host_name','host_since',
                     'host_location','host_about','host_response_time','host_response_rate',
                     'host_is_superhost','host_thumbnail_url','host_picture_url','host_neighbourhood',
                     'host_listings_count','host_total_listings_count','host_verifications','host_has_profile_pic',
                     'host_identity_verified'
]

sql_anfitriao = """ INSERT INTO a_bronze. "T_DIM_ANFITRIAO"(host_id, fk_anuncio, host_url ,host_name ,host_since,
                    host_location, host_about, host_response_time, host_response_rate, host_is_superhost, host_thumbnail_url,
                    host_picture_url, host_neighbourhood, host_listings_count, host_total_listings_count, host_verifications,
                    host_has_profile_pic, host_identity_verified)
                    VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                    ON CONFLICT (host_id) DO NOTHING
"""

#Colunas e comando sql para inserir os dados na tabela T_DIM_LOCALIZACAO

columns_localizacao = ['id','street','neighbourhood','neighbourhood_cleansed',
                       'city','state','zipcode','market','smart_location','country_code','country','latitude',
                       'longitude','is_location_exact'
]

sql_localizacao = """ INSERT INTO a_bronze. "T_DIM_LOCALIZACAO"( fk_anuncio,street,neighbourhood,
                      neighbourhood_cleansed,city,state,zipcode,market,smart_location,country_code,country,latitude,
                      longitude,is_location_exact)
                      VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""


#Colunas e comando sql para inserir os dados na tabela T_DIM_PROPRIEDADE

columns_propriedade = ['id','property_type','room_type','accommodates',
                       'bathrooms','bedrooms','beds','bed_type','amenities','minimum_nights','maximum_nights',
                       'calendar_updated','has_availability','availability_30','availability_60','availability_90',
                       'availability_365'    
]

sql_propriedade =""" INSERT INTO a_bronze. "T_DIM_PROPRIEDADE"(fk_anuncio,property_type,room_type,
                     accommodates,bathrooms,bedrooms,beds,bed_type,amenities,minimum_nights,maximum_nights,
                     calendar_updated,has_availability,availability_30,availability_60,availability_90,availability_365)
                     VALUES(%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s)
"""

#Colunas e comando sql para inserir os dados na tabela T_FATO_PRECIFICACAO

columns_precificacao = ['id','price','security_deposit',
                        'cleaning_fee','guests_included','extra_people', 'last_scraped', 'calendar_last_scraped'
]

sql_precificacao = """ INSERT INTO a_bronze. "T_FATO_PRECIFICACAO"(fk_anuncio,price,security_deposit,
                       cleaning_fee,guests_included, extra_people, last_scraped, calendar_last_scraped)
                       VALUES(%s,%s,%s,	%s,	%s,	%s, %s, %s)
"""

#Colunas e comando sql para inserir os dados na tabela T_FATO_AVALIACAO


columns_avalidacao = ['id','number_of_reviews','first_review','last_review','review_scores_rating',
                      'review_scores_accuracy','review_scores_cleanliness','review_scores_checkin',
                      'review_scores_communication','review_scores_location','review_scores_value','reviews_per_month',
                      'number_of_reviews_ltm'
]

sql_avaliacao = """ INSERT INTO a_bronze. "T_FATO_AVALIACAO"(fk_anuncio, number_of_reviews,first_review,
                    last_review,review_scores_rating,review_scores_accuracy,review_scores_cleanliness,
                    review_scores_checkin,review_scores_communication,review_scores_location,review_scores_value,
                    reviews_per_month,number_of_reviews_ltm)
                    VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
"""

#Colunas e comando sql para inserir os dados na tabela T_DIM_REGRAS

columns_regras = ['id','requires_license','instant_bookable','is_business_travel_ready',
                  'cancellation_policy','require_guest_profile_picture','require_guest_phone_verification',
                  'calculated_host_listings_count','minimum_minimum_nights','maximum_minimum_nights','minimum_maximum_nights',
                  'maximum_maximum_nights','minimum_nights_avg_ntm','maximum_nights_avg_ntm','calculated_host_listings_count_entire_homes',
                  'calculated_host_listings_count_private_rooms','calculated_host_listings_count_shared_rooms'
]

sql_regras = """ INSERT INTO a_bronze. "T_DIM_REGRAS"(fk_anuncio, requires_license,instant_bookable,
                 is_business_travel_ready,cancellation_policy,require_guest_profile_picture,require_guest_phone_verification,
                 calculated_host_listings_count,minimum_minimum_nights,maximum_minimum_nights,minimum_maximum_nights,
                 maximum_maximum_nights,minimum_nights_avg_ntm,maximum_nights_avg_ntm,calculated_host_listings_count_entire_homes,
                 calculated_host_listings_count_private_rooms,calculated_host_listings_count_shared_rooms)
                 VALUES(%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s,	%s)
                 ON CONFLICT(fk_anuncio) DO NOTHING
"""

for file in csv_files:
    if files_already_processed(cursor, file):
        print(f"Arquivo ja processado {file}")
        continue
    path = os.path.join(files_path, file)
    print(f'Lendo arquivo 📄 {file}')
    df = pd.read_csv(path, low_memory=False)

    #tratamento de colunas de data onde nao tem valor preenchido para evitar erro na inserção dos dados
    date_columns = ['host_since','first_review', 'last_review']
    for col in date_columns:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors='coerce')
            df[col] = df[col].dt.date
            df[col] = df[col].where(df[col].notnull(), None)

    
    #tratamento de valores nas colunas de float
    price_columns = ['price', 'security_deposit', 'cleaning_fee', 'extra_people']
    for col in price_columns:
        if col in df.columns:
            # Remove símbolos de moeda, vírgulas e espaços
            df[col] = df[col].astype(str).str.replace(r'[\$,]', '', regex=True)
            # Converte para float, valores inválidos viram NaN
            df[col] = pd.to_numeric(df[col], errors='coerce')
            # Substitui NaN por None (opcional, para inserir como NULL no banco)
            df[col] = df[col].where(df[col].notnull(), None)
    

    #Inserindo dados nas tabelas
    load_csv_to_db(df, "T_DIM_ANUNCIO", columns_anuncio, sql_anuncio)
    load_csv_to_db(df, "T_DIM_ANFITRIAO", columns_anfitriao, sql_anfitriao)
    load_csv_to_db(df, "T_DIM_LOCALIZACAO", columns_localizacao, sql_localizacao)
    load_csv_to_db(df, "T_DIM_PROPRIEDADE", columns_propriedade, sql_propriedade)
    load_csv_to_db(df, "T_FATO_PRECIFICACAO", columns_precificacao, sql_precificacao)
    load_csv_to_db(df, "T_FATO_AVALIACAO", columns_avalidacao, sql_avaliacao)
    load_csv_to_db(df, "T_DIM_REGRAS", columns_regras, sql_regras)
    insert_file_processd(cursor, file)
    conn.commit()
    print(f'✅Dados inseridos de {file} com sucesso!')

#encerrar conexao

cursor.close()
conn.close()
print('Processo concluido!')




