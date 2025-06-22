DROP TABLE IF EXISTS ACTORS;
DROP TYPE IF EXISTS film_struct;
DROP TYPE IF EXISTS quality_class_enum;

CREATE TYPE film_struct AS (
	film TEXT,
	votes INT,
	rating FLOAT,
	filmid TEXT	
);

CREATE TYPE quality_class_enum AS ENUM ('star', 'good', 'average', 'bad');


CREATE TABLE actors (
  actorid TEXT,
  current_year INT,
  films film_struct[],
  quality_class quality_class_enum,
  is_active BOOLEAN
);


SELECT * FROM ACTORS;


DROP TABLE actors_history_scd;


CREATE TABLE actors_history_scd (
  actorid TEXT NOT NULL,
  current_year INT,
  quality_class quality_class_enum,
  is_active BOOLEAN NOT NULL,
  start_year INT NOT NULL,
  end_year INT,
  is_current BOOLEAN NOT NULL
);
