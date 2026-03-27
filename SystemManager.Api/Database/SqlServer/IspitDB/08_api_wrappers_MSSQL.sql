-- ============================================================
-- ZVANJE
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Zvanje_Create]
    @Naziv NVARCHAR(35)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Zvanje_Insert @Naziv = @Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Zvanje_Update]
    @IdZvanje   INT,
    @Naziv      NVARCHAR(35)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Zvanje_Update @IdZvanje = @IdZvanje, @Naziv = @Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Zvanje_Delete]
    @IdZvanje INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Zvanje_Delete @IdZvanje = @IdZvanje;
END;
GO

-- ============================================================
-- PREDMET
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Predmet_Create]
    @Naziv  NVARCHAR(35),
    @ESPB   TINYINT = 4
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Predmet_Insert @Naziv = @Naziv, @ESPB = @ESPB;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Predmet_Update]
    @IdPredmet  INT,
    @Naziv      NVARCHAR(35),
    @ESPB       TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Predmet_Update @IdPredmet = @IdPredmet, @Naziv = @Naziv, @ESPB = @ESPB;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Predmet_Delete]
    @IdPredmet INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Predmet_Delete @IdPredmet = @IdPredmet;
END;
GO

-- ============================================================
-- STUDENT
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Student_Create]
    @BrojIndeksa    VARCHAR(7),
    @Ime            NVARCHAR(22),
    @DatumRodjenja  DATE,
    @Semestar       VARCHAR(4)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Student_Insert
        @BrojIndeksa = @BrojIndeksa, @Ime = @Ime,
        @DatumRodjenja = @DatumRodjenja, @Semestar = @Semestar;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Student_Update]
    @BrojIndeksa    VARCHAR(7),
    @Ime            NVARCHAR(22),
    @DatumRodjenja  DATE,
    @Semestar       VARCHAR(4)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Student_Update
        @BrojIndeksa = @BrojIndeksa, @Ime = @Ime,
        @DatumRodjenja = @DatumRodjenja, @Semestar = @Semestar;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Student_Delete]
    @BrojIndeksa VARCHAR(7)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Student_Delete @BrojIndeksa = @BrojIndeksa;
END;
GO

-- ============================================================
-- NASTAVNIK
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Nastavnik_Create]
    @Ime        NVARCHAR(22),
    @IdZvanje   INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Nastavnik_Insert @Ime = @Ime, @IdZvanje = @IdZvanje;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Nastavnik_Update]
    @IdNastavnik    INT,
    @Ime            NVARCHAR(22),
    @IdZvanje       INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Nastavnik_Update @IdNastavnik = @IdNastavnik, @Ime = @Ime, @IdZvanje = @IdZvanje;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Nastavnik_Delete]
    @IdNastavnik INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Nastavnik_Delete @IdNastavnik = @IdNastavnik;
END;
GO

-- ============================================================
-- ISPIT
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Ispit_Create]
    @Ocena          TINYINT,
    @DatumPolaganja DATE,
    @BrojIndeksa    VARCHAR(7),
    @IdPredmet      INT,
    @IdNastavnik    INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ispit_Insert
        @Ocena = @Ocena, @DatumPolaganja = @DatumPolaganja,
        @BrojIndeksa = @BrojIndeksa, @IdPredmet = @IdPredmet, @IdNastavnik = @IdNastavnik;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Ispit_Update]
    @IdIspit        INT,
    @Ocena          TINYINT,
    @DatumPolaganja DATE,
    @BrojIndeksa    VARCHAR(7),
    @IdPredmet      INT,
    @IdNastavnik    INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ispit_Update
        @IdIspit = @IdIspit, @Ocena = @Ocena, @DatumPolaganja = @DatumPolaganja,
        @BrojIndeksa = @BrojIndeksa, @IdPredmet = @IdPredmet, @IdNastavnik = @IdNastavnik;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Ispit_Delete]
    @IdIspit INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ispit_Delete @IdIspit = @IdIspit;
END;
GO
