WITH yesterday AS (
    SELECT *
    FROM host_activity_reduced
    WHERE month = DATE '2023-01-01'
),
today AS (
    SELECT
        user_id,
        COUNT(*) AS num_hits,
        COUNT(DISTINCT user_id) AS num_unique
    FROM events
    WHERE DATE(event_time) = DATE '2023-01-03'
    GROUP BY user_id
)
INSERT INTO host_activity_reduced (
    user_id, 
    month,
    hit_array,
    unique_visitors
)
SELECT
    COALESCE(y.user_id, t.user_id),  
    DATE '2023-01-01',
    COALESCE(y.hit_array,
        array_fill(NULL::INTEGER, ARRAY[DATE '2023-01-03' - DATE '2023-01-01']))
        || COALESCE(t.num_hits, 0),
    COALESCE(y.unique_visitors,
        array_fill(NULL::INTEGER, ARRAY[DATE '2023-01-03' - DATE '2023-01-01']))
        || COALESCE(t.num_unique, 0)
FROM yesterday y
FULL OUTER JOIN today t
    ON y.user_id = t.user_id;
-- This query updates the host_activity_reduced table by inserting new records for users based on their activity