-- Migration: 009_create_media_table.sql
-- Description: Create the media table for storing multimedia files

CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    work_id INTEGER REFERENCES works(id) ON DELETE CASCADE,
    type VARCHAR(20) CHECK (type IN ('image', 'video', 'audio')),
    url VARCHAR(500) NOT NULL,
    filename VARCHAR(200),
    file_size INTEGER,
    mime_type VARCHAR(100),
    alt_text VARCHAR(500), -- Para accesibilidad
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for efficient searches
CREATE INDEX idx_media_work_id ON media(work_id);
CREATE INDEX idx_media_type ON media(type);
CREATE INDEX idx_media_filename ON media(filename); 