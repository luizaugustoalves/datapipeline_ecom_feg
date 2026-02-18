"""
Bronze Layer - Task Group para carga de CSVs do GCS para BigQuery.
Carrega os 7 arquivos CSV como tabelas raw (tudo STRING).
"""
from airflow.utils.task_group import TaskGroup
from operators.gcs_to_bq import GCSToBQOperator
from config.project_params import BQ_BRONZE, GCS_BRONZE_PREFIX


def ecommerce_bronze_task_group(dag):
    """Cria task group para carga Bronze de todos os CSVs."""

    with TaskGroup(group_id='bronze', dag=dag) as bronze:

        clientes = GCSToBQOperator(
            task_id='clientes_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}clientes.csv'],
            dest_table=f'{BQ_BRONZE}.clientes',
            fields='cliente_id;nome;email;telefone;estado;canal_aquisicao;data_cadastro;fonte_crm',
            dag=dag,
        )

        produtos = GCSToBQOperator(
            task_id='produtos_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}produtos.csv'],
            dest_table=f'{BQ_BRONZE}.produtos',
            fields='produto_id;nome_produto;categoria;preco_unitario;custo;estoque_atual',
            dag=dag,
        )

        pedidos = GCSToBQOperator(
            task_id='pedidos_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}pedidos.csv'],
            dest_table=f'{BQ_BRONZE}.pedidos',
            fields='pedido_id;cliente_id;data_pedido;canal_venda;status;valor_frete;desconto_aplicado',
            dag=dag,
        )

        itens_pedido = GCSToBQOperator(
            task_id='itens_pedido_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}itens_pedido.csv'],
            dest_table=f'{BQ_BRONZE}.itens_pedido',
            fields='item_id;pedido_id;produto_id;quantidade;preco_unitario;subtotal',
            dag=dag,
        )

        campanhas = GCSToBQOperator(
            task_id='campanhas_marketing_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}campanhas_marketing.csv'],
            dest_table=f'{BQ_BRONZE}.campanhas_marketing',
            fields='campanha_id;nome_campanha;plataforma;data_inicio;data_fim;investimento;impressoes;cliques;conversoes',
            dag=dag,
        )

        atribuicao = GCSToBQOperator(
            task_id='atribuicao_campanha_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}atribuicao_campanha.csv'],
            dest_table=f'{BQ_BRONZE}.atribuicao_campanha',
            fields='atribuicao_id;pedido_id;campanha_id;modelo_atribuicao',
            dag=dag,
        )

        eventos_ga = GCSToBQOperator(
            task_id='eventos_ga_to_bq',
            source_objects=[f'{GCS_BRONZE_PREFIX}eventos_google_analytics.csv'],
            dest_table=f'{BQ_BRONZE}.eventos_google_analytics',
            fields='evento_id;session_id;cliente_id;evento;pagina;dispositivo;data_evento',
            dag=dag,
        )

    return bronze
