"""
Operations Analytics Pipeline DAG.

Orchestrates the dbt transformation layer: runs all models in dependency
order (staging -> intermediate -> marts), then validates data quality
with dbt tests. Designed to run daily, picking up any new orders loaded
into the raw table.

Status: designed and version-controlled. Local execution pending a
Docker/WSL environment fix on the development machine (see README).
"""
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

DBT_PROJECT_DIR = "/opt/airflow/dbt_project"
DBT_PROFILES_DIR = "/opt/airflow/dbt_project"

default_args = {
    "owner": "andres_navarro",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="ops_analytics_pipeline",
    description="Runs dbt models and tests for the operations analytics platform",
    default_args=default_args,
    schedule_interval="@daily",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["ops-analytics", "portfolio", "dbt"],
) as dag:

    run_staging = BashOperator(
        task_id="run_staging_models",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --select staging.* --profiles-dir {DBT_PROFILES_DIR}",
    )

    run_intermediate = BashOperator(
        task_id="run_intermediate_models",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --select intermediate.* --profiles-dir {DBT_PROFILES_DIR}",
    )

    run_marts = BashOperator(
        task_id="run_marts_models",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --select marts.* --profiles-dir {DBT_PROFILES_DIR}",
    )

    test_all = BashOperator(
        task_id="test_all_models",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --profiles-dir {DBT_PROFILES_DIR}",
    )

    # Explicit dependency order mirrors the dbt DAG itself:
    # staging must complete before intermediate, which must complete
    # before marts, then everything gets validated with tests.
    run_staging >> run_intermediate >> run_marts >> test_all