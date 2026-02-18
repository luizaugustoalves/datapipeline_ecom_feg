"""
Operator customizado para executar queries SQL no BigQuery.
Versão simplificada do BQInsertJobOperator do braveo-lakehouse.
"""
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from config.project_params import GCP_CONN_ID, BQ_PROJECT


class BQInsertJobOperator(BigQueryInsertJobOperator):
    """
    Executa uma query SQL no BigQuery e salva o resultado em uma tabela destino.

    Params:
        dest_table: tabela destino no formato 'dataset.table'
        sql_file: caminho do arquivo SQL (relativo ao template_searchpath)
        write_disposition: WRITE_TRUNCATE (default) ou WRITE_APPEND
        gcp_conn_id: conexão GCP no Airflow (default: config)
    """

    def __init__(
        self,
        dest_table: str,
        sql_file: str,
        write_disposition: str = 'WRITE_TRUNCATE',
        gcp_conn_id: str = None,
        **kwargs
    ):
        configuration = {
            'query': {
                'query': "{% include '" + sql_file + "' %}",
                'useLegacySql': False,
                'destinationTable': {
                    'projectId': BQ_PROJECT,
                    'datasetId': dest_table.split('.')[0],
                    'tableId': dest_table.split('.')[1],
                },
                'writeDisposition': write_disposition,
                'createDisposition': 'CREATE_IF_NEEDED',
            }
        }

        super().__init__(
            configuration=configuration,
            gcp_conn_id=gcp_conn_id or GCP_CONN_ID,
            location='US',
            **kwargs
        )
