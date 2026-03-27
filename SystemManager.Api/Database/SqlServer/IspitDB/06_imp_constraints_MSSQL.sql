-- ============================================================
-- ZVANJE — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Zvanje_CheckValueConstraints]
    @Naziv      NVARCHAR(35),
    @IsInsert   BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Naziv IS NULL OR LTRIM(RTRIM(@Naziv)) = ''
    BEGIN
        RAISERROR('Greška: Naziv zvanja ne sme biti prazan.', 16, 1);
        RETURN;
    END

    IF @Naziv NOT IN ('Docent', 'Vanr. prof.', 'Red. prof.')
    BEGIN
        RAISERROR('Greška: Naziv zvanja mora biti Docent, Vanr. prof. ili Red. prof.', 16, 1);
        RETURN;
    END
END;
GO

-- ============================================================
-- PREDMET — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Predmet_CheckValueConstraints]
    @IdPredmet  INT = NULL,     -- NULL za INSERT, postojeći ID za UPDATE
    @Naziv      NVARCHAR(35),
    @ESPB       TINYINT,
    @IsInsert   BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Naziv IS NULL OR LTRIM(RTRIM(@Naziv)) = ''
    BEGIN
        RAISERROR('Greška: Naziv predmeta ne sme biti prazan.', 16, 1);
        RETURN;
    END

    IF @Naziv NOT LIKE '[A-Ž]%'
    BEGIN
        RAISERROR('Greška: Naziv predmeta mora počinjati velikim slovom.', 16, 1);
        RETURN;
    END

    IF @ESPB IS NOT NULL AND @ESPB <= 2
    BEGIN
        RAISERROR('Greška: ESPB mora biti veći od 2.', 16, 1);
        RETURN;
    END

    -- Provera jedinstvenosti naziva
    IF @IsInsert = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Predmet WHERE Naziv = @Naziv)
        BEGIN
            RAISERROR('Greška: Predmet sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Predmet WHERE Naziv = @Naziv AND IdPredmet <> @IdPredmet)
        BEGIN
            RAISERROR('Greška: Drugi predmet sa ovim nazivom već postoji u bazi.', 16, 1);
            RETURN;
        END
    END
END;
GO

-- ============================================================
-- STUDENT — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Student_CheckValueConstraints]
    @BrojIndeksa    VARCHAR(7),
    @Ime            NVARCHAR(22),
    @DatumRodjenja  DATE,
    @Semestar       VARCHAR(4),
    @IsInsert       BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @BrojIndeksa IS NULL OR LTRIM(RTRIM(@BrojIndeksa)) = ''
    BEGIN
        RAISERROR('Greška: Broj indeksa ne sme biti prazan.', 16, 1);
        RETURN;
    END

    IF @BrojIndeksa NOT LIKE '[0-9][0-9]/[0-9][0-9][0-9][0-9]'
    BEGIN
        RAISERROR('Greška: Broj indeksa mora biti u formatu XX/XXXX (npr. 01/2024).', 16, 1);
        RETURN;
    END

    IF @Ime IS NULL OR LTRIM(RTRIM(@Ime)) = ''
    BEGIN
        RAISERROR('Greška: Ime studenta ne sme biti prazno.', 16, 1);
        RETURN;
    END

    IF @Ime NOT LIKE '[A-Ž]%'
    BEGIN
        RAISERROR('Greška: Ime studenta mora počinjati velikim slovom.', 16, 1);
        RETURN;
    END

    IF @DatumRodjenja IS NULL
    BEGIN
        RAISERROR('Greška: Datum rođenja je obavezan.', 16, 1);
        RETURN;
    END

    IF @Semestar IS NOT NULL AND @Semestar NOT IN ('I','II','III','IV','V','VI','VII','VIII')
    BEGIN
        RAISERROR('Greška: Semestar mora biti između I i VIII.', 16, 1);
        RETURN;
    END

    -- Provera jedinstvenosti indeksa kod unosa
    IF @IsInsert = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Student WHERE BrojIndeksa = @BrojIndeksa)
        BEGIN
            RAISERROR('Greška: Student sa ovim brojem indeksa već postoji.', 16, 1);
            RETURN;
        END
    END
END;
GO

-- ============================================================
-- NASTAVNIK — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Nastavnik_CheckValueConstraints]
    @Ime        NVARCHAR(22),
    @IdZvanje   INT,
    @IsInsert   BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Ime IS NULL OR LTRIM(RTRIM(@Ime)) = ''
    BEGIN
        RAISERROR('Greška: Ime nastavnika ne sme biti prazno.', 16, 1);
        RETURN;
    END

    IF @Ime NOT LIKE '[A-Ž]%'
    BEGIN
        RAISERROR('Greška: Ime nastavnika mora počinjati velikim slovom.', 16, 1);
        RETURN;
    END

    IF @IdZvanje IS NULL
    BEGIN
        RAISERROR('Greška: Zvanje je obavezno.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.Zvanje WHERE IdZvanje = @IdZvanje)
    BEGIN
        RAISERROR('Greška: Zvanje sa datim ID-jem ne postoji.', 16, 1);
        RETURN;
    END
END;
GO

-- ============================================================
-- ISPIT — CheckValueConstraints
-- ============================================================
CREATE OR ALTER PROCEDURE [spec].[spr_Ispit_CheckValueConstraints]
    @IdIspit        INT = NULL,     -- NULL za INSERT
    @Ocena          TINYINT,
    @DatumPolaganja DATE,
    @BrojIndeksa    VARCHAR(7),
    @IdPredmet      INT,
    @IdNastavnik    INT,
    @IsInsert       BIT = 0
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    IF @Ocena < 6 OR @Ocena > 10
    BEGIN
        RAISERROR('Greška: Ocena mora biti između 6 i 10.', 16, 1);
        RETURN;
    END

    IF @DatumPolaganja IS NULL
    BEGIN
        RAISERROR('Greška: Datum polaganja je obavezan.', 16, 1);
        RETURN;
    END

    IF @DatumPolaganja > GETDATE()
    BEGIN
        RAISERROR('Greška: Datum polaganja ne može biti u budućnosti.', 16, 1);
        RETURN;
    END

    IF @BrojIndeksa IS NULL OR LTRIM(RTRIM(@BrojIndeksa)) = ''
    BEGIN
        RAISERROR('Greška: Broj indeksa je obavezan.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.Student WHERE BrojIndeksa = @BrojIndeksa)
    BEGIN
        RAISERROR('Greška: Student sa datim brojem indeksa ne postoji.', 16, 1);
        RETURN;
    END

    IF @IdPredmet IS NULL
    BEGIN
        RAISERROR('Greška: Predmet je obavezan.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.Predmet WHERE IdPredmet = @IdPredmet)
    BEGIN
        RAISERROR('Greška: Predmet sa datim ID-jem ne postoji.', 16, 1);
        RETURN;
    END

    IF @IdNastavnik IS NULL
    BEGIN
        RAISERROR('Greška: Nastavnik je obavezan.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM impl.Nastavnik WHERE IdNastavnik = @IdNastavnik)
    BEGIN
        RAISERROR('Greška: Nastavnik sa datim ID-jem ne postoji.', 16, 1);
        RETURN;
    END

    -- Jedinstvenost kombinacije Student+Predmet
    IF @IsInsert = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Ispit WHERE BrojIndeksa = @BrojIndeksa AND IdPredmet = @IdPredmet)
        BEGIN
            RAISERROR('Greška: Student već ima upisan ispit iz ovog predmeta.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM impl.Ispit WHERE BrojIndeksa = @BrojIndeksa AND IdPredmet = @IdPredmet AND IdIspit <> @IdIspit)
        BEGIN
            RAISERROR('Greška: Drugi ispit sa istom kombinacijom studenta i predmeta već postoji.', 16, 1);
            RETURN;
        END
    END
END;
GO
