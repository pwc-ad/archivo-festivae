-- Migration: 002_create_groups_table.sql
-- Description: Create the groups table for artist collaborations

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for group name searches
CREATE INDEX idx_groups_name ON groups(name);

-- Create trigger to automatically update updated_at timestamp
CREATE TRIGGER update_groups_updated_at 
    BEFORE UPDATE ON groups 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 