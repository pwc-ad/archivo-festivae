-- Migration: 007_create_festival_editions_table.sql
-- Description: Create the festival_editions table for storing festival edition information

CREATE TABLE festival_editions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    edition VARCHAR(50) UNIQUE, -- '2024.1', '2024.2'
    start_date DATE,
    end_date DATE,
    venue VARCHAR(200),
    theme VARCHAR(200),
    status VARCHAR(20) DEFAULT 'planned' CHECK (status IN ('planned', 'active', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for efficient searches
CREATE INDEX idx_festival_editions_edition ON festival_editions(edition);
CREATE INDEX idx_festival_editions_status ON festival_editions(status);
CREATE INDEX idx_festival_editions_dates ON festival_editions(start_date, end_date);

-- Create trigger to automatically update updated_at timestamp
CREATE TRIGGER update_festival_editions_updated_at 
    BEFORE UPDATE ON festival_editions 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 