# Step 4: Validate Outputs & Monitor Drift

## Check the Run Summary

After the DAG completes, read the output file:

```bash
cat ~/airflow/outputs/run_summary.json
```

You should see something like:

```json
{
  "run_date": "2024-01-15",
  "f1_score": 0.8312,
  "flagged_customers": 5,
  "status": "SUCCESS",
  "sla_met": true
}
```

## Understanding the 3-Layer Validation Gate

The `validate_model` task enforces three checks before scores are published:

| Layer | Check | Threshold |
|---|---|---|
| Layer 1 | Data quality — no nulls, schema valid | Must pass |
| Layer 2 | Model F1 score | Must be > 0.5 |
| Layer 3 | SHAP feature dominance | Must be < 80% |

If **any layer fails**, the DAG stops and no scores are published to CRM.

## PSI Drift Monitoring

In production, Evidently AI computes PSI (Population Stability Index) per feature after each run:

| PSI Value | Meaning | Action |
|---|---|---|
| < 0.1 | Stable | No action |
| 0.1 – 0.2 | Minor drift | Monitor closely |
| > 0.2 | Significant drift | Trigger retrain |

## Simulate a Failed Validation

Edit the DAG to force a low F1 score:

```bash
sed -i 's/random.uniform(0.78, 0.87)/random.uniform(0.2, 0.4)/' \
  ~/airflow/dags/churn_pipeline.py
airflow dags trigger nexa_churn_pipeline
```

Watch the `validate_model` task fail in the UI — this is the safety gate protecting production from a bad model.

Restore the original range when done:

```bash
sed -i 's/random.uniform(0.2, 0.4)/random.uniform(0.78, 0.87)/' \
  ~/airflow/dags/churn_pipeline.py
```
