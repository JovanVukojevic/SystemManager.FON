-- ============================================================
-- RADNOMESTO — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_RadnoMesto_CheckValueConstraints]
    @RadnoMestoId   BIGINT = NULL,    -- NULL za INSERT, postojeći ID za UPDATE
    @Naziv          NVARCHAR(22),
    @IsInsert       BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Naziv IS NULL OR LTRIM(RTRIM(@Naziv)) = ''
    BEGIN
        RAISERROR('Greška: Naziv radnog mesta ne sme biti prazan.', 16, 1);
        RETURN;
    END

    IF @Naziv NOT LIKE ('[A-ZŠÐCCŽ]%') COLLATE Serbian_Latin_100_BIN2
    BEGIN
        RAISERROR('Greška: Naziv radnog mesta mora počinjati velikim slovom.', 16, 1);
        RETURN;
    END

    -- Provera jedinstvenosti naziva
    IF @IsInsert = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.RadnoMesto WHERE Naziv = @Naziv)
        BEGIN
            RAISERROR('Greška: Radno mesto sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.RadnoMesto WHERE Naziv = @Naziv AND RadnoMestoId <> @RadnoMestoId)
        BEGIN
            RAISERROR('Greška: Drugo radno mesto sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
END;
GO

-- ============================================================
-- SLUZBA — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Sluzba_CheckValueConstraints]
    @SluzbaId   BIGINT = NULL,
    @Naziv      NVARCHAR(22),
    @IsInsert   BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Naziv IS NULL OR LTRIM(RTRIM(@Naziv)) = ''
    BEGIN
        RAISERROR('Greška: Naziv službe ne sme biti prazan.', 16, 1);
        RETURN;
    END

    -- Provera jedinstvenosti naziva
    IF @IsInsert = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Sluzba WHERE Naziv = @Naziv)
        BEGIN
            RAISERROR('Greška: Služba sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Sluzba WHERE Naziv = @Naziv AND SluzbaId <> @SluzbaId)
        BEGIN
            RAISERROR('Greška: Druga služba sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
END;
GO

-- ============================================================
-- PROJEKAT — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Projekat_CheckValueConstraints]
    @ProjekatId BIGINT = NULL,
    @Naziv      NVARCHAR(50),
    @Budzet     MONEY,
    @IsInsert   BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Naziv IS NULL OR LTRIM(RTRIM(@Naziv)) = ''
    BEGIN
        RAISERROR('Greška: Naziv projekta ne sme biti prazan.', 16, 1);
        RETURN;
    END

    IF @Naziv NOT LIKE 'PR-%'
    BEGIN
        RAISERROR('Greška: Naziv projekta mora počinjati sa PR- (npr. PR-MojProjekat).', 16, 1);
        RETURN;
    END

    IF @Budzet IS NULL OR @Budzet <= 0
    BEGIN
        RAISERROR('Greška: Budžet mora biti veći od 0.', 16, 1);
        RETURN;
    END

    -- Provera jedinstvenosti naziva
    IF @IsInsert = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Projekat WHERE Naziv = @Naziv)
        BEGIN
            RAISERROR('Greška: Projekat sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Projekat WHERE Naziv = @Naziv AND ProjekatId <> @ProjekatId)
        BEGIN
            RAISERROR('Greška: Drugi projekat sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
END;
GO

-- ============================================================
-- RADNIK — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Radnik_CheckValueConstraints]
    @Ime            NVARCHAR(22),
    @SluzbaId       BIGINT,
    @RadnoMestoId   BIGINT,
    @IsInsert       BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Ime IS NULL OR LTRIM(RTRIM(@Ime)) = ''
    BEGIN
        RAISERROR('Greška: Ime radnika ne sme biti prazno.', 16, 1);
        RETURN;
    END

    IF @Ime NOT LIKE '[A-Ž]%'
    BEGIN
        RAISERROR('Greška: Ime radnika mora počinjati velikim slovom.', 16, 1);
        RETURN;
    END

    IF @SluzbaId IS NULL
    BEGIN
        RAISERROR('Greška: Služba je obavezna.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.Sluzba WHERE SluzbaId = @SluzbaId)
    BEGIN
        RAISERROR('Greška: Služba sa datim ID-jem ne postoji.', 16, 1);
        RETURN;
    END

    IF @RadnoMestoId IS NULL
    BEGIN
        RAISERROR('Greška: Radno mesto je obavezno.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.RadnoMesto WHERE RadnoMestoId = @RadnoMestoId)
    BEGIN
        RAISERROR('Greška: Radno mesto sa datim ID-jem ne postoji.', 16, 1);
        RETURN;
    END
END;
GO

-- ============================================================
-- ISPLATA — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Isplata_CheckValueConstraints]
    @RadnikId   BIGINT,
    @Vrsta      NVARCHAR(11),
    @Datum      DATE,
    @Iznos      MONEY,
    @IsInsert   BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @RadnikId IS NULL
    BEGIN
        RAISERROR('Greška: Radnik je obavezan.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.Radnik WHERE RadnikId = @RadnikId)
    BEGIN
        RAISERROR('Greška: Radnik sa datim ID-jem ne postoji.', 16, 1);
        RETURN;
    END

    IF @Vrsta IS NULL OR @Vrsta NOT IN ('REGRES', 'BONUS', 'PLATA')
    BEGIN
        RAISERROR('Greška: Vrsta isplate mora biti REGRES, BONUS ili PLATA.', 16, 1);
        RETURN;
    END

    IF @Datum IS NULL
    BEGIN
        RAISERROR('Greška: Datum isplate je obavezan.', 16, 1);
        RETURN;
    END

    IF @Iznos IS NULL OR @Iznos <= 0
    BEGIN
        RAISERROR('Greška: Iznos isplate mora biti veći od 0.', 16, 1);
        RETURN;
    END
END;
GO
