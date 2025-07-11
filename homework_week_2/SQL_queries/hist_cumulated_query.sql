INSERT INTO hosts_cumulated (user_id, date, host_activity_datelist)
SELECT
    user_id,
    DATE '2023-01-31' AS date,
    ARRAY_AGG(DISTINCT DATE(event_time::timestamp) ORDER BY DATE(event_time::timestamp)) AS host_activity_datelist
FROM events
WHERE event_time::timestamp >= DATE '2023-01-01'
  AND event_time::timestamp <= DATE '2023-01-31'
GROUP BY user_id;
-- This query aggregates the distinct dates of user activity from the events table for each user