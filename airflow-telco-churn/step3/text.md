# Step 3: Trigger a DAG Run & Inspect Tasks

## Trigger the Pipeline Manually

```bash
airflow dags trigger nexa_churn_pipeline
```

## Watch the Tasks Run

```bash
airflow tasks states-for-dag-run nexa_churn_pipeline \
  $(airflow dags list-runs -d nexa_churn_pipeline --output plain | awk 'NR==2{print $3}')
```

Or watch it in the **Airflow UI** — go to the DAG → **Graph** view and refresh every few seconds. Tasks turn green as they complete.

## Check Individual Task Logs

```bash
airflow tasks logs nexa_churn_pipeline collect_data \
  $(airflow dags list-runs -d nexa_churn_pipeline --output plain | awk 'NR==2{print $3}')
```

Replace `collect_data` with any task name to see its output:
- `collect_data`
- `feature_engineering`
- `train_model`
- `validate_model`
- `generate_explanations`
- `publish_scores`

## Check XCom Values

XCom is how tasks pass data to each other. Check what `train_model` logged:

```bash
airflow tasks render nexa_churn_pipeline train_model \
  $(airflow dags list-runs -d nexa_churn_pipeline --output plain | awk 'NR==2{print $3}')
```

## Expected Flow
