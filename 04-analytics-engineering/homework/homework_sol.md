

Explanation
In the sources.yaml, the database and schema are dynamically populated using environment variables (DBT_BIGQUERY_PROJECT and DBT_BIGQUERY_SOURCE_DATASET), with defaults specified in case the environment variables are not set.

database: The value for database is taken from the DBT_BIGQUERY_PROJECT environment variable. If it is not set, it defaults to dtc_zoomcamp_2025.
In this case, DBT_BIGQUERY_PROJECT=myproject, so it will use myproject as the database.
schema: The value for schema is taken from the DBT_BIGQUERY_SOURCE_DATASET environment variable. If it is not set, it defaults to raw_nyc_tripdata.
In this case, DBT_BIGQUERY_DATASET=my_nyc_tripdata, so it will use my_nyc_tripdata as the schema.
The SQL Model
In the model, you're using {{ source('raw_nyc_tripdata', 'ext_green_taxi') }} to reference the source table ext_green_taxi under the raw_nyc_tripdata source.

The source function dynamically compiles to:
source('raw_nyc_tripdata', 'ext_green_taxi')
This refers to the source raw_nyc_tripdata and the table ext_green_taxi.
Given the environment variables, it will compile as follows:

database will be myproject (from DBT_BIGQUERY_PROJECT).
schema will be my_nyc_tripdata (from DBT_BIGQUERY_DATASET).





pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY


Explanation:
var("days_back", "30"): This is the default value for days_back, which is used if no value is provided for this variable. In this case, it's 30.
env_var("DAYS_BACK", "30"): This fetches the environment variable DAYS_BACK and falls back to the default of 30 if the environment variable is not set.
var("days_back", env_var("DAYS_BACK", "30")): This ensures that the variable days_back gets its value first from the command line (if passed) and falls back to the environment variable DAYS_BACK if the command line argument is not provided. If neither is set, it defaults to 30.


dbt build --select +fact_trips+ --vars '{'is_test_run': 'false'}'


dbt build --select +dim_fhv_trips+ --vars '{'is_test_run': 'false'}'


dbt build --select +fct_taxi_trips_monthly_fare_p95+ --vars '{'is_test_run': 'false'}'


dbt build --select +fct_fhv_monthly_zone_traveltime_p90+ --vars '{'is_test_run': 'false'}'

