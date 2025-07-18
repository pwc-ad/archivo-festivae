-- Migration: 011_insert_sample_data.sql
-- Description: Insert sample data for testing and demonstration

-- Insert sample artists
INSERT INTO artists (name, last_name, display_name, bio, gender, is_student, university) VALUES
('María', 'González', 'MG_Art', 'Artista de artes electrónicas especializada en instalaciones interactivas', 'female', true, 'UNTREF'),
('Carlos', 'Rodríguez', 'CR_Digital', 'Desarrollador creativo con enfoque en realidad virtual', 'male', true, 'UNTREF'),
('Ana', 'Martínez', 'Ana_VR', 'Investigadora en interfaces hápticas y experiencias inmersivas', 'female', true, 'UNTREF'),
('Luis', 'Fernández', 'LF_Sound', 'Compositor de música electrónica y diseñador de sonido', 'male', false, NULL),
('Valentina', 'Silva', 'Val_Interactive', 'Artista multimedia con experiencia en performance digital', 'non_binary', true, 'UNTREF');

-- Insert sample groups
INSERT INTO groups (name, description) VALUES
('Colectivo Digital', 'Grupo de artistas experimentales enfocados en nuevas tecnologías'),
('SonidoLab', 'Colectivo especializado en arte sonoro y música experimental'),
('VR_Collective', 'Grupo de investigación en realidad virtual y aumentada');

-- Insert group members
INSERT INTO group_members (group_id, artist_id, role) VALUES
(1, 1, 'founder'),
(1, 2, 'member'),
(1, 3, 'member'),
(2, 4, 'founder'),
(2, 5, 'member'),
(3, 2, 'founder'),
(3, 3, 'member');

-- Insert sample works
INSERT INTO works (title, description, technical_description, genre, year, subject, tags, is_student_work, links) VALUES
('Sistema de Sonido Interactivo', 'Instalación que responde al movimiento del público generando composiciones únicas', 'Arduino + Processing + Sensores de movimiento + Altavoces', 'interactive_installation', 2024, 'Artes Electrónicas II', ARRAY['interactivo', 'sonido', 'movimiento'], true, '{"documentation": "https://docs.com/sistema-sonido", "github": "https://github.com/sistema-sonido"}'),
('Experiencia VR Inmersiva', 'Viaje virtual a través de paisajes sonoros generados por IA', 'Unity + Oculus Quest + Machine Learning', 'virtual_reality', 2024, 'Realidad Virtual', ARRAY['vr', 'ia', 'inmersivo'], true, '{"demo": "https://demo.com/vr-experience"}'),
('Performance Digital Híbrida', 'Combinación de danza contemporánea con proyecciones generativas', 'Kinect + TouchDesigner + Proyectores', 'performance', 2024, 'Performance Digital', ARRAY['performance', 'danza', 'proyecciones'], true, '{"video": "https://video.com/performance"}'),
('Sistema de Iluminación Responsiva', 'Instalación lumínica que responde a la actividad cerebral', 'EEG Headset + Arduino + LEDs RGB', 'interactive_installation', 2024, 'Interfaces Biológicas', ARRAY['neuro', 'luz', 'interactivo'], true, '{"research": "https://research.com/neuro-lights"}'),
('Composición Sonora Generativa', 'Música creada en tiempo real basada en datos ambientales', 'Max/MSP + Sensores + Sintetizadores', 'generative_music', 2024, 'Composición Digital', ARRAY['generativo', 'música', 'ambiental'], false, '{"soundcloud": "https://soundcloud.com/generative"}');

-- Insert work-artist relationships
INSERT INTO work_artists (work_id, artist_id, role) VALUES
(1, 1, 'creator'),
(1, 4, 'collaborator'),
(2, 2, 'creator'),
(2, 3, 'collaborator'),
(3, 5, 'creator'),
(4, 3, 'creator'),
(5, 4, 'creator');

-- Insert work-group relationships
INSERT INTO work_groups (work_id, group_id, role) VALUES
(1, 2, 'creator'),
(2, 3, 'creator'),
(3, 1, 'creator'),
(4, 1, 'creator'),
(5, 2, 'creator');

-- Insert sample festival editions
INSERT INTO festival_editions (name, edition, start_date, end_date, venue, theme, status) VALUES
('Festival de Artes Electrónicas 2024.1', '2024.1', '2024-06-01', '2024-06-03', 'UNTREF Centro Cultural', 'Tecnología y Sociedad', 'completed'),
('Festival de Artes Electrónicas 2024.2', '2024.2', '2024-11-15', '2024-11-17', 'UNTREF Centro Cultural', 'Futuros Posibles', 'planned');

-- Insert sample presentations
INSERT INTO presentations (work_id, festival_edition_id, presentation_date, time_slot, location, notes, attendance, feedback) VALUES
(1, 1, '2024-06-01', '14:00-16:00', 'Sala Principal', 'Presentación especial con Q&A', 150, '{"rating": 4.5, "comments": ["Excelente trabajo", "Muy innovador"]}'),
(2, 1, '2024-06-02', '16:00-18:00', 'Sala VR', 'Demostración individual de 15 min por persona', 80, '{"rating": 4.8, "comments": ["Experiencia única", "Tecnología increíble"]}'),
(3, 1, '2024-06-03', '19:00-21:00', 'Auditorio', 'Performance en vivo', 200, '{"rating": 4.2, "comments": ["Hermosa fusión", "Muy emotivo"]}'),
(4, 1, '2024-06-02', '10:00-12:00', 'Laboratorio', 'Sesión experimental', 60, '{"rating": 4.0, "comments": ["Interesante investigación", "Futurista"]}'),
(5, 1, '2024-06-01', '20:00-22:00', 'Sala de Conciertos', 'Concierto generativo', 120, '{"rating": 4.6, "comments": ["Música hipnótica", "Innovador"]}');

-- Insert sample media
INSERT INTO media (work_id, type, url, filename, mime_type, alt_text) VALUES
(1, 'image', 'https://example.com/images/sistema-sonido-1.jpg', 'sistema-sonido-1.jpg', 'image/jpeg', 'Instalación de sonido interactivo en funcionamiento'),
(1, 'video', 'https://example.com/videos/sistema-sonido-demo.mp4', 'sistema-sonido-demo.mp4', 'video/mp4', 'Demostración del sistema de sonido interactivo'),
(2, 'image', 'https://example.com/images/vr-experience.jpg', 'vr-experience.jpg', 'image/jpeg', 'Usuario experimentando la realidad virtual'),
(3, 'video', 'https://example.com/videos/performance-completa.mp4', 'performance-completa.mp4', 'video/mp4', 'Performance digital híbrida completa'),
(4, 'image', 'https://example.com/images/neuro-lights.jpg', 'neuro-lights.jpg', 'image/jpeg', 'Sistema de iluminación neuro-responsiva'),
(5, 'audio', 'https://example.com/audio/composicion-generativa.mp3', 'composicion-generativa.mp3', 'audio/mpeg', 'Composición sonora generativa completa'); 