-- ============================================================
-- ERROR_LOG
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
-- ZVANJE_AUDIT
-- ============================================================
CREATE TABLE [impl].[Zvanje_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,   -- 'INS','UPD','DEL'
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    IdZvanje    INT                 NOT NULL,
    Naziv       NVARCHAR(35)        NULL,

    CONSTRAINT PK_Zvanje_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- PREDMET_AUDIT
-- ============================================================
CREATE TABLE [impl].[Predmet_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    IdPredmet   INT                 NOT NULL,
    Naziv       NVARCHAR(35)        NULL,
    ESPB        TINYINT             NULL,

    CONSTRAINT PK_Predmet_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- STUDENT_AUDIT
-- ============================================================
CREATE TABLE [impl].[Student_Audit]
(
    AuditId         INT IDENTITY(1,1)   NOT NULL,
    ActionType      CHAR(3)             NOT NULL,
    ChangedAt       DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy       NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns (bez Starost — computed kolona)
    BrojIndeksa     VARCHAR(7)          NOT NULL,
    Ime             NVARCHAR(22)        NULL,
    DatumRodjenja   DATE                NULL,
    Semestar        VARCHAR(4)          NULL,
    ProsecnaOcena   DECIMAL(4,2)        NULL,

    CONSTRAINT PK_Student_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- NASTAVNIK_AUDIT
-- ============================================================
CREATE TABLE [impl].[Nastavnik_Audit]
(
    AuditId     INT IDENTITY(1,1)   NOT NULL,
    ActionType  CHAR(3)             NOT NULL,
    ChangedAt   DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy   NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    IdNastavnik INT                 NOT NULL,
    Ime         NVARCHAR(22)        NULL,
    IdZvanje    INT                 NULL,

    CONSTRAINT PK_Nastavnik_Audit PRIMARY KEY (AuditId)
);
GO

-- ============================================================
-- ISPIT_AUDIT
-- ============================================================
CREATE TABLE [impl].[Ispit_Audit]
(
    AuditId         INT IDENTITY(1,1)   NOT NULL,
    ActionType      CHAR(3)             NOT NULL,
    ChangedAt       DATETIME2           NOT NULL    DEFAULT (SYSUTCDATETIME()),
    ChangedBy       NVARCHAR(128)       NOT NULL    DEFAULT (SUSER_SNAME()),

    -- Mirror columns
    IdIspit         INT                 NOT NULL,
    Ocena           TINYINT             NULL,
    DatumPolaganja  DATE                NULL,
    BrojIndeksa     VARCHAR(7)          NULL,
    IdPredmet       INT                 NULL,
    IdNastavnik     INT                 NULL,

    CONSTRAINT PK_Ispit_Audit PRIMARY KEY (AuditId)
);
GO
