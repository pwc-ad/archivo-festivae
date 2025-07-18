-- Sample Queries for Festival Archive Database
-- These queries demonstrate the main functionality of the database

-- 1. Basic queries to explore the data
-- =====================================

-- Get all artists
SELECT id, name, last_name, display_name, is_student, university 
FROM artists 
ORDER BY name, last_name;

-- Get all works with basic info
SELECT id, title, genre, year, is_student_work 
FROM works 
ORDER BY year DESC, title;

-- Get all festival editions
SELECT id, name, edition, start_date, end_date, status 
FROM festival_editions 
ORDER BY start_date DESC;

-- 2. Artist-related queries
-- =========================

-- Find all student artists
SELECT name, last_name, display_name, university 
FROM artists 
WHERE is_student = true 
ORDER BY university, name;

-- Get artists with their work count
SELECT 
    a.name, 
    a.last_name, 
    a.display_name,
    COUNT(wa.work_id) as work_count
FROM artists a
LEFT JOIN work_artists wa ON a.id = wa.artist_id
GROUP BY a.id, a.name, a.last_name, a.display_name
ORDER BY work_count DESC, a.name;

-- Find artists who are in groups
SELECT 
    a.name, 
    a.last_name, 
    a.display_name,
    array_agg(g.name) as groups
FROM artists a
JOIN group_members gm ON a.id = gm.artist_id
JOIN groups g ON gm.group_id = g.id
GROUP BY a.id, a.name, a.last_name, a.display_name
ORDER BY a.name;

-- 3. Work-related queries
-- =======================

-- Search works by tag
SELECT title, description, tags 
FROM works 
WHERE 'interactivo' = ANY(tags) 
ORDER BY title;

-- Find works by genre
SELECT title, description, year, is_student_work 
FROM works 
WHERE genre = 'interactive_installation' 
ORDER BY year DESC;

-- Get works with their creators (using the view)
SELECT 
    title, 
    artist_names, 
    group_names, 
    genre, 
    year
FROM works_with_artists 
ORDER BY year DESC, title;

-- Full-text search in works
SELECT title, description 
FROM works 
WHERE to_tsvector('spanish', title || ' ' || COALESCE(description, '')) 
@@ plainto_tsquery('spanish', 'sonido interactivo')
ORDER BY ts_rank(to_tsvector('spanish', title || ' ' || COALESCE(description, '')), plainto_tsquery('spanish', 'sonido interactivo')) DESC;

-- 4. Festival edition queries
-- ===========================

-- Get statistics for each edition
SELECT 
    name, 
    edition, 
    total_presentations, 
    total_attendance, 
    unique_artists,
    unique_works,
    ROUND(avg_attendance, 2) as avg_attendance
FROM edition_stats 
ORDER BY start_date DESC;

-- Find presentations for a specific edition
SELECT 
    w.title,
    p.presentation_date,
    p.time_slot,
    p.location,
    p.attendance,
    array_agg(a.display_name) as artists
FROM presentations p
JOIN works w ON p.work_id = w.id
JOIN work_artists wa ON w.id = wa.work_id
JOIN artists a ON wa.artist_id = a.id
WHERE p.festival_edition_id = 1
GROUP BY w.title, p.presentation_date, p.time_slot, p.location, p.attendance
ORDER BY p.presentation_date, p.time_slot;

-- 5. Group-related queries
-- ========================

-- Get groups with their members
SELECT 
    g.name as group_name,
    g.description,
    array_agg(a.display_name) as members,
    array_agg(gm.role) as roles
FROM groups g
JOIN group_members gm ON g.id = gm.group_id
JOIN artists a ON gm.artist_id = a.id
GROUP BY g.id, g.name, g.description
ORDER BY g.name;

-- Find works created by groups
SELECT 
    w.title,
    g.name as group_name,
    wg.role as group_role
FROM works w
JOIN work_groups wg ON w.id = wg.work_id
JOIN groups g ON wg.group_id = g.id
ORDER BY w.title;

-- 6. Media queries
-- ================

-- Get all media for a specific work
SELECT 
    w.title,
    m.type,
    m.filename,
    m.mime_type,
    m.alt_text
FROM media m
JOIN works w ON m.work_id = w.id
WHERE w.id = 1
ORDER BY m.type, m.filename;

-- Count media by type
SELECT 
    type,
    COUNT(*) as count
FROM media 
GROUP BY type 
ORDER BY count DESC;

-- 7. Advanced analytics queries
-- =============================

-- Most popular genres
SELECT 
    genre,
    COUNT(*) as work_count,
    AVG(attendance) as avg_attendance
FROM works w
LEFT JOIN presentations p ON w.id = p.work_id
WHERE genre IS NOT NULL
GROUP BY genre
ORDER BY work_count DESC;

-- Student vs non-student work comparison
SELECT 
    is_student_work,
    COUNT(*) as work_count,
    AVG(attendance) as avg_attendance,
    SUM(attendance) as total_attendance
FROM works w
LEFT JOIN presentations p ON w.id = p.work_id
GROUP BY is_student_work
ORDER BY is_student_work;

-- Artists with highest attendance
SELECT 
    a.name,
    a.last_name,
    a.display_name,
    COUNT(DISTINCT wa.work_id) as works_presented,
    SUM(p.attendance) as total_attendance,
    AVG(p.attendance) as avg_attendance
FROM artists a
JOIN work_artists wa ON a.id = wa.artist_id
JOIN presentations p ON wa.work_id = p.work_id
GROUP BY a.id, a.name, a.last_name, a.display_name
HAVING SUM(p.attendance) > 0
ORDER BY total_attendance DESC;

-- 8. Feedback analysis
-- ====================

-- Works with highest ratings
SELECT 
    w.title,
    p.feedback->>'rating' as rating,
    p.feedback->'comments' as comments,
    p.attendance
FROM presentations p
JOIN works w ON p.work_id = w.id
WHERE p.feedback->>'rating' IS NOT NULL
ORDER BY (p.feedback->>'rating')::numeric DESC;

-- 9. Time-based queries
-- =====================

-- Works by year
SELECT 
    year,
    COUNT(*) as work_count,
    COUNT(CASE WHEN is_student_work THEN 1 END) as student_works,
    COUNT(CASE WHEN NOT is_student_work THEN 1 END) as professional_works
FROM works 
WHERE year IS NOT NULL
GROUP BY year 
ORDER BY year DESC;

-- Presentations by month
SELECT 
    EXTRACT(MONTH FROM presentation_date) as month,
    EXTRACT(YEAR FROM presentation_date) as year,
    COUNT(*) as presentations,
    SUM(attendance) as total_attendance
FROM presentations 
WHERE presentation_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM presentation_date), EXTRACT(YEAR FROM presentation_date)
ORDER BY year DESC, month DESC; 