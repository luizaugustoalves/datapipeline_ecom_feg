"""
Gold Layer - Task Group para tabelas analíticas.
Cria dimensões, fatos e análises a partir das tabelas Silver.
"""
from airflow.utils.task_group import TaskGroup
from operators.bq_insert_job import BQInsertJobOperator
from config.project_params import BQ_GOLD


def ecommerce_gold_task_group(dag):
    """Cria task group para tabelas Gold."""

    with TaskGroup(group_id='gold', dag=dag) as gold:

        # ========================================
        # Dimensões
        # ========================================
        dim_cliente = BQInsertJobOperator(
            task_id='dim_cliente',
            dest_table=f'{BQ_GOLD}.dim_cliente',
            sql_file='gold/sql/dim_cliente.sql',
            dag=dag,
        )

        dim_produto = BQInsertJobOperator(
            task_id='dim_produto',
            dest_table=f'{BQ_GOLD}.dim_produto',
            sql_file='gold/sql/dim_produto.sql',
            dag=dag,
        )

        # ========================================
        # Fatos
        # ========================================
        fato_vendas = BQInsertJobOperator(
            task_id='fato_vendas',
            dest_table=f'{BQ_GOLD}.fato_vendas',
            sql_file='gold/sql/fato_vendas.sql',
            dag=dag,
        )

        fato_marketing = BQInsertJobOperator(
            task_id='fato_marketing_performance',
            dest_table=f'{BQ_GOLD}.fato_marketing_performance',
            sql_file='gold/sql/fato_marketing_performance.sql',
            dag=dag,
        )

        # ========================================
        # Análises (respostas do teste)
        # ========================================
        ltv_por_canal = BQInsertJobOperator(
            task_id='ltv_por_canal',
            dest_table=f'{BQ_GOLD}.ltv_por_canal',
            sql_file='gold/sql/ltv_por_canal.sql',
            dag=dag,
        )

        cohort_recompra = BQInsertJobOperator(
            task_id='cohort_recompra',
            dest_table=f'{BQ_GOLD}.cohort_recompra',
            sql_file='gold/sql/cohort_recompra.sql',
            dag=dag,
        )

        anomalias_vendas = BQInsertJobOperator(
            task_id='anomalias_vendas_diarias',
            dest_table=f'{BQ_GOLD}.anomalias_vendas_diarias',
            sql_file='gold/sql/anomalias_vendas_diarias.sql',
            dag=dag,
        )

        roas_plataforma = BQInsertJobOperator(
            task_id='roas_por_plataforma',
            dest_table=f'{BQ_GOLD}.roas_por_plataforma',
            sql_file='gold/sql/roas_por_plataforma.sql',
            dag=dag,
        )

        # ========================================
        # Dependências
        # ========================================
        # Dimensões e fatos base primeiro
        [dim_cliente, dim_produto] >> fato_vendas
        dim_cliente >> fato_marketing

        # Análises dependem dos fatos/dimensões
        fato_vendas >> ltv_por_canal
        fato_vendas >> cohort_recompra
        fato_vendas >> anomalias_vendas
        fato_marketing >> roas_plataforma

    return gold
