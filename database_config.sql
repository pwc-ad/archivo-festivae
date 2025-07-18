-- Database Configuration for Festival Archive
-- This file contains the database creation and configuration

-- Create database (run this as superuser)
-- CREATE DATABASE festival_archive;

-- Connect to the database
-- \c festival_archive;

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For trigram matching
CREATE EXTENSION IF NOT EXISTS "btree_gin"; -- For GIN indexes on arrays

-- Set timezone
SET timezone = 'America/Argentina/Buenos_Aires';

-- Create schema if needed
-- CREATE SCHEMA IF NOT EXISTS festival;

-- Set search path
SET search_path TO public;

-- Database configuration
ALTER DATABASE festival_archive SET timezone TO 'America/Argentina/Buenos_Aires';
ALTER DATABASE festival_archive SET datestyle TO 'ISO, DMY';
ALTER DATABASE festival_archive SET lc_messages TO 'es_AR.UTF-8';
ALTER DATABASE festival_archive SET lc_monetary TO 'es_AR.UTF-8';
ALTER DATABASE festival_archive SET lc_numeric TO 'es_AR.UTF-8';
ALTER DATABASE festival_archive SET lc_time TO 'es_AR.UTF-8';

-- Performance tuning (adjust based on your server resources)
-- ALTER SYSTEM SET shared_buffers = '256MB';
-- ALTER SYSTEM SET effective_cache_size = '1GB';
-- ALTER SYSTEM SET maintenance_work_mem = '64MB';
-- ALTER SYSTEM SET checkpoint_completion_target = 0.9;
-- ALTER SYSTEM SET wal_buffers = '16MB';
-- ALTER SYSTEM SET default_statistics_target = 100;
-- ALTER SYSTEM SET random_page_cost = 1.1;
-- ALTER SYSTEM SET effective_io_concurrency = 200;

-- Reload configuration
-- SELECT pg_reload_conf(); 