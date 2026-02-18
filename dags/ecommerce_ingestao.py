"""
DAG: E-commerce Ingestão (GCS → Bronze → Silver)

Descrição:
    Pipeline de ingestão que consome 7 CSVs do GCS, carrega no Bronze (raw)
    e transforma para Silver (limpo, tipado, deduplicado).
    Cria datasets automaticamente na primeira execução (exists_ok=True).

Projeto GCP: teste-dados-feg
GCS Bucket: teste-dados-feg-data-lake
"""
import os
import sys
from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.google.cloud.operators.bigquery import (
    BigQueryCreateEmptyDatasetOperator,
)
from airflow.utils.task_group import TaskGroup

DAG_FOLDER = os.path.dirname(os.path.abspath(__file__))
if DAG_FOLDER not in sys.path:
    sys.path.insert(0, DAG_FOLDER)

from config.project_params import (
    BQ_PROJECT, GCP_CONN_ID,
    BQ_BRONZE, BQ_SILVER, BQ_GOLD,
)
from utils.dag import get_default_args
from task_groups.bronze.ecommerce_bronze import ecommerce_bronze_task_group
from task_groups.silver.ecommerce_silver import ecommerce_silver_task_group


TEMPLATE_SEARCHPATH = [
    os.path.join(DAG_FOLDER, 'task_groups'),
]

with DAG(
    dag_id='ecommerce_ingestao',
    default_args=get_default_args(),
    description='Ingestão E-commerce: GCS → Bronze → Silver',
    schedule_interval=None,
    start_date=datetime(2026, 2, 17),
    catchup=False,
    max_active_runs=1,
    tags=['ecommerce', 'bronze', 'silver', 'ingestao'],
    template_searchpath=TEMPLATE_SEARCHPATH,
) as dag:

    start = EmptyOperator(task_id='start')
    end = EmptyOperator(task_id='end')

    # Criação idempotente dos datasets (exists_ok=True)
    # - Primeira execução: cria os 3 datasets
    # - Execuções seguintes: ignora silenciosamente
    with TaskGroup(group_id='create_datasets') as create_datasets:
        BigQueryCreateEmptyDatasetOperator(
            task_id='create_bronze_dataset',
            dataset_id=BQ_BRONZE,
            project_id=BQ_PROJECT,
            gcp_conn_id=GCP_CONN_ID,
            exists_ok=True,
            location='US',
        )
        BigQueryCreateEmptyDatasetOperator(
            task_id='create_silver_dataset',
            dataset_id=BQ_SILVER,
            project_id=BQ_PROJECT,
            gcp_conn_id=GCP_CONN_ID,
            exists_ok=True,
            location='US',
        )
        BigQueryCreateEmptyDatasetOperator(
            task_id='create_gold_dataset',
            dataset_id=BQ_GOLD,
            project_id=BQ_PROJECT,
            gcp_conn_id=GCP_CONN_ID,
            exists_ok=True,
            location='US',
        )

    bronze = ecommerce_bronze_task_group(dag)
    silver = ecommerce_silver_task_group(dag)

    start >> create_datasets >> bronze >> silver >> end


