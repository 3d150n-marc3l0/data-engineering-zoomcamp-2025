{{ config(materialized='table') }}

WITH trip_durations AS (
    SELECT
        *,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) as trip_duration
    FROM {{ ref('dim_fhv_trips') }}
),
p90_trip_durations as (
    select
        pickup_year as year,
        pickup_month as month,
        pickup_location_id,
        dropoff_location_id,
        pickup_zone,
        dropoff_zone,
        PERCENTILE_CONT(trip_duration, 0.90) OVER (
            PARTITION BY pickup_year, pickup_month, pickup_location_id, dropoff_location_id
        ) as p90_trip_duration,
        --ROW_NUMBER() OVER(
        --    PARTITION BY pickup_year, pickup_month, pickup_location_id, dropoff_location_id
		--) as rn
    from trip_durations
)
select 
    distinct year, month, pickup_location_id, dropoff_location_id, pickup_zone, dropoff_zone, p90_trip_duration
from p90_trip_durations