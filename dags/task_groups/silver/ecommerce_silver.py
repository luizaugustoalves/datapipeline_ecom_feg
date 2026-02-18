"""
Silver Layer - Task Group para transformações de limpeza e tipagem.
Lê do Bronze (STRING) e grava no Silver com tipos corretos.
"""
from airflow.utils.task_group import TaskGroup
from operators.bq_insert_job import BQInsertJobOperator
from config.project_params import BQ_SILVER


def ecommerce_silver_task_group(dag):
    """Cria task group para transformações Silver."""

    with TaskGroup(group_id='silver', dag=dag) as silver:

        silver_clientes = BQInsertJobOperator(
            task_id='silver_clientes',
            dest_table=f'{BQ_SILVER}.clientes',
            sql_file='silver/sql/silver_clientes.sql',
            dag=dag,
        )

        silver_produtos = BQInsertJobOperator(
            task_id='silver_produtos',
            dest_table=f'{BQ_SILVER}.produtos',
            sql_file='silver/sql/silver_produtos.sql',
            dag=dag,
        )

        silver_pedidos = BQInsertJobOperator(
            task_id='silver_pedidos',
            dest_table=f'{BQ_SILVER}.pedidos',
            sql_file='silver/sql/silver_pedidos.sql',
            dag=dag,
        )

        silver_itens_pedido = BQInsertJobOperator(
            task_id='silver_itens_pedido',
            dest_table=f'{BQ_SILVER}.itens_pedido',
            sql_file='silver/sql/silver_itens_pedido.sql',
            dag=dag,
        )

        silver_campanhas = BQInsertJobOperator(
            task_id='silver_campanhas_marketing',
            dest_table=f'{BQ_SILVER}.campanhas_marketing',
            sql_file='silver/sql/silver_campanhas_marketing.sql',
            dag=dag,
        )

        silver_atribuicao = BQInsertJobOperator(
            task_id='silver_atribuicao_campanha',
            dest_table=f'{BQ_SILVER}.atribuicao_campanha',
            sql_file='silver/sql/silver_atribuicao_campanha.sql',
            dag=dag,
        )

        silver_eventos_ga = BQInsertJobOperator(
            task_id='silver_eventos_ga',
            dest_table=f'{BQ_SILVER}.eventos_google_analytics',
            sql_file='silver/sql/silver_eventos_ga.sql',
            dag=dag,
        )

    return silver
