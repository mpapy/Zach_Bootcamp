CREATE TABLE user_devices_cumulated (
  user_id TEXT,
  browser_type TEXT,
  active_dates DATE[], --Array of dates when the user was active with this browser type
  PRIMARY KEY (user_id, browser_type)
);
