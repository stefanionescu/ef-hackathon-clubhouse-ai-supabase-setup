import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { Character, Room, RoomWithCharacters } from './types';

dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Missing Supabase credentials in .env file');
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function getAllData() {
  try {
    // Fetch all rooms
    const { data: rooms, error: roomsError } = await supabase
      .from('rooms')
      .select('*');

    if (roomsError) throw roomsError;
    if (!rooms) throw new Error('No rooms found');

    // Fetch all characters
    const { data: characters, error: charactersError } = await supabase
      .from('characters')
      .select('*');

    if (charactersError) throw charactersError;
    if (!characters) throw new Error('No characters found');

    // Map characters to their rooms
    const roomsWithCharacters: RoomWithCharacters[] = rooms.map((room: Room) => ({
      ...room,
      characters: room.character_ids
        .map(id => characters.find((char: Character) => char.id === id))
        .filter((char): char is Character => char !== undefined)
    }));

    // Print the results
    console.log('\n=== Rooms and Characters ===\n');
    roomsWithCharacters.forEach((room) => {
      console.log(`Room: ${room.name}`);
      room.characters.forEach((char, index) => {
        console.log(`\nCharacter ${index + 1}: ${char.name}`);
        console.log(`Prompt: ${char.prompt}`);
      });
      console.log('\n-------------------\n');
    });

  } catch (error) {
    console.error('Error fetching data:', error);
  }
}

// Run the query
getAllData();