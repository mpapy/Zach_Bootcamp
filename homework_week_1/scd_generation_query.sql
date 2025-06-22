WITH streak_started AS (
    SELECT actorid,
           quality_class,
           current_year,
           LAG(quality_class, 1) OVER
               (PARTITION BY actorid ORDER BY current_year) <> quality_class
               OR LAG(quality_class, 1) OVER
               (PARTITION BY actorid ORDER BY current_year) IS NULL
               AS did_change
    FROM actors
),
     streak_identified AS (
         SELECT
            actorid,
                quality_class,
                current_year,
            SUM(CASE WHEN did_change THEN 1 ELSE 0 END)
                OVER (PARTITION BY actorid ORDER BY current_year) as streak_identifier
         FROM streak_started
     ),
     aggregated AS (
         SELECT
            actorid,
            quality_class,
            streak_identifier,
            MIN(current_year) AS start_date,
            MAX(current_year) AS end_date
         FROM streak_identified
         GROUP BY 1,2,3
     )

     SELECT actorid, quality_class, start_date, end_date
     FROM aggregated;