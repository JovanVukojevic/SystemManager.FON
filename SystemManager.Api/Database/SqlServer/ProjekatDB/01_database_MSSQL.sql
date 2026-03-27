-- ============================================================
-- KREIRANJE BAZE PODATAKA
-- ============================================================

-- CREATE DATABASE [ProjekatDB]
--     COLLATE Serbian_Latin_General_CI_AS;
-- GO
-- USE [ProjekatDB];
-- GO

-- ============================================================
-- ADMINISTRATOR BAZE PODATAKA
-- ============================================================

-- CREATE LOGIN DbAdmin WITH PASSWORD = 'admin123!';
-- GO
-- CREATE USER DbAdmin FOR LOGIN DbAdmin;
-- GO
-- ALTER ROLE db_owner ADD MEMBER DbAdmin;
-- GO

-- ============================================================
-- KREIRANJE SHEMA — impl → spec → api
-- ============================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'impl')
    EXEC('CREATE SCHEMA [impl]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'spec')
    EXEC('CREATE SCHEMA [spec]');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'api')
    EXEC('CREATE SCHEMA [api]');
GO

-- ============================================================
-- APLIKACIONA ULOGA — DataProvider
-- ============================================================

-- CREATE APPLICATION ROLE DataProvider
--     WITH PASSWORD = 'dataprovider123!';
-- GO

-- GRANT EXECUTE ON SCHEMA::[api] TO DataProvider;
-- GRANT SELECT ON SCHEMA::[api] TO DataProvider;
-- GO

-- DENY SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::[impl] TO DataProvider;
-- GO

-- DENY SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::[spec] TO DataProvider;
-- GO
