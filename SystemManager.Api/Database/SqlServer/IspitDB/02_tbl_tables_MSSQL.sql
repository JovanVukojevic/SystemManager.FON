-- ============================================================
-- ZVANJE
-- ============================================================
CREATE TABLE [impl].[Zvanje]
(
    IdZvanje    INT IDENTITY(1,1)   NOT NULL,
    Naziv       NVARCHAR(35)        NOT NULL,

    CONSTRAINT PK_Zvanje        PRIMARY KEY (IdZvanje),
    CONSTRAINT UQ_Zvanje_Naziv  UNIQUE (Naziv),
    CONSTRAINT CHK_Zvanje_Naziv CHECK (Naziv IN ('Docent', 'Vanr. prof.', 'Red. prof.'))
);
GO

-- ============================================================
-- PREDMET
-- ============================================================
CREATE TABLE [impl].[Predmet]
(
    IdPredmet   INT IDENTITY(1,1)   NOT NULL,
    Naziv       NVARCHAR(35)        NOT NULL,
    ESPB        TINYINT             NULL        CONSTRAINT DF_Predmet_ESPB DEFAULT (4),

    CONSTRAINT PK_Predmet        PRIMARY KEY (IdPredmet),
    CONSTRAINT CHK_Predmet_ESPB  CHECK (ESPB > 2),
    CONSTRAINT CHK_Predmet_Naziv CHECK (Naziv LIKE '[A-Ž]%')
);
GO

-- ============================================================
-- STUDENT
-- ============================================================
CREATE TABLE [impl].[Student]
(
    BrojIndeksa     VARCHAR(7)      NOT NULL,
    Ime             NVARCHAR(22)    NOT NULL,
    DatumRodjenja   DATE            NOT NULL,
    Semestar        VARCHAR(4)      NULL        CONSTRAINT DF_Student_Semestar     DEFAULT ('I'),
    Starost         AS (DATEDIFF(YEAR, DatumRodjenja, GETDATE())),
    ProsecnaOcena   DECIMAL(4,2)    NULL        CONSTRAINT DF_Student_ProsecnaOcena DEFAULT (0),

    CONSTRAINT PK_Student                PRIMARY KEY (BrojIndeksa),
    CONSTRAINT CHK_Student_FormatIndeksa CHECK (BrojIndeksa LIKE '[0-9][0-9]/[0-9][0-9][0-9][0-9]'),
    CONSTRAINT CHK_Student_Ime           CHECK (Ime LIKE '[A-Ž]%'),
    CONSTRAINT CHK_Student_Semestar      CHECK (Semestar IN ('I','II','III','IV','V','VI','VII','VIII'))
);
GO

-- ============================================================
-- NASTAVNIK
-- ============================================================
CREATE TABLE [impl].[Nastavnik]
(
    IdNastavnik INT IDENTITY(1,1)   NOT NULL,
    Ime         NVARCHAR(22)        NOT NULL,
    IdZvanje    INT                 NOT NULL,

    CONSTRAINT PK_Nastavnik        PRIMARY KEY (IdNastavnik),
    CONSTRAINT FK_Nastavnik_Zvanje FOREIGN KEY (IdZvanje) REFERENCES impl.Zvanje (IdZvanje),
    CONSTRAINT CHK_Nastavnik_Ime   CHECK (Ime LIKE '[A-Ž]%')
);
GO

-- ============================================================
-- ISPIT
-- ============================================================
CREATE TABLE [impl].[Ispit]
(
    IdIspit         INT IDENTITY(1,1)   NOT NULL,
    Ocena           TINYINT             NOT NULL,
    DatumPolaganja  DATE                NOT NULL    CONSTRAINT DF_Ispit_DatumPolaganja DEFAULT (GETDATE()),
    BrojIndeksa     VARCHAR(7)          NOT NULL,
    IdPredmet       INT                 NOT NULL,
    IdNastavnik     INT                 NOT NULL,

    CONSTRAINT PK_Ispit                 PRIMARY KEY (IdIspit),
    CONSTRAINT UQ_Student_Predmet       UNIQUE (BrojIndeksa, IdPredmet),
    CONSTRAINT FK_Ispit_Student         FOREIGN KEY (BrojIndeksa) REFERENCES impl.Student (BrojIndeksa),
    CONSTRAINT FK_Ispit_Predmet         FOREIGN KEY (IdPredmet)   REFERENCES impl.Predmet (IdPredmet),
    CONSTRAINT FK_Ispit_Nastavnik       FOREIGN KEY (IdNastavnik) REFERENCES impl.Nastavnik (IdNastavnik),
    CONSTRAINT CHK_Ispit_Ocena          CHECK (Ocena >= 6 AND Ocena <= 10),
    CONSTRAINT CHK_Ispit_DatumPolaganja CHECK (DatumPolaganja <= GETDATE())
);
GO
