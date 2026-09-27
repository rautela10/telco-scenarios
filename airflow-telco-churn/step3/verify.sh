#!/bin/bash
STATE=$(airflow dags list-runs -d nexa_churn_pipeline --output plain 2>/dev/null | awk 'NR==2{print $4}')
if [ "$STATE" == "success" ] || [ "$STATE" == "running" ]; then
  echo "done"
else
  echo "No successful run found yet. Run: airflow dags trigger nexa_churn_pipeline"
  exit 1
fi
