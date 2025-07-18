-- Migration: 001_create_artists_table.sql
-- Description: Create the artists table with all necessary fields and constraints

CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    display_name VARCHAR(150) UNIQUE,
    bio TEXT,
    gender VARCHAR(20) CHECK (gender IN ('male', 'female', 'non_binary', 'other')),
    profile_photo_url VARCHAR(500),
    links JSONB DEFAULT '{}',
    is_student BOOLEAN DEFAULT false,
    university VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for display_name searches
CREATE INDEX idx_artists_display_name ON artists(display_name);

-- Create index for student filtering
CREATE INDEX idx_artists_is_student ON artists(is_student);

-- Create index for JSONB links field
CREATE INDEX idx_artists_links ON artists USING gin(links);

-- Create trigger to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_artists_updated_at 
    BEFORE UPDATE ON artists 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 