-- Migration: 010_create_views.sql
-- Description: Create useful views for common queries and reporting

-- Vista para obras con información completa de artistas y grupos
CREATE VIEW works_with_artists AS
SELECT 
    w.*,
    array_agg(DISTINCT a.display_name) FILTER (WHERE a.display_name IS NOT NULL) as artist_names,
    array_agg(DISTINCT g.name) FILTER (WHERE g.name IS NOT NULL) as group_names,
    array_agg(DISTINCT wa.role) FILTER (WHERE wa.role IS NOT NULL) as artist_roles,
    array_agg(DISTINCT wg.role) FILTER (WHERE wg.role IS NOT NULL) as group_roles
FROM works w
LEFT JOIN work_artists wa ON w.id = wa.work_id
LEFT JOIN artists a ON wa.artist_id = a.id
LEFT JOIN work_groups wg ON w.id = wg.work_id
LEFT JOIN groups g ON wg.group_id = g.id
GROUP BY w.id, w.title, w.description, w.technical_description, w.genre, w.year, w.subject, w.tags, w.is_student_work, w.links, w.created_at, w.updated_at;

-- Vista para estadísticas por edición del festival
CREATE VIEW edition_stats AS
SELECT 
    fe.id,
    fe.name,
    fe.edition,
    fe.start_date,
    fe.end_date,
    fe.status,
    COUNT(p.id) as total_presentations,
    SUM(p.attendance) as total_attendance,
    COUNT(DISTINCT wa.artist_id) as unique_artists,
    COUNT(DISTINCT w.id) as unique_works,
    AVG(p.attendance) as avg_attendance
FROM festival_editions fe
LEFT JOIN presentations p ON fe.id = p.festival_edition_id
LEFT JOIN work_artists wa ON p.work_id = wa.work_id
LEFT JOIN works w ON p.work_id = w.id
GROUP BY fe.id, fe.name, fe.edition, fe.start_date, fe.end_date, fe.status;

-- Vista para presentaciones con información completa
CREATE VIEW presentations_with_details AS
SELECT 
    p.*,
    w.title as work_title,
    w.genre as work_genre,
    w.is_student_work,
    fe.name as festival_name,
    fe.edition as festival_edition,
    fe.venue as festival_venue,
    array_agg(DISTINCT a.display_name) FILTER (WHERE a.display_name IS NOT NULL) as artist_names,
    array_agg(DISTINCT g.name) FILTER (WHERE g.name IS NOT NULL) as group_names
FROM presentations p
JOIN works w ON p.work_id = w.id
JOIN festival_editions fe ON p.festival_edition_id = fe.id
LEFT JOIN work_artists wa ON w.id = wa.work_id
LEFT JOIN artists a ON wa.artist_id = a.id
LEFT JOIN work_groups wg ON w.id = wg.work_id
LEFT JOIN groups g ON wg.group_id = g.id
GROUP BY p.id, p.work_id, p.festival_edition_id, p.presentation_date, p.time_slot, p.location, p.notes, p.attendance, p.feedback, p.created_at, p.updated_at, w.title, w.genre, w.is_student_work, fe.name, fe.edition, fe.venue;

-- Vista para artistas con estadísticas
CREATE VIEW artists_with_stats AS
SELECT 
    a.*,
    COUNT(DISTINCT wa.work_id) as total_works,
    COUNT(DISTINCT gm.group_id) as total_groups,
    COUNT(DISTINCT p.festival_edition_id) as total_festival_editions,
    SUM(p.attendance) as total_attendance
FROM artists a
LEFT JOIN work_artists wa ON a.id = wa.artist_id
LEFT JOIN group_members gm ON a.id = gm.artist_id
LEFT JOIN presentations p ON wa.work_id = p.work_id
GROUP BY a.id, a.name, a.last_name, a.display_name, a.bio, a.gender, a.profile_photo_url, a.links, a.is_student, a.university, a.created_at, a.updated_at; 