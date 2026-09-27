# Airflow for MLOps: Telco Churn Pipeline

## Welcome

NexaTel's data team built an end-to-end MLOps pipeline to predict customer churn. 
In this scenario you will deploy that exact pipeline as an Apache Airflow DAG and 
watch it run — from raw data collection all the way to per-customer SHAP explanations.

## What You Will Build

A 6-task Airflow DAG that runs nightly at 02:00:

| Task | What it does |
|---|---|
| `collect_data` | Pulls CDR + CRM records, validates schema |
| `feature_engineering` | Computes tenure, ARPU, complaint rate |
| `train_model` | Trains LightGBM, logs F1 score via XCom |
| `validate_model` | 3-layer gate: data quality → F1 > 0.5 → SHAP dominance |
| `generate_explanations` | Top-3 SHAP reasons per customer |
| `publish_scores` | Writes scores + run summary JSON |

## Background

- **Model**: LightGBM (F1 improved from 0.31 → 0.83)
- **Drift detection**: Evidently AI PSI (retrain triggered when PSI > 0.2)
- **Explainability**: SHAP values — top 3 reasons sent to CRM agents
- **Outcome**: 22% churn reduction, ~$3.1M yearly revenue recovered

## Prerequisites

No local setup needed — Airflow is pre-installed in this environment.
