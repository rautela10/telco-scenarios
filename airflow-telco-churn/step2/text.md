# Step 2: Deploy the Churn Pipeline DAG

## Create the DAGs Folder

```bash
mkdir -p ~/airflow/dags
```

## Create the DAG File

```bash
cat > ~/airflow/dags/churn_pipeline.py << 'EOF'
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import random, json, os

default_args = {
    'owner': 'manav.rautela',
    'depends_on_past': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=10),
}

def collect_data(**context):
    print("Pulling CDR + CRM records from NexaTel data lake...")
    records = random.randint(45000, 55000)
    print(f"Collected {records} customer records")
    context['ti'].xcom_push(key='record_count', value=records)

def feature_engineering(**context):
    records = context['ti'].xcom_pull(key='record_count', task_ids='collect_data')
    print(f"Engineering features for {records} customers...")
    print("Computing: tenure_months, monthly_arpu, complaint_rate, roaming_flag")

def train_model(**context):
    print("Training LightGBM churn model...")
    f1_score = round(random.uniform(0.78, 0.87), 4)
    print(f"Model trained — F1 Score: {f1_score}")
    context['ti'].xcom_push(key='f1_score', value=f1_score)

def validate_model(**context):
    f1_score = context['ti'].xcom_pull(key='f1_score', task_ids='train_model')
    print(f"Layer 1: Data quality — PASS")
    assert f1_score > 0.5, f"F1 {f1_score} below threshold 0.5"
    print(f"Layer 2: F1 Score {f1_score} — PASS")
    shap_dominance = round(random.uniform(0.35, 0.65), 2)
    assert shap_dominance < 0.80, f"SHAP dominance {shap_dominance} too high"
    print(f"Layer 3: SHAP dominance {shap_dominance} — PASS")
    print("All 3 validation layers passed. Model approved for deployment.")

def generate_explanations(**context):
    print("Generating SHAP explanations for high-risk customers...")
    customers = [
        {"id": f"CUST{i:04d}", "churn_prob": round(random.uniform(0.6,0.95),2),
         "top_reasons": ["high_complaint_rate","low_arpu","short_tenure"]}
        for i in range(1, 6)
    ]
    for c in customers:
        print(f"{c['id']}: {c['churn_prob']} — {', '.join(c['top_reasons'])}")
    context['ti'].xcom_push(key='flagged_customers', value=len(customers))

def publish_scores(**context):
    flagged = context['ti'].xcom_pull(key='flagged_customers', task_ids='generate_explanations')
    f1 = context['ti'].xcom_pull(key='f1_score', task_ids='train_model')
    summary = {
        "run_date": str(datetime.now().date()),
        "f1_score": f1,
        "flagged_customers": flagged,
        "status": "SUCCESS",
        "sla_met": True
    }
    os.makedirs(os.path.expanduser("~/airflow/outputs"), exist_ok=True)
    path = os.path.expanduser("~/airflow/outputs/run_summary.json")
    with open(path, "w") as f:
        json.dump(summary, f, indent=2)
    print(f"Run summary written to {path}")
    print(json.dumps(summary, indent=2))

with DAG(
    'nexa_churn_pipeline',
    default_args=default_args,
    description='NexaTel Telco Churn MLOps Pipeline',
    schedule_interval='0 2 * * *',
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['mlops', 'churn', 'nexa'],
) as dag:

    t1 = PythonOperator(task_id='collect_data', python_callable=collect_data)
    t2 = PythonOperator(task_id='feature_engineering', python_callable=feature_engineering)
    t3 = PythonOperator(task_id='train_model', python_callable=train_model)
    t4 = PythonOperator(task_id='validate_model', python_callable=validate_model)
    t5 = PythonOperator(task_id='generate_explanations', python_callable=generate_explanations)
    t6 = PythonOperator(task_id='publish_scores', python_callable=publish_scores)

    t1 >> t2 >> t3 >> t4 >> t5 >> t6
EOF
```

## Verify the DAG is Loaded

```bash
airflow dags list | grep churn
```

You should see `nexa_churn_pipeline` in the output.
