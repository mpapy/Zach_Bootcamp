WITH yesterday AS (
    SELECT * FROM user_devices_cumulated
    WHERE date = DATE '2023-01-01'
),
today AS (
    SELECT 
        user_id,
        devices.browser_type,
        DATE '2023-01-02' AS today_date,
        COUNT(1) AS num_events
    FROM events
    LEFT JOIN devices ON devices.device_id = events.device_id
    WHERE DATE_TRUNC('day', event_time::TIMESTAMP) = DATE '2023-01-02'
      AND user_id IS NOT NULL AND browser_type IS NOT NULL
    GROUP BY user_id, devices.browser_type
)
INSERT INTO user_devices_cumulated (user_id, browser_type, active_dates, date)
SELECT
    COALESCE(t.user_id, y.user_id),
    COALESCE(t.browser_type, y.browser_type),
    COALESCE(y.active_dates, ARRAY[]::DATE[])
        || CASE 
             WHEN t.user_id IS NOT NULL THEN ARRAY[t.today_date]
             ELSE ARRAY[]::DATE[]
           END AS active_dates,
    COALESCE(t.today_date, y.date + INTERVAL '1 day') AS date
FROM yesterday y
FULL OUTER JOIN today t
  ON t.user_id = y.user_id AND t.browser_type = y.browser_type;
-- This query updates the user_devices_cumulated table by inserting new records for users and their browser types
-- based on their activity on a specific date. It combines data from the previous day and the current day,
-- ensuring that the active_dates array is updated with the new date if the user was active.