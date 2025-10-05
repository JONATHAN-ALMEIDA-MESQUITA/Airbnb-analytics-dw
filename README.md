# 🏠 Projeto Airbnb Analytics DW – Ingestão com Python, PostgreSQL e Visualização com Power BI

Este projeto simula um pipeline de dados completo para análise de hospedagens no Airbnb no Rio de Janeiro. A estrutura segue o padrão **medalhão (Bronze, Silver e Gold)** com armazenamento em **PostgreSQL**, ingestão via **Python** e visualização em **Power BI**.

---

## 🎯 Objetivo Geral

- Construir um pipeline moderno de dados.
- Utilizar boas práticas de **engenharia de dados**, **modelagem dimensional** e **Data viz**
- Praticar SQL do básico ao avançado com dados reais.
- Entregar **insights visuais** usando Power BI.

---

## 🧱 Arquitetura em Camadas

```mermaid
graph TD
  A["CSV Original - Airbnb"] --> B["Camada Bronze - Raw no PostgreSQL"]
  B --> C["Camada Silver - Transformações e Limpeza"]
  C --> D["Camada Gold - Modelagem Dimensional"]
  D --> E["Power BI - Dashboard Analítico"]
```

- **Bronze**: Ingestão bruta dos arquivos `.csv` originais.
- **Silver**: Limpeza, normalização e padronização dos dados.
- **Gold**: Criação de tabelas fato e dimensões otimizadas para análise.

---

## 🛠️ Principais Tecnologias

| Tecnologia      | Finalidade                                    |
|-----------------|-----------------------------------------------|
| **PostgreSQL**  | Armazenamento e modelagem de dados            |
| **Python**      | Ingestão automatizada com `pandas` e `psycopg2` |
| **SQL**         | Transformações, análises e criação de ERDs    |
| **Power BI**    | Visualização de KPIs e painéis interativos    |
| **VS Code**     | Edição de scripts, versionamento e organização |
| **dotenv**      | Gerenciamento seguro de credenciais           |

---

## ⚙️ Pipeline de Ingestão

- **Arquivos CSV originais** são armazenados em `/dados/row/`.
- Utiliza `psycopg2` com `execute_batch` para ingestão performática.
- Armazena em diferentes tabelas dentro do schema `bronze` no PostgreSQL.
- Criação de tabela de controle para **evitar reprocessamento** de arquivos já inseridos.

---

## 📁 Estrutura do Projeto

```bash
airbnb-analytics-dw/
├── dados/
│   └── row/ 
│   └── exemplo_amostra.csv      # Arquivos originais CSV
├── scripts/
│   └── extract_load_csv.py      # Script de ingestão com Python
│   └── .env                     # Credenciais de conexao com banco de dados
├── sql/
│   ├── DDL
│   ├── DML/                      # Criação de tabelas (Bronze/Silver/Gold)
│   ├── MODELAGEM_LOGICA_DIMENCIONAL/
├── powerbi/
│   └── dashboard.pbix            # Dashboard final em Power BI
├── notebooks/                    # Jupyter para exploração
├── .env                          # Variáveis de conexão com o banco
└── README.md
```

---

## 🔐 Boas Práticas Adotadas

- Uso de `.env` para proteger as credenciais de banco.
- Scripts organizados por finalidade (ETL, análise, dashboard).
- Criação de `tabela de controle` para arquivos processados.
- Uso de **chaves primárias e estrangeiras** com modelagem em **Star Schema**.
- Separação lógica dos dados nas camadas Bronze, Silver e Gold.

---

## 🧪 Exemplo de Query SQL

```sql
-- Preço medio por bairro, propriedade e tipo de quarto
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
```

---

## 📊 Dashboard no Power BI

> *<img width="1727" height="840" alt="image" src="https://github.com/user-attachments/assets/dff1db4f-c94e-4a0f-bbd8-8feec690f109" />
*

### KPIs e Visões:
- Preço médio por bairro e tipo de acomodação.
- Distribuição de reviews e avaliações.
- Mapa com localizações e disponibilidade.
- Evolução mensal de reservas e comparativos.

---

## 👨‍💻 Autor

**Jonathan Almeida**  
[LinkedIn](https://www.linkedin.com/in/jonathan-mesquita-3049581b1) • [Portfólio](https://mypersonalportifolio.streamlit.app)  


---


## 📦 Fonte dos Dados

- [Airbnb Listings Rio de Janeiro – Kaggle](https://www.kaggle.com/datasets/thaysagomes/rio-airbnb)
