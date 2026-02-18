#!/bin/bash
set -e

echo "========================================="
echo "  Iniciando Airflow"
echo "========================================="

# Aguarda PostgreSQL estar disponível
echo "Aguardando PostgreSQL..."
while ! nc -z postgres 5432; do
  sleep 1
done
echo "PostgreSQL disponível!"

# Inicializa o banco de dados do Airflow
echo "Inicializando banco de dados do Airflow..."
airflow db init

# Cria usuário admin (ignora erro se já existe)
echo "Criando usuário admin..."
airflow users create \
  --username admin \
  --password admin \
  --firstname Admin \
  --lastname User \
  --role Admin \
  --email admin@example.com || true

echo "========================================="
echo "  Airflow iniciado com sucesso!"
echo "  UI: http://localhost:8080"
echo "  User: admin / Password: admin"
echo "========================================="

# Inicia scheduler em background e webserver em foreground
airflow scheduler &
airflow webserver --port 8080
