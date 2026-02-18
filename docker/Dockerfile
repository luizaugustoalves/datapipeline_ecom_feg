FROM python:3.11.8-slim

ARG AIRFLOW_HOME=/home/airflow/gcs

ENV AIRFLOW_HOME=${AIRFLOW_HOME}

# Install system dependencies
RUN apt-get update -y && \
    apt-get install -yqq --no-install-recommends \
    python3-dev \
    wget \
    curl \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    build-essential \
    gcc \
    netcat-traditional \
    && apt-get autoremove -yqq --purge && apt-get clean

# Create airflow user
RUN useradd -ms /bin/bash -d /home/airflow airflow

# Create directories
RUN mkdir -p ${AIRFLOW_HOME}/dags \
    && mkdir -p /home/airflow/gcp \
    && chown -R airflow:airflow /home/airflow

# Copy and install requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy start script
COPY start_airflow.sh /home/airflow/start_airflow.sh
RUN sed -i 's/\r$//' /home/airflow/start_airflow.sh && chmod +x /home/airflow/start_airflow.sh

USER airflow
WORKDIR ${AIRFLOW_HOME}

EXPOSE 8080

CMD ["/bin/bash", "/home/airflow/start_airflow.sh"]
