-- Migration: 003_create_group_members_table.sql
-- Description: Create the group_members junction table for many-to-many relationship

CREATE TABLE group_members (
    id SERIAL PRIMARY KEY,
    group_id INTEGER REFERENCES groups(id) ON DELETE CASCADE,
    artist_id INTEGER REFERENCES artists(id) ON DELETE CASCADE,
    role VARCHAR(100), -- 'founder', 'member', 'collaborator'
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(group_id, artist_id)
);

-- Create indexes for efficient joins
CREATE INDEX idx_group_members_group_id ON group_members(group_id);
CREATE INDEX idx_group_members_artist_id ON group_members(artist_id);
CREATE INDEX idx_group_members_role ON group_members(role); 