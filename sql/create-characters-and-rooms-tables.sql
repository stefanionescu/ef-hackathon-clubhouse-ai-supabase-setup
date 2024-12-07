-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop tables if they exist (useful for clean setup)
DROP TABLE IF EXISTS public.rooms;
DROP TABLE IF EXISTS public.characters;

-- Create characters table
CREATE TABLE public.characters (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    prompt TEXT NOT NULL CHECK (length(trim(prompt)) > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create rooms table
CREATE TABLE public.rooms (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    character_ids UUID[] NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    CONSTRAINT character_ids_not_empty CHECK (array_length(character_ids, 1) > 0)
);

-- Create a function to validate character_ids against characters table
CREATE OR REPLACE FUNCTION verify_character_ids()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT (SELECT BOOL_AND(EXISTS (
        SELECT 1 FROM public.characters WHERE id = character_id
    ))
    FROM unnest(NEW.character_ids) AS character_id)
    THEN
        RAISE EXCEPTION 'All character_ids must reference existing characters';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to validate character_ids before insert or update
CREATE TRIGGER validate_character_ids
    BEFORE INSERT OR UPDATE ON public.rooms
    FOR EACH ROW
    EXECUTE FUNCTION verify_character_ids();

-- Create updated_at triggers for both tables
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_characters_updated_at
    BEFORE UPDATE ON public.characters
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rooms_updated_at
    BEFORE UPDATE ON public.rooms
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant access to public
ALTER TABLE public.characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;

-- Create policies for public access
CREATE POLICY "Enable read access for all users" ON public.characters
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "Enable insert access for all users" ON public.characters
    FOR INSERT
    TO public
    WITH CHECK (true);

CREATE POLICY "Enable update access for all users" ON public.characters
    FOR UPDATE
    TO public
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Enable delete access for all users" ON public.characters
    FOR DELETE
    TO public
    USING (true);

CREATE POLICY "Enable read access for all users" ON public.rooms
    FOR SELECT
    TO public
    USING (true);

CREATE POLICY "Enable insert access for all users" ON public.rooms
    FOR INSERT
    TO public
    WITH CHECK (true);

CREATE POLICY "Enable update access for all users" ON public.rooms
    FOR UPDATE
    TO public
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Enable delete access for all users" ON public.rooms
    FOR DELETE
    TO public
    USING (true);

-- Grant all privileges to public
GRANT ALL ON public.characters TO public;
GRANT ALL ON public.rooms TO public;

-- Create indexes
CREATE INDEX idx_characters_name ON public.characters(name);
CREATE INDEX idx_rooms_name ON public.rooms(name);
CREATE INDEX idx_rooms_character_ids ON public.rooms USING gin(character_ids);