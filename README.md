# 🏠 Airbnb Analytics DW: Pipeline de Dados com SQL, PostgreSQL e Power BI

Este projeto simula uma arquitetura moderna de dados baseada no conceito **medalhão (Bronze, Silver e Gold)** utilizando dados públicos de hospedagens no Airbnb no Rio de Janeiro. O objetivo é construir um **Data Warehouse completo**, praticar **técnicas de SQL do básico ao avançado**, e apresentar os resultados em **dashboards interativos no Power BI**.

---

## 🎯 Objetivo

- Criar um pipeline de dados completo com ingestão, tratamento, modelagem e visualização.
- Aplicar boas práticas de engenharia de dados com arquitetura em camadas.
- Praticar consultas SQL complexas e modelagem dimensional.
- Explorar insights sobre padrões de locação, precificação e comportamento de anfitriões.

---

## 🧱 Arquitetura do Projeto

O projeto segue a arquitetura de dados em camadas:

```mermaid
graph TD
  A[CSV Original (dados brutos)] --> B[Bronze: Ingestão dos dados no PostgreSQL]
  B --> C[Silver: Tratamento e padronização]
  C --> D[Gold: Modelagem dimensional para análise]
  D --> E[Power BI: Visualização e KPIs]
```

### 🔹 Bronze
- Dados crus importados diretamente do CSV sem tratamento.
- Armazenados como estão para rastreabilidade e auditoria.

### 🔸 Silver
- Dados limpos, convertidos, padronizados e enriquecidos.
- Separação de dimensões como bairro, tipo de propriedade, etc.

### 🟡 Gold
- Tabelas de fato e dimensões criadas para análise com BI.
- Agregações e modelos otimizados para consumo no Power BI.

---

## 🧰 Tecnologias Utilizadas

| Tecnologia         | Finalidade                                 |
|--------------------|---------------------------------------------|
| **PostgreSQL**     | Armazenamento e transformação dos dados     |
| **Python (pandas)**| Ingestão e conexão com banco de dados       |
| **Jupyter Notebook** | Documentação interativa e ETL com Python |
| **SQL**            | Transformações, modelagem e análises        |
| **Power BI**       | Visualização de dados e geração de dashboards |
| **VS Code**        | Edição e organização do projeto              |

---

## 📁 Estrutura do Projeto

```bash
airbnb-analytics-dw/
├── dados/
│   └── raw/                       # CSV original do Airbnb
├── notebooks/
│   ├── 01_bronze_ingestao.ipynb  # Ingestão e persistência no Postgres
│   ├── 02_silver_tratamento.ipynb# Limpeza e transformação
│   └── 03_gold_modelagem.ipynb   # Agregações e modelo dimensional
├── sql/
│   ├── ddl/                      # Scripts de criação de tabelas
│   ├── dml/                      # Scripts de transformações
│   └── consultas/                # SQL para análise de dados
├── powerbi/
│   └── airbnb_dashboard.pbix     # Dashboard Power BI
├── scripts/
│   └── ingestao_csv_postgres.py  # Ingestão dos dados no Postgres
└── README.md
```

---

## 📊 Dashboard Power BI

> [Adicione aqui uma imagem ou link do dashboard final assim que estiver concluído]

Principais visualizações:
- Preço médio por bairro
- Número de imóveis por tipo de acomodação
- Correlação entre avaliações e valor da diária
- Distribuição da disponibilidade por período

---

## 📚 Aprendizados Práticos

- Aplicação real da arquitetura **medalhão** em banco relacional.
- Uso de **SQL avançado** (joins, CTEs, window functions).
- Modelagem dimensional com **tabelas fato e dimensões**.
- Criação de um **pipeline de dados moderno** do zero.
- Integração com **Power BI** para tomada de decisão.

---

## 🧪 Exemplos de Consultas SQL

```sql
-- Exemplo: preço médio por bairro
SELECT neighborhood, ROUND(AVG(price), 2) AS avg_price
FROM silver_listings
GROUP BY neighborhood
ORDER BY avg_price DESC;
```

```sql
-- Top 10 imóveis mais caros com nota máxima
SELECT name, price, review_scores_rating
FROM silver_listings
WHERE review_scores_rating = 100
ORDER BY price DESC
LIMIT 10;
```

---

## 📥 Fonte dos Dados

- Kaggle: [Airbnb Listings Rio de Janeiro](https://www.kaggle.com/datasets/thaysagomes/rio-airbnb)

---

## 👨‍💻 Autor

**Jonathan Almeida**  
[LinkedIn](https://www.linkedin.com/in/jonathan-mesquita/) • [Portfólio](https://webhool-post-portifolio.amslmd.easypanel.host/)  
Desenvolvedor de soluções em dados, apaixonado por transformar informação em decisão.  
Especialista em Python, SQL, Power Platform e BI.

---

## 💡 Possíveis Expansões Futuras

- Pipeline automatizado com Airflow ou cron.
- Versão com dbt para controle de transformações.
- Deploy da camada de dados como API com FastAPI ou Flask.
- Comparativo de preços entre bairros e sazonalidade.
