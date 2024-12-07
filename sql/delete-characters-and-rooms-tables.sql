-- Drop policies
DROP POLICY IF EXISTS "Enable read access for all users" ON public.characters;
DROP POLICY IF EXISTS "Enable insert access for all users" ON public.characters;
DROP POLICY IF EXISTS "Enable update access for all users" ON public.characters;
DROP POLICY IF EXISTS "Enable delete access for all users" ON public.characters;

DROP POLICY IF EXISTS "Enable read access for all users" ON public.rooms;
DROP POLICY IF EXISTS "Enable insert access for all users" ON public.rooms;
DROP POLICY IF EXISTS "Enable update access for all users" ON public.rooms;
DROP POLICY IF EXISTS "Enable delete access for all users" ON public.rooms;

-- Drop indexes
DROP INDEX IF EXISTS idx_characters_name;
DROP INDEX IF EXISTS idx_rooms_name;
DROP INDEX IF EXISTS idx_rooms_character_ids;

-- Remove triggers
DROP TRIGGER IF EXISTS validate_character_ids ON public.rooms;
DROP TRIGGER IF EXISTS update_characters_updated_at ON public.characters;
DROP TRIGGER IF EXISTS update_rooms_updated_at ON public.rooms;

-- Drop functions
DROP FUNCTION IF EXISTS verify_character_ids();
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop tables
DROP TABLE IF EXISTS public.rooms;
DROP TABLE IF EXISTS public.characters;