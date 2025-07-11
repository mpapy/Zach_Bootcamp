CREATE TABLE user_browser_datelist_int (
    user_id BIGINT,
    browser_type TEXT,
    datelist_int BIT(32),
    date DATE,
    PRIMARY KEY (user_id, browser_type, date)
)