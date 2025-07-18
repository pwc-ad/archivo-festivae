-- Migration: 004_create_works_table.sql
-- Description: Create the works table for storing artwork information

CREATE TABLE works (
    id SERIAL PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    technical_description TEXT,
    genre VARCHAR(100),
    year INTEGER,
    subject VARCHAR(200), -- Materia/asignatura
    tags TEXT[] DEFAULT '{}', -- Array de PostgreSQL para etiquetas
    is_student_work BOOLEAN DEFAULT false,
    links JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for efficient searches
CREATE INDEX idx_works_title ON works(title);
CREATE INDEX idx_works_genre ON works(genre);
CREATE INDEX idx_works_year ON works(year);
CREATE INDEX idx_works_subject ON works(subject);
CREATE INDEX idx_works_is_student ON works(is_student_work);
CREATE INDEX idx_works_tags ON works USING gin(tags);
CREATE INDEX idx_works_links ON works USING gin(links);

-- Create full-text search index
CREATE INDEX idx_works_title_description ON works USING gin(to_tsvector('spanish', title || ' ' || COALESCE(description, '')));

-- Create trigger to automatically update updated_at timestamp
CREATE TRIGGER update_works_updated_at 
    BEFORE UPDATE ON works 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 