DROP TABLE IF EXISTS user_devices_cumulated;
CREATE TABLE user_devices_cumulated (
  user_id NUMERIC,
  browser_type TEXT,
  active_dates DATE[], --Array of dates when the user was active with this browser type
  date DATE, -- Date of the record
  PRIMARY KEY (user_id, browser_type, date)
);