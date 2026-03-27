-- ============================================================
-- RADNOMESTO
-- ============================================================
CREATE TABLE [impl].[RadnoMesto]
(
    RadnoMestoId    BIGINT IDENTITY(1,1)    NOT NULL,
    Naziv           NVARCHAR(22)            NOT NULL,

    CONSTRAINT PK_RadnoMesto        PRIMARY KEY (RadnoMestoId),
    CONSTRAINT UQ_RadnoMesto_Naziv  UNIQUE (Naziv),
    CONSTRAINT CHK_RadnoMesto_Naziv CHECK (Naziv LIKE ('[A-ZŠÐCCŽ]%') COLLATE Serbian_Latin_100_BIN2)
);
GO

-- ============================================================
-- SLUZBA
-- ============================================================
CREATE TABLE [impl].[Sluzba]
(
    SluzbaId    BIGINT IDENTITY(1,1)    NOT NULL,
    Naziv       NVARCHAR(22)            NOT NULL,

    CONSTRAINT PK_Sluzba        PRIMARY KEY (SluzbaId),
    CONSTRAINT UQ_Sluzba_Naziv  UNIQUE (Naziv)
);
GO

-- ============================================================
-- PROJEKAT
-- ============================================================
CREATE TABLE [impl].[Projekat]
(
    ProjekatId  BIGINT IDENTITY(1,1)    NOT NULL,
    Naziv       NVARCHAR(50)            NOT NULL,
    Budzet      MONEY                   NOT NULL,
    Klasa       AS (CASE WHEN Budzet <= 1000 THEN 3 WHEN Budzet <= 5000 THEN 2 ELSE 1 END),

    CONSTRAINT PK_Projekat          PRIMARY KEY (ProjekatId),
    CONSTRAINT UQ_Projekat_Naziv    UNIQUE (Naziv),
    CONSTRAINT CHK_Projekat_Naziv   CHECK (Naziv LIKE 'PR-%'),
    CONSTRAINT CHK_Projekat_Budzet  CHECK (Budzet > 0)
);
GO

-- ============================================================
-- RADNIK
-- ============================================================
CREATE TABLE [impl].[Radnik]
(
    RadnikId        BIGINT IDENTITY(100,2)  NOT NULL,
    Ime             NVARCHAR(22)            NOT NULL,
    SluzbaId        BIGINT                  NOT NULL,
    RadnoMestoId    BIGINT                  NOT NULL,

    CONSTRAINT PK_Radnik            PRIMARY KEY (RadnikId),
    CONSTRAINT FK_Radnik_RadnoMesto FOREIGN KEY (RadnoMestoId) REFERENCES impl.RadnoMesto (RadnoMestoId),
    CONSTRAINT FK_Radnik_Sluzba     FOREIGN KEY (SluzbaId)     REFERENCES impl.Sluzba (SluzbaId),
    CONSTRAINT CHK_Radnik_Ime       CHECK (Ime LIKE '[A-Ž]%')
);
GO

-- ============================================================
-- ISPLATA (weak entity — composite PK)
-- ============================================================
CREATE TABLE [impl].[Isplata]
(
    RadnikId    BIGINT          NOT NULL,
    IsplataId   BIGINT IDENTITY(1,1) NOT NULL,
    Datum       DATE            NOT NULL,
    Iznos       MONEY           NOT NULL,
    Vrsta       NVARCHAR(11)    NOT NULL,

    CONSTRAINT PK_Isplata           PRIMARY KEY (RadnikId, IsplataId),
    CONSTRAINT FK_Isplata_Radnik    FOREIGN KEY (RadnikId) REFERENCES impl.Radnik (RadnikId) ON DELETE CASCADE,
    CONSTRAINT CHK_Isplata_Iznos    CHECK (Iznos > 0),
    CONSTRAINT CHK_Isplata_Vrsta    CHECK (Vrsta IN ('REGRES', 'BONUS', 'PLATA'))
);
GO

-- ============================================================
-- UCESTVUJE (aggregation entity)
-- ============================================================
CREATE TABLE [impl].[Ucestvuje]
(
    UcestvujeId BIGINT IDENTITY(100,1)  NOT NULL,
    DatumOd     DATE                    NOT NULL,
    DatumDo     DATE                    NULL,
    RadnikId    BIGINT                  NOT NULL,
    ProjekatId  BIGINT                  NOT NULL,

    CONSTRAINT PK_Ucestvuje             PRIMARY KEY (UcestvujeId),
    CONSTRAINT FK_Ucestvuje_Radnik      FOREIGN KEY (RadnikId)   REFERENCES impl.Radnik (RadnikId),
    CONSTRAINT FK_Ucestvuje_Projekat    FOREIGN KEY (ProjekatId) REFERENCES impl.Projekat (ProjekatId),
    CONSTRAINT CHK_Ucestvuje_MinTrajanje CHECK (DatumDo IS NULL OR DATEDIFF(DAY, DatumOd, DatumDo) >= 15)
);
GO

-- ============================================================
-- RUKOVODI (aggregation entity)
-- ============================================================
CREATE TABLE [impl].[Rukovodi]
(
    RukovodiId  BIGINT IDENTITY(100,1)  NOT NULL,
    RadnikId    BIGINT                  NOT NULL,
    ProjekatId  BIGINT                  NOT NULL,

    CONSTRAINT PK_Rukovodi              PRIMARY KEY (RukovodiId),
    CONSTRAINT UQ_Rukovodi_Projekat    UNIQUE (ProjekatId),
    CONSTRAINT FK_Rukovodi_Radnik       FOREIGN KEY (RadnikId)   REFERENCES impl.Radnik (RadnikId),
    CONSTRAINT FK_Rukovodi_Projekat     FOREIGN KEY (ProjekatId) REFERENCES impl.Projekat (ProjekatId) ON DELETE CASCADE
);
GO
