{{ config(materialized='table') }}

WITH filtered_trips AS (
    SELECT 
        service_type,
        pickup_year AS year,
        pickup_month AS month,
        fare_amount
    FROM {{ ref('fact_trips') }}
    WHERE fare_amount > 0 
      AND trip_distance > 0
      AND payment_type_description IN ('Cash', 'Credit card')
),
percentiles AS (
    SELECT 
        service_type,
        year,
        month,
        APPROX_QUANTILES(fare_amount, 100)[SAFE_OFFSET(97)] AS p97,
        APPROX_QUANTILES(fare_amount, 100)[SAFE_OFFSET(95)] AS p95,
        APPROX_QUANTILES(fare_amount, 100)[SAFE_OFFSET(90)] AS p90
    FROM filtered_trips
    GROUP BY service_type, year, month
)
SELECT * FROM percentiles
WHERE year = 2020 AND month = 4  