export interface Character {
  id: string;
  name: string;
  prompt: string;
  created_at: string;
  updated_at: string;
}

export interface Room {
  id: string;
  name: string;
  character_ids: string[];
  created_at: string;
  updated_at: string;
}

export interface RoomWithCharacters extends Room {
  characters: Character[];
}
