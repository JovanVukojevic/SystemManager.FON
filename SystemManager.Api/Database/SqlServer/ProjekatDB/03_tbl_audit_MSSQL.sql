-- ============================================================
-- ERROR_LOG (jedna za celu bazu)
-- ============================================================
CREATE TABLE [impl].[Error_Log]
(
    LogId           INT IDENTITY(1,1)   NOT NULL,
    ErrorNumber     INT                 NULL,
    ErrorMessage    NVARCHAR(4000)      NULL,
    ProcedureName   NVARCHAR(128)       NULL,
    LogDate         DATETIME2           NOT NULL    CONSTRAINT DF_ErrorLog_LogDate DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_Error_Log PRIMARY KEY (LogId)
);
GO

-- ============================================================
-- RADNOMESTO_AUDIT
-- ============================================================
CREATE TABLE [impl].[RadnoMesto_Audit]
(
    AuditId         INT IDENTITY(1,1)   NOT NULL,
    ActionType      CHAR(3)             NOT NULL,   -- 'INS','UPD','DEL'
    ChangedAt       DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy       NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    RadnoMestoId    BIGINT              NOT NULL,
    Naziv           NVARCHAR(22)        NULL,

    CONSTRAINT PK_RadnoMesto_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- SLUZBA_AUDIT
-- ============================================================
CREATE TABLE [impl].[Sluzba_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    SluzbaId    BIGINT              NOT NULL,
    Naziv       NVARCHAR(22)        NULL,

    CONSTRAINT PK_Sluzba_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- PROJEKAT_AUDIT (bez Klasa — computed kolona)
-- ============================================================
CREATE TABLE [impl].[Projekat_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    ProjekatId  BIGINT              NOT NULL,
    Naziv       NVARCHAR(50)        NULL,
    Budzet      MONEY               NULL,

    CONSTRAINT PK_Projekat_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- RADNIK_AUDIT
-- ============================================================
CREATE TABLE [impl].[Radnik_Audit]
(
    AuditId         INT IDENTITY(1,1)   NOT NULL,
    ActionType      CHAR(3)             NOT NULL,
    ChangedAt       DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy       NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    RadnikId        BIGINT              NOT NULL,
    Ime             NVARCHAR(22)        NULL,
    SluzbaId        BIGINT              NULL,
    RadnoMestoId    BIGINT              NULL,

    CONSTRAINT PK_Radnik_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- ISPLATA_AUDIT (composite identifier: RadnikId + IsplataId)
-- ============================================================
CREATE TABLE [impl].[Isplata_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    RadnikId    BIGINT              NOT NULL,
    IsplataId   BIGINT              NOT NULL,
    Datum       DATE                NULL,
    Iznos       MONEY               NULL,
    Vrsta       NVARCHAR(11)        NULL,

    CONSTRAINT PK_Isplata_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- UCESTVUJE_AUDIT
-- ============================================================
CREATE TABLE [impl].[Ucestvuje_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    UcestvujeId BIGINT              NOT NULL,
    DatumOd     DATE                NULL,
    DatumDo     DATE                NULL,
    RadnikId    BIGINT              NULL,
    ProjekatId  BIGINT              NULL,

    CONSTRAINT PK_Ucestvuje_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- RUKOVODI_AUDIT
-- ============================================================
CREATE TABLE [impl].[Rukovodi_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    RukovodiId  BIGINT              NOT NULL,
    RadnikId    BIGINT              NULL,
    ProjekatId  BIGINT              NULL,

    CONSTRAINT PK_Rukovodi_Audit PRIMARY KEY (AuditId)
);
GO
