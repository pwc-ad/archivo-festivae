-- Migration: 005_create_work_artists_table.sql
-- Description: Create the work_artists junction table for many-to-many relationship

CREATE TABLE work_artists (
    id SERIAL PRIMARY KEY,
    work_id INTEGER REFERENCES works(id) ON DELETE CASCADE,
    artist_id INTEGER REFERENCES artists(id) ON DELETE CASCADE,
    role VARCHAR(100), -- 'creator', 'collaborator', 'performer'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(work_id, artist_id)
);

-- Create indexes for efficient joins
CREATE INDEX idx_work_artists_work_id ON work_artists(work_id);
CREATE INDEX idx_work_artists_artist_id ON work_artists(artist_id);
CREATE INDEX idx_work_artists_role ON work_artists(role); 