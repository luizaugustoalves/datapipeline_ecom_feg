"""
Funções utilitárias para DAGs.
"""
from datetime import datetime, timedelta
from config.project_params import (
    DAG_OWNER, DAG_EMAIL, DEFAULT_RETRIES, DEFAULT_RETRY_DELAY_MINUTES
)


def get_default_args():
    """Retorna default_args padrão para DAGs."""
    return {
        'owner': DAG_OWNER,
        'depends_on_past': False,
        'email': DAG_EMAIL,
        'email_on_failure': False,
        'email_on_retry': False,
        'retries': DEFAULT_RETRIES,
        'retry_delay': timedelta(minutes=DEFAULT_RETRY_DELAY_MINUTES),
    }
