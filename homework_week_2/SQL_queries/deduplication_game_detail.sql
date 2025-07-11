DELETE FROM game_details
WHERE ctid NOT IN (
	SELECT MIN(ctid)
	FROM game_details
	GROUP BY game_id, team_id, player_id
); 
-- This query removes duplicate entries in the game_details table based on game_id, team_id, and player_id.
-- It keeps the first occurrence of each unique combination and deletes the rest.