"""
Configurações do projeto E-commerce ETL por ambiente.
"""
import os

# Ambiente (development/staging/production)
AIRFLOW_ENV = os.getenv('AIRFLOW_ENV', 'development')

# ============================================
# Configurações GCP
# ============================================
GCP_CONN_ID = 'google_cloud_default'
BQ_PROJECT = 'teste-dados-feg'
GCS_BUCKET = 'teste-dados-feg-data-lake'

# ============================================
# Datasets BigQuery
# ============================================
BQ_BRONZE = 'bronze_ecommerce'
BQ_SILVER = 'silver_ecommerce'
BQ_GOLD = 'gold_ecommerce'

# ============================================
# Caminhos GCS
# ============================================
GCS_BRONZE_PREFIX = 'bronze/'

# ============================================
# Retry e timeout padrão
# ============================================
DEFAULT_RETRIES = 1
DEFAULT_RETRY_DELAY_MINUTES = 5
DEFAULT_EXECUTION_TIMEOUT_MINUTES = 60

# ============================================
# DAG defaults
# ============================================
DAG_OWNER = 'data-engineering'
DAG_EMAIL = ['luiz@example.com']
DAG_START_DATE = '2026-02-17'
