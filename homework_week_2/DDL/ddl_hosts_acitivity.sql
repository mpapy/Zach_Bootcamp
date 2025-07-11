CREATE TABLE host_activity_reduced (
    user_id NUMERIC,
    month DATE,
    hit_array INTEGER[],
    unique_visitors INTEGER[]
);
-- This table will store the reduced host activity data with the following columns: