# Congratulations!

You have successfully built and run the **NexaTel Telco Churn MLOps Pipeline** on Apache Airflow.

## What You Accomplished

- Deployed a production-grade 6-task Airflow DAG
- Ran the full pipeline: data collection → feature engineering → model training → validation → explanations → score publishing
- Inspected task logs and XCom values
- Tested the 3-layer validation gate that protects production from bad models
- Read the run summary output used by CRM agents

## The Real-World Impact

This pipeline, when run on NexaTel's actual data, delivered:

- F1 score improved from **0.31 → 0.83**
- **22% reduction** in customer churn in 90 days
- **~$3.1M** yearly revenue recovered
- Top-3 SHAP reasons per customer sent directly to CRM agents

## Key Concepts to Remember

| Concept | What it means |
|---|---|
| **DAG** | Directed Acyclic Graph — defines task order |
| **XCom** | How Airflow tasks pass data between each other |
| **PSI** | Population Stability Index — detects data drift |
| **SHAP** | Explains *why* a customer got a high churn score |
| **3-layer gate** | Data → F1 → SHAP dominance — all must pass before publishing |

## Next Steps

- Add **Evidently AI** for real PSI drift monitoring
- Connect the DAG output to a **FastAPI endpoint** for live scoring
- Deploy on **Kubernetes** with KubernetesPodOperator for scalability
- Schedule on **MWAA (AWS Managed Airflow)** for production

Well done!
