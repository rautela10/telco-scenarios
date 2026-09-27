#!/bin/bash
if [ -f ~/airflow/outputs/run_summary.json ]; then
  STATUS=$(python3 -c "import json; d=json.load(open('$HOME/airflow/outputs/run_summary.json')); print(d['status'])" 2>/dev/null)
  if [ "$STATUS" == "SUCCESS" ]; then
    echo "done"
  else
    echo "Run summary found but status is not SUCCESS. Check task logs."
    exit 1
  fi
else
  echo "run_summary.json not found. Complete the DAG run first."
  exit 1
fi
