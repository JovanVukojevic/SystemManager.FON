-- ============================================================
-- ZVANJE
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Zvanje_Insert]
    @Naziv NVARCHAR(35)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Zvanje_CheckValueConstraints @Naziv = @Naziv, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Zvanje (Naziv) VALUES (@Naziv);
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Zvanje_Update]
    @IdZvanje   INT,
    @Naziv      NVARCHAR(35)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Zvanje_CheckValueConstraints @Naziv = @Naziv, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Zvanje SET Naziv = @Naziv WHERE IdZvanje = @IdZvanje;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Zvanje_Delete]
    @IdZvanje INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Zvanje WHERE IdZvanje = @IdZvanje;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- PREDMET
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Predmet_Insert]
    @Naziv  NVARCHAR(35),
    @ESPB   TINYINT = 4
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Predmet_CheckValueConstraints
            @IdPredmet = NULL, @Naziv = @Naziv, @ESPB = @ESPB, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Predmet (Naziv, ESPB) VALUES (@Naziv, @ESPB);
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Predmet_Update]
    @IdPredmet  INT,
    @Naziv      NVARCHAR(35),
    @ESPB       TINYINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Predmet_CheckValueConstraints
            @IdPredmet = @IdPredmet, @Naziv = @Naziv, @ESPB = @ESPB, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Predmet SET Naziv = @Naziv, ESPB = @ESPB WHERE IdPredmet = @IdPredmet;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Predmet_Delete]
    @IdPredmet INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Predmet WHERE IdPredmet = @IdPredmet;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- STUDENT
-- ============================================================

-- INSERT (BrojIndeksa je prirodni ključ — nema SCOPE_IDENTITY)
CREATE OR ALTER PROCEDURE [spec].[spr_Student_Insert]
    @BrojIndeksa    VARCHAR(7),
    @Ime            NVARCHAR(22),
    @DatumRodjenja  DATE,
    @Semestar       VARCHAR(4)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Student_CheckValueConstraints
            @BrojIndeksa = @BrojIndeksa, @Ime = @Ime,
            @DatumRodjenja = @DatumRodjenja, @Semestar = @Semestar, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Student (BrojIndeksa, Ime, DatumRodjenja, Semestar)
            VALUES (@BrojIndeksa, @Ime, @DatumRodjenja, @Semestar);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Student_Update]
    @BrojIndeksa    VARCHAR(7),
    @Ime            NVARCHAR(22),
    @DatumRodjenja  DATE,
    @Semestar       VARCHAR(4)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Student_CheckValueConstraints
            @BrojIndeksa = @BrojIndeksa, @Ime = @Ime,
            @DatumRodjenja = @DatumRodjenja, @Semestar = @Semestar, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Student
            SET Ime = @Ime, DatumRodjenja = @DatumRodjenja, Semestar = @Semestar
            WHERE BrojIndeksa = @BrojIndeksa;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Student_Delete]
    @BrojIndeksa VARCHAR(7)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Student WHERE BrojIndeksa = @BrojIndeksa;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- NASTAVNIK
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Nastavnik_Insert]
    @Ime        NVARCHAR(22),
    @IdZvanje   INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Nastavnik_CheckValueConstraints
            @Ime = @Ime, @IdZvanje = @IdZvanje, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Nastavnik (Ime, IdZvanje) VALUES (@Ime, @IdZvanje);
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Nastavnik_Update]
    @IdNastavnik    INT,
    @Ime            NVARCHAR(22),
    @IdZvanje       INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Nastavnik_CheckValueConstraints
            @Ime = @Ime, @IdZvanje = @IdZvanje, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Nastavnik SET Ime = @Ime, IdZvanje = @IdZvanje WHERE IdNastavnik = @IdNastavnik;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Nastavnik_Delete]
    @IdNastavnik INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Nastavnik WHERE IdNastavnik = @IdNastavnik;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- ISPIT
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Ispit_Insert]
    @Ocena          TINYINT,
    @DatumPolaganja DATE,
    @BrojIndeksa    VARCHAR(7),
    @IdPredmet      INT,
    @IdNastavnik    INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Ispit_CheckValueConstraints
            @IdIspit = NULL, @Ocena = @Ocena, @DatumPolaganja = @DatumPolaganja,
            @BrojIndeksa = @BrojIndeksa, @IdPredmet = @IdPredmet, @IdNastavnik = @IdNastavnik,
            @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Ispit (Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik)
            VALUES (@Ocena, @DatumPolaganja, @BrojIndeksa, @IdPredmet, @IdNastavnik);
            SELECT CAST(SCOPE_IDENTITY() AS INT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Ispit_Update]
    @IdIspit        INT,
    @Ocena          TINYINT,
    @DatumPolaganja DATE,
    @BrojIndeksa    VARCHAR(7),
    @IdPredmet      INT,
    @IdNastavnik    INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Ispit_CheckValueConstraints
            @IdIspit = @IdIspit, @Ocena = @Ocena, @DatumPolaganja = @DatumPolaganja,
            @BrojIndeksa = @BrojIndeksa, @IdPredmet = @IdPredmet, @IdNastavnik = @IdNastavnik,
            @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Ispit
            SET Ocena = @Ocena, DatumPolaganja = @DatumPolaganja,
                BrojIndeksa = @BrojIndeksa, IdPredmet = @IdPredmet, IdNastavnik = @IdNastavnik
            WHERE IdIspit = @IdIspit;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Ispit_Delete]
    @IdIspit INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Ispit WHERE IdIspit = @IdIspit;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- READ PROCEDURES (spec layer — called by api wrappers)
-- ============================================================

-- ============================================================
-- ZVANJE — Read
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Zvanje_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdZvanje, Naziv
    FROM impl.Zvanje
    ORDER BY IdZvanje;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Zvanje_GetById]
    @IdZvanje INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdZvanje, Naziv
    FROM impl.Zvanje
    WHERE IdZvanje = @IdZvanje;
END;
GO

-- ============================================================
-- PREDMET — Read
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Predmet_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPredmet, Naziv, ESPB
    FROM impl.Predmet
    ORDER BY Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Predmet_GetById]
    @IdPredmet INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPredmet, Naziv, ESPB
    FROM impl.Predmet
    WHERE IdPredmet = @IdPredmet;
END;
GO

-- ============================================================
-- STUDENT — Read
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Student_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        BrojIndeksa,
        Ime,
        DatumRodjenja,
        Semestar,
        Starost,
        ProsecnaOcena
    FROM impl.Student
    ORDER BY BrojIndeksa ASC;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Student_GetById]
    @BrojIndeksa VARCHAR(7)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        BrojIndeksa,
        Ime,
        DatumRodjenja,
        Semestar,
        Starost,
        ProsecnaOcena
    FROM impl.Student
    WHERE BrojIndeksa = @BrojIndeksa;
END;
GO

-- ============================================================
-- NASTAVNIK — Read (sa JOIN na Zvanje za navigacioni property)
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Nastavnik_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        n.IdNastavnik,
        n.Ime,
        n.IdZvanje,
        z.IdZvanje,
        z.Naziv
    FROM impl.Nastavnik n
    INNER JOIN impl.Zvanje z ON n.IdZvanje = z.IdZvanje
    ORDER BY n.Ime ASC;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Nastavnik_GetById]
    @IdNastavnik INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        n.IdNastavnik,
        n.Ime,
        n.IdZvanje,
        z.IdZvanje,
        z.Naziv
    FROM impl.Nastavnik n
    INNER JOIN impl.Zvanje z ON n.IdZvanje = z.IdZvanje
    WHERE n.IdNastavnik = @IdNastavnik;
END;
GO

-- ============================================================
-- ISPIT — Read (sa JOIN na Student, Nastavnik, Zvanje, Predmet)
-- Redosled kolona identičan postojećem za Dapper multi-mapping
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Ispit_GetAll]
    @BrojIndeksa VARCHAR(7) = NULL
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. ISPIT
        i.IdIspit, i.Ocena, i.DatumPolaganja, i.BrojIndeksa, i.IdPredmet, i.IdNastavnik,
        -- 2. STUDENT
        s.BrojIndeksa, s.Ime, s.DatumRodjenja, s.Semestar, s.Starost, s.ProsecnaOcena,
        -- 3. NASTAVNIK
        n.IdNastavnik, n.Ime, n.IdZvanje,
        -- 4. ZVANJE
        z.IdZvanje, z.Naziv,
        -- 5. PREDMET
        p.IdPredmet, p.Naziv, p.ESPB
    FROM impl.Ispit i
    INNER JOIN impl.Student s ON i.BrojIndeksa = s.BrojIndeksa
    INNER JOIN impl.Nastavnik n ON i.IdNastavnik = n.IdNastavnik
    INNER JOIN impl.Zvanje z ON n.IdZvanje = z.IdZvanje
    INNER JOIN impl.Predmet p ON i.IdPredmet = p.IdPredmet
    WHERE (@BrojIndeksa IS NULL OR i.BrojIndeksa = @BrojIndeksa)
    ORDER BY i.DatumPolaganja DESC;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Ispit_GetById]
    @IdIspit INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. ISPIT
        i.IdIspit, i.Ocena, i.DatumPolaganja, i.BrojIndeksa, i.IdPredmet, i.IdNastavnik,
        -- 2. STUDENT
        s.BrojIndeksa, s.Ime, s.DatumRodjenja, s.Semestar, s.Starost, s.ProsecnaOcena,
        -- 3. NASTAVNIK
        n.IdNastavnik, n.Ime, n.IdZvanje,
        -- 4. ZVANJE
        z.IdZvanje, z.Naziv,
        -- 5. PREDMET
        p.IdPredmet, p.Naziv, p.ESPB
    FROM impl.Ispit i
    INNER JOIN impl.Student s ON i.BrojIndeksa = s.BrojIndeksa
    INNER JOIN impl.Nastavnik n ON i.IdNastavnik = n.IdNastavnik
    INNER JOIN impl.Zvanje z ON n.IdZvanje = z.IdZvanje
    INNER JOIN impl.Predmet p ON i.IdPredmet = p.IdPredmet
    WHERE i.IdIspit = @IdIspit;
END;
GO
