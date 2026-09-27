#!/bin/bash
airflow version &>/dev/null
if [ $? -eq 0 ]; then
  echo "done"
else
  echo "Airflow not found. Run: pip install apache-airflow"
  exit 1
fi
