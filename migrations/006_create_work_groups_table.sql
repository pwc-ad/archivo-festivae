-- Migration: 006_create_work_groups_table.sql
-- Description: Create the work_groups junction table for many-to-many relationship

CREATE TABLE work_groups (
    id SERIAL PRIMARY KEY,
    work_id INTEGER REFERENCES works(id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES groups(id) ON DELETE CASCADE,
    role VARCHAR(100), -- 'creator', 'collaborator', 'performer'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(work_id, group_id)
);

-- Create indexes for efficient joins
CREATE INDEX idx_work_groups_work_id ON work_groups(work_id);
CREATE INDEX idx_work_groups_group_id ON work_groups(group_id);
CREATE INDEX idx_work_groups_role ON work_groups(role); 