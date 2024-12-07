SELECT 
    room_name as "Room",
    MAX(CASE WHEN character_number = 1 THEN character_name END) as "Character 1",
    MAX(CASE WHEN character_number = 1 THEN character_prompt END) as "Character 1 Prompt",
    MAX(CASE WHEN character_number = 2 THEN character_name END) as "Character 2",
    MAX(CASE WHEN character_number = 2 THEN character_prompt END) as "Character 2 Prompt"
FROM (
    SELECT 
        r.name as room_name,
        array_position(r.character_ids, c.id) as character_number,
        c.name as character_name,
        c.prompt as character_prompt
    FROM rooms r
    CROSS JOIN UNNEST(r.character_ids) as char_id
    JOIN characters c ON char_id = c.id
) room_details
GROUP BY room_name
ORDER BY room_name;