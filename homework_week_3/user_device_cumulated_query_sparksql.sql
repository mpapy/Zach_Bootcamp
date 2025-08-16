-- SparkSQL conversion of User Device Cumulated Query from HomeWork_02
-- Original PostgreSQL query converted to SparkSQL syntax

WITH yesterday AS (
    SELECT * 
    FROM user_devices_cumulated
    WHERE date = '2023-01-01'
),
today AS (
    SELECT 
        user_id,
        devices.browser_type,
        '2023-01-02' AS today_date,
        COUNT(1) AS num_events
    FROM events
    LEFT JOIN devices ON devices.device_id = events.device_id
    WHERE date(event_time) = '2023-01-02'
      AND user_id IS NOT NULL 
      AND browser_type IS NOT NULL
    GROUP BY user_id, devices.browser_type
)

INSERT INTO user_devices_cumulated
SELECT
    COALESCE(t.user_id, y.user_id) AS user_id,
    COALESCE(t.browser_type, y.browser_type) AS browser_type,
    CASE 
        WHEN t.user_id IS NOT NULL THEN 
            COALESCE(y.active_dates, array()) || array(t.today_date)
        ELSE 
            COALESCE(y.active_dates, array())
    END AS active_dates,
    COALESCE(t.today_date, date_add(y.date, 1)) AS date
FROM yesterday y
FULL OUTER JOIN today t
  ON t.user_id = y.user_id AND t.browser_type = y.browser_type;