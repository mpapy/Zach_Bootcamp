WITH streak_started AS (
    SELECT 
        actorid,
        quality_class,
        current_year,
        CASE 
            WHEN lag(quality_class, 1) OVER (PARTITION BY actorid ORDER BY current_year) != quality_class
                OR lag(quality_class, 1) OVER (PARTITION BY actorid ORDER BY current_year) IS NULL
            THEN true
            ELSE false
        END AS did_change
    FROM actors
),
streak_identified AS (
    SELECT
        actorid,
        quality_class,
        current_year,
        sum(CASE WHEN did_change THEN 1 ELSE 0 END) 
            OVER (PARTITION BY actorid ORDER BY current_year) as streak_identifier
    FROM streak_started
),
aggregated AS (
    SELECT
        actorid,
        quality_class,
        streak_identifier,
        min(current_year) AS start_date,
        max(current_year) AS end_date
    FROM streak_identified
    GROUP BY actorid, quality_class, streak_identifier
)

SELECT 
    actorid, 
    quality_class, 
    start_date, 
    end_date
FROM aggregated
ORDER BY actorid, start_date;
