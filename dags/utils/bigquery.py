"""
Funções utilitárias para BigQuery.
"""
import re
try:
    import unidecode
except ImportError:
    unidecode = None


def bq_schema_fields_string(fields=''):
    """
    Gera lista de schema fields a partir de string delimitada por ';'.
    Todos os campos são criados como STRING e NULLABLE.

    Exemplo:
        bq_schema_fields_string('id;nome;email')
        -> [{'mode': 'NULLABLE', 'name': 'id', 'type': 'STRING'}, ...]
    """
    schema_fields = []
    field_list = fields.split(';')
    for field in field_list:
        field = field.strip()
        if field:
            schema_fields.append({
                'mode': 'NULLABLE',
                'name': field,
                'type': 'STRING'
            })
    return schema_fields


def transform_to_valid_column_name(value):
    """Transforma um valor em um nome de coluna válido no BigQuery."""
    if unidecode:
        value = unidecode.unidecode(value)
    sanitized_name = re.sub(r'[^a-zA-Z0-9_]', '_', value)
    if re.match(r'^\d', sanitized_name):
        sanitized_name = "_" + sanitized_name
    return sanitized_name
