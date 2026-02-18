"""
DAG: Gold - Dimensão Produto
Enriquecida com métricas de venda e flags operacionais.
Depende de: ecommerce_ingestao
"""
import os, sys
from datetime import datetime
from airflow import DAG
from airflow.operators.empty import EmptyOperator

DAG_FOLDER = os.path.dirname(os.path.abspath(__file__))
if DAG_FOLDER not in sys.path:
    sys.path.insert(0, DAG_FOLDER)

from utils.dag import get_default_args
from operators.bq_insert_job import BQInsertJobOperator
from config.project_params import BQ_GOLD

with DAG(
    dag_id='gold_dim_produto',
    default_args=get_default_args(),
    description='Gold: Dimensão Produto com métricas e flags',
    schedule_interval=None,
    start_date=datetime(2026, 2, 17),
    catchup=False,
    max_active_runs=1,
    tags=['ecommerce', 'gold', 'dimensao'],
    template_searchpath=[os.path.join(DAG_FOLDER, 'task_groups')],
) as dag:

    start = EmptyOperator(task_id='start')

    dim_produto = BQInsertJobOperator(
        task_id='dim_produto',
        dest_table=f'{BQ_GOLD}.dim_produto',
        sql_file='gold/sql/dim_produto.sql',
    )

    end = EmptyOperator(task_id='end')

    start >> dim_produto >> end
