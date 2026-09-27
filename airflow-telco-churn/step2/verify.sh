#!/bin/bash
airflow dags list 2>/dev/null | grep -q "nexa_churn_pipeline"
if [ $? -eq 0 ]; then
  echo "done"
else
  echo "DAG not found. Make sure churn_pipeline.py is in ~/airflow/dags/ and airflow is running."
  exit 1
fi
