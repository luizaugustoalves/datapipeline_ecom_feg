"""
Operator customizado para carregar dados do GCS para BigQuery.
Versão simplificada do GCSToBQOperator do braveo-lakehouse.
"""
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from utils.bigquery import bq_schema_fields_string
from config.project_params import GCP_CONN_ID, BQ_PROJECT, GCS_BUCKET


class GCSToBQOperator(GCSToBigQueryOperator):
    """
    Carrega arquivos CSV do GCS para BigQuery.

    Params:
        dest_table: tabela destino no formato 'dataset.table'
        fields: campos separados por ';' (todos carregados como STRING)
        source_objects: lista de paths no GCS (ex: ['bronze/clientes.csv'])
        write_disposition: WRITE_TRUNCATE (default) ou WRITE_APPEND
        bucket: bucket GCS (default: config)
        gcp_conn_id: conexão GCP no Airflow (default: config)
    """

    def __init__(
        self,
        dest_table: str,
        fields: str,
        source_objects: list,
        write_disposition: str = 'WRITE_TRUNCATE',
        bucket: str = None,
        gcp_conn_id: str = None,
        **kwargs
    ):
        schema_fields = bq_schema_fields_string(fields)

        super().__init__(
            bucket=bucket or GCS_BUCKET,
            source_objects=source_objects,
            destination_project_dataset_table=f'{BQ_PROJECT}.{dest_table}',
            schema_fields=schema_fields,
            source_format='CSV',
            skip_leading_rows=1,
            write_disposition=write_disposition,
            create_disposition='CREATE_IF_NEEDED',
            gcp_conn_id=gcp_conn_id or GCP_CONN_ID,
            **kwargs
        )
