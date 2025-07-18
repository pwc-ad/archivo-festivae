-- Migration: 008_create_presentations_table.sql
-- Description: Create the presentations table for storing presentation information

CREATE TABLE presentations (
    id SERIAL PRIMARY KEY,
    work_id INTEGER REFERENCES works(id) ON DELETE CASCADE,
    festival_edition_id INTEGER REFERENCES festival_editions(id) ON DELETE CASCADE,
    presentation_date DATE,
    time_slot VARCHAR(50), -- '14:00-16:00'
    location VARCHAR(200),
    notes TEXT,
    attendance INTEGER,
    feedback JSONB DEFAULT '{}', -- Para ratings y comentarios
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(work_id, festival_edition_id)
);

-- Create indexes for efficient searches
CREATE INDEX idx_presentations_work_id ON presentations(work_id);
CREATE INDEX idx_presentations_edition_id ON presentations(festival_edition_id);
CREATE INDEX idx_presentations_date ON presentations(presentation_date);
CREATE INDEX idx_presentations_edition_date ON presentations(festival_edition_id, presentation_date);
CREATE INDEX idx_presentations_feedback ON presentations USING gin(feedback);

-- Create trigger to automatically update updated_at timestamp
CREATE TRIGGER update_presentations_updated_at 
    BEFORE UPDATE ON presentations 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 