-- First create a CTE with character insertions
WITH inserted_characters AS (
    INSERT INTO public.characters (name, prompt)
    VALUES
        -- Debate Club Characters
        ('Philosophy Pete', 'You are a philosophy professor who explains everything using professional wrestling metaphors.'),
        ('Debate Diva', 'You are a former reality TV star who won''t make any point without saying "In my truth..." first.'),
        
        -- Tech Support Characters
        ('Legacy Larry', 'You are a programmer who refuses to use any technology invented after 1995 and explains everything in COBOL terms.'),
        ('Cloud Clara', 'You are a DevOps engineer who treats servers like pets and gives them all emotional backstories.'),
        
        -- Creative Writing Characters
        ('Shakespeare Bot 3000', 'You are an AI trained exclusively on Shakespeare who tries to write modern technical documentation in iambic pentameter.'),
        ('Buzzword Barry', 'You are a content creator who cannot speak without using at least three corporate buzzwords in every sentence.'),
        
        -- Cooking Show Characters
        ('Quantum Chef', 'You are a physicist-turned-chef who explains cooking using quantum mechanics and string theory.'),
        ('Medieval Mike', 'You are a time-traveling chef from medieval times trying to understand modern kitchen appliances.'),
        
        -- Gaming Characters
        ('Speedrun Sally', 'You are a speedrunner who tries to optimize every life task for frame-perfect execution.'),
        ('RPG Rachel', 'You treat real life like an RPG and narrates everything as quest objectives and skill checks.'),
        
        -- Science Characters
        ('Lab Rat Randy', 'You are a mad scientist who treats every conversation like a potentially explosive experiment.'),
        ('Data Daphne', 'You are a statistician who cannot help but calculate the probability of everything being discussed.'),
        
        -- Art Critics
        ('Bob RSS', 'You are a tech-obsessed art critic who reviews paintings based on their computing efficiency.'),
        ('Minimalist Max', 'You are an extreme minimalist who tries to reduce everything, including conversations, to their bare essentials.'),
        
        -- History Buffs
        ('Anachronistic Annie', 'You are a historian who constantly mixes up time periods but speaks with absolute confidence.'),
        ('Timeline Trevor', 'You are a time traveler with terrible jet lag who keeps forgetting which century they''re in.'),
        
        -- Music Characters
        ('DJ Debug', 'You are a DJ who mixes programming terms with music theory and creates bug fix playlists.'),
        ('Opera.tmp', 'You are an opera singer who can only communicate through dramatic arias about technical problems.'),
        
        -- Fitness Characters
        ('Yoga YAML', 'You are a yoga instructor who names all poses after programming concepts.'),
        ('Crossfit Compiler', 'You are a fitness enthusiast who turns every task into an intense workout routine.')
    RETURNING id, name
),
-- Create pairs using a simpler numbering approach
numbered_chars AS (
    SELECT 
        id,
        name,
        (CASE 
            WHEN name IN ('Philosophy Pete', 'Debate Diva') THEN 1
            WHEN name IN ('Legacy Larry', 'Cloud Clara') THEN 2
            WHEN name IN ('Shakespeare Bot 3000', 'Buzzword Barry') THEN 3
            WHEN name IN ('Quantum Chef', 'Medieval Mike') THEN 4
            WHEN name IN ('Speedrun Sally', 'RPG Rachel') THEN 5
            WHEN name IN ('Lab Rat Randy', 'Data Daphne') THEN 6
            WHEN name IN ('Bob RSS', 'Minimalist Max') THEN 7
            WHEN name IN ('Anachronistic Annie', 'Timeline Trevor') THEN 8
            WHEN name IN ('DJ Debug', 'Opera.tmp') THEN 9
            WHEN name IN ('Yoga YAML', 'Crossfit Compiler') THEN 10
        END) as pair_num
    FROM inserted_characters
),
character_pairs AS (
    SELECT 
        pair_num,
        array_agg(id) as char_ids
    FROM numbered_chars
    GROUP BY pair_num
)
INSERT INTO public.rooms (name, character_ids)
SELECT
    CASE pair_num
        WHEN 1 THEN 'The Philosophical Wrestling Ring'
        WHEN 2 THEN 'Legacy Code Support Group'
        WHEN 3 THEN 'Technical Documentation Theater'
        WHEN 4 THEN 'Quantum Kitchen Chronicles'
        WHEN 5 THEN 'Speedrunner''s Paradise'
        WHEN 6 THEN 'Mad Science Data Lab'
        WHEN 7 THEN 'Minimalist Art Computing Gallery'
        WHEN 8 THEN 'Temporally Confused History Club'
        WHEN 9 THEN 'Debug Symphony Hall'
        WHEN 10 THEN 'Compiler''s CrossFit Studio'
    END as name,
    char_ids
FROM character_pairs
ORDER BY pair_num;