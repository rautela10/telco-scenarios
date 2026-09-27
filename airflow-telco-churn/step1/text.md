# Step 1: Set Up Airflow & Explore the UI

## Start Airflow

Run the following commands to initialise the database and start Airflow in standalone mode:

```bash
export AIRFLOW_HOME=~/airflow
airflow db init
airflow standalone
```

Airflow will print a username and password in the terminal — copy them.

## Open the Airflow UI

Click the **Traffic / Ports** tab at the top of this page and open port **8080**.

Log in with the credentials printed in the terminal.

## Explore the UI

Once logged in:
1. You will see the DAG list — it may show some example DAGs
2. Click the toggle on any example DAG to see its Graph view
3. Notice the task dependencies shown as arrows

## What is a DAG?

A **DAG** (Directed Acyclic Graph) defines the order of tasks in a pipeline. Each box is a task; arrows show dependencies. Airflow runs them in order, retries on failure, and tracks every run.

## Verify

Once you can see the Airflow UI in your browser, run:

```bash
airflow version
```
