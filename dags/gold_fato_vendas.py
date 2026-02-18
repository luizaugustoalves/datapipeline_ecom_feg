"""
DAG: Gold - Fato Vendas
Granularidade: 1 linha por item de pedido com rateio de desconto/frete.
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
    dag_id='gold_fato_vendas',
    default_args=get_default_args(),
    description='Gold: Fato Vendas com rateio de desconto e frete',
    schedule_interval=None,
    start_date=datetime(2026, 2, 17),
    catchup=False,
    max_active_runs=1,
    tags=['ecommerce', 'gold', 'fato'],
    template_searchpath=[os.path.join(DAG_FOLDER, 'task_groups')],
) as dag:

    start = EmptyOperator(task_id='start')

    fato_vendas = BQInsertJobOperator(
        task_id='fato_vendas',
        dest_table=f'{BQ_GOLD}.fato_vendas',
        sql_file='gold/sql/fato_vendas.sql',
    )

    end = EmptyOperator(task_id='end')

    start >> fato_vendas >> end
