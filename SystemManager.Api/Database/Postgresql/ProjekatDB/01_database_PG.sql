-- ============================================================
-- KREIRANJE BAZE PODATAKA
-- ============================================================

-- CREATE DATABASE "ProjekatDB"
--     WITH ENCODING = 'UTF8'
--     LC_COLLATE = 'sr_RS.UTF-8'
--     LC_CTYPE = 'sr_RS.UTF-8';

-- \c ProjekatDB

-- ============================================================
-- ADMINISTRATOR BAZE PODATAKA
-- ============================================================

-- CREATE ROLE db_admin WITH LOGIN PASSWORD 'admin123!';
-- GRANT ALL PRIVILEGES ON DATABASE "ProjekatDB" TO db_admin;

-- ============================================================
-- KREIRANJE SHEMA — impl → spec → api
-- ============================================================

CREATE SCHEMA IF NOT EXISTS impl;
CREATE SCHEMA IF NOT EXISTS spec;
CREATE SCHEMA IF NOT EXISTS api;

-- ============================================================
-- APLIKACIONA ULOGA — dataprovider
-- ============================================================

-- CREATE ROLE dataprovider NOLOGIN;

-- GRANT USAGE ON SCHEMA api TO dataprovider;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA api TO dataprovider;
-- GRANT SELECT ON ALL TABLES IN SCHEMA api TO dataprovider;

-- REVOKE ALL ON SCHEMA impl FROM dataprovider;
-- REVOKE ALL ON SCHEMA spec FROM dataprovider;

-- CREATE USER app_user WITH PASSWORD 'dataprovider123!';
-- GRANT dataprovider TO app_user;
