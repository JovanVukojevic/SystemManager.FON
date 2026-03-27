-- ============================================================
-- RADNOMESTO
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_RadnoMesto_Insert]
    @Naziv NVARCHAR(22)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_RadnoMesto_CheckValueConstraints
            @RadnoMestoId = NULL, @Naziv = @Naziv, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.RadnoMesto (Naziv) VALUES (@Naziv);
            SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_RadnoMesto_Update]
    @RadnoMestoId   BIGINT,
    @Naziv          NVARCHAR(22)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_RadnoMesto_CheckValueConstraints
            @RadnoMestoId = @RadnoMestoId, @Naziv = @Naziv, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.RadnoMesto SET Naziv = @Naziv WHERE RadnoMestoId = @RadnoMestoId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_RadnoMesto_Delete]
    @RadnoMestoId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.RadnoMesto WHERE RadnoMestoId = @RadnoMestoId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- SLUZBA
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Sluzba_Insert]
    @Naziv NVARCHAR(22)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Sluzba_CheckValueConstraints
            @SluzbaId = NULL, @Naziv = @Naziv, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Sluzba (Naziv) VALUES (@Naziv);
            SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Sluzba_Update]
    @SluzbaId   BIGINT,
    @Naziv      NVARCHAR(22)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Sluzba_CheckValueConstraints
            @SluzbaId = @SluzbaId, @Naziv = @Naziv, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Sluzba SET Naziv = @Naziv WHERE SluzbaId = @SluzbaId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Sluzba_Delete]
    @SluzbaId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Sluzba WHERE SluzbaId = @SluzbaId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- PROJEKAT
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Projekat_Insert]
    @Naziv  NVARCHAR(50),
    @Budzet MONEY
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Projekat_CheckValueConstraints
            @ProjekatId = NULL, @Naziv = @Naziv, @Budzet = @Budzet, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Projekat (Naziv, Budzet) VALUES (@Naziv, @Budzet);
            SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Projekat_Update]
    @ProjekatId BIGINT,
    @Naziv      NVARCHAR(50),
    @Budzet     MONEY
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Projekat_CheckValueConstraints
            @ProjekatId = @ProjekatId, @Naziv = @Naziv, @Budzet = @Budzet, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Projekat SET Naziv = @Naziv, Budzet = @Budzet WHERE ProjekatId = @ProjekatId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Projekat_Delete]
    @ProjekatId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Projekat WHERE ProjekatId = @ProjekatId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- RADNIK
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Radnik_Insert]
    @Ime            NVARCHAR(22),
    @SluzbaId       BIGINT,
    @RadnoMestoId   BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Radnik_CheckValueConstraints
            @Ime = @Ime, @SluzbaId = @SluzbaId, @RadnoMestoId = @RadnoMestoId, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Radnik (Ime, SluzbaId, RadnoMestoId)
            VALUES (@Ime, @SluzbaId, @RadnoMestoId);
            SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Radnik_Update]
    @RadnikId       BIGINT,
    @Ime            NVARCHAR(22),
    @SluzbaId       BIGINT,
    @RadnoMestoId   BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Radnik_CheckValueConstraints
            @Ime = @Ime, @SluzbaId = @SluzbaId, @RadnoMestoId = @RadnoMestoId, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Radnik
            SET Ime = @Ime, SluzbaId = @SluzbaId, RadnoMestoId = @RadnoMestoId
            WHERE RadnikId = @RadnikId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Radnik_Delete]
    @RadnikId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Radnik WHERE RadnikId = @RadnikId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- ISPLATA (weak entity — RadnikId dolazi iz rute)
-- ============================================================

-- INSERT (vraća samo IsplataId — RadnikId je ulazni parametar)
CREATE OR ALTER PROCEDURE [spec].[spr_Isplata_Insert]
    @RadnikId   BIGINT,
    @Vrsta      NVARCHAR(11),
    @Datum      DATE,
    @Iznos      MONEY
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Isplata_CheckValueConstraints
            @RadnikId = @RadnikId, @Vrsta = @Vrsta, @Datum = @Datum, @Iznos = @Iznos, @IsInsert = 1;

        BEGIN TRANSACTION;
            INSERT INTO impl.Isplata (RadnikId, Vrsta, Datum, Iznos)
            VALUES (@RadnikId, @Vrsta, @Datum, @Iznos);
            SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS NoviId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE [spec].[spr_Isplata_Update]
    @IsplataId  BIGINT,
    @RadnikId   BIGINT,
    @Vrsta      NVARCHAR(11),
    @Datum      DATE,
    @Iznos      MONEY
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        EXEC spec.spr_Isplata_CheckValueConstraints
            @RadnikId = @RadnikId, @Vrsta = @Vrsta, @Datum = @Datum, @Iznos = @Iznos, @IsInsert = 0;

        BEGIN TRANSACTION;
            UPDATE impl.Isplata
            SET RadnikId = @RadnikId, Vrsta = @Vrsta, Datum = @Datum, Iznos = @Iznos
            WHERE IsplataId = @IsplataId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE [spec].[spr_Isplata_Delete]
    @IsplataId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Isplata WHERE IsplataId = @IsplataId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- UCESTVUJE (aggregation entity — trigger validira)
-- ============================================================

-- INSERT
CREATE OR ALTER PROCEDURE [spec].[spr_Ucestvuje_Insert]
    @RadnikId   BIGINT,
    @ProjekatId BIGINT,
    @DatumOd    DATE,
    @DatumDo    DATE = NULL
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO impl.Ucestvuje (RadnikId, ProjekatId, DatumOd, DatumDo)
            VALUES (@RadnikId, @ProjekatId, @DatumOd, @DatumDo);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE BY RADNIKID
CREATE OR ALTER PROCEDURE [spec].[spr_Ucestvuje_DeleteByRadnikId]
    @RadnikId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Ucestvuje WHERE RadnikId = @RadnikId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE BY PROJEKATID
CREATE OR ALTER PROCEDURE [spec].[spr_Ucestvuje_DeleteByProjekatId]
    @ProjekatId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Ucestvuje WHERE ProjekatId = @ProjekatId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- RUKOVODI (aggregation entity — trigger validira)
-- ============================================================

-- SET (UPSERT)
CREATE OR ALTER PROCEDURE [spec].[spr_Rukovodi_Set]
    @ProjekatId BIGINT,
    @RadnikId   BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            MERGE impl.Rukovodi AS target
            USING (SELECT @ProjekatId AS ProjekatId, @RadnikId AS RadnikId) AS source
            ON target.ProjekatId = source.ProjekatId
            WHEN MATCHED THEN
                UPDATE SET RadnikId = source.RadnikId
            WHEN NOT MATCHED THEN
                INSERT (ProjekatId, RadnikId) VALUES (source.ProjekatId, source.RadnikId);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- DELETE BY PROJEKATID
CREATE OR ALTER PROCEDURE [spec].[spr_Rukovodi_DeleteByProjekatId]
    @ProjekatId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM impl.Rukovodi WHERE ProjekatId = @ProjekatId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        EXEC spec.HandleError;
    END CATCH
END;
GO

-- ============================================================
-- READ PROCEDURES (spec layer — moved from api)
-- ============================================================

-- ============================================================
-- RADNOMESTO — Read
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_RadnoMesto_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT RadnoMestoId, Naziv
    FROM impl.RadnoMesto
    ORDER BY Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_RadnoMesto_GetById]
    @RadnoMestoId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT RadnoMestoId, Naziv
    FROM impl.RadnoMesto
    WHERE RadnoMestoId = @RadnoMestoId;
END;
GO

-- ============================================================
-- SLUZBA — Read
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Sluzba_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT SluzbaId, Naziv
    FROM impl.Sluzba
    ORDER BY Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Sluzba_GetById]
    @SluzbaId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT SluzbaId, Naziv
    FROM impl.Sluzba
    WHERE SluzbaId = @SluzbaId;
END;
GO

-- ============================================================
-- PROJEKAT — Read (sa JOIN na Rukovodi + Ucestvuje)
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Projekat_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. PROJEKAT
        p.ProjekatId, p.Naziv, p.Budzet, p.Klasa,
        -- RukovodiRadnikId kao skalar na Projekat redu
        ruk.RadnikId AS RukovodiRadnikId,
        -- 2. UCESTVUJE (split on RadnikId)
        u.RadnikId, u.ProjekatId, u.DatumOd, u.DatumDo
    FROM impl.Projekat p
    LEFT JOIN impl.Rukovodi ruk ON p.ProjekatId = ruk.ProjekatId
    LEFT JOIN impl.Ucestvuje u ON p.ProjekatId = u.ProjekatId
    ORDER BY p.Naziv ASC;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Projekat_GetById]
    @ProjekatId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. PROJEKAT
        p.ProjekatId, p.Naziv, p.Budzet, p.Klasa,
        -- RukovodiRadnikId kao skalar na Projekat redu
        ruk.RadnikId AS RukovodiRadnikId,
        -- 2. UCESTVUJE (split on RadnikId)
        u.RadnikId, u.ProjekatId, u.DatumOd, u.DatumDo
    FROM impl.Projekat p
    LEFT JOIN impl.Rukovodi ruk ON p.ProjekatId = ruk.ProjekatId
    LEFT JOIN impl.Ucestvuje u ON p.ProjekatId = u.ProjekatId
    WHERE p.ProjekatId = @ProjekatId;
END;
GO

-- ============================================================
-- RADNIK — Read (sa JOIN na RadnoMesto, Sluzba, Ucestvuje)
-- Dapper splitOn: "RadnoMestoId,SluzbaId,ProjekatId"
-- ============================================================

CREATE OR ALTER PROCEDURE [spec].[spr_Radnik_GetAll]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. RADNIK
        r.RadnikId, r.Ime, r.RadnoMestoId, r.SluzbaId,
        -- 2. RADNOMESTO (split on RadnoMestoId)
        rm.RadnoMestoId, rm.Naziv,
        -- 3. SLUZBA (split on SluzbaId)
        s.SluzbaId, s.Naziv,
        -- 4. UCESTVUJE (split on ProjekatId)
        u.ProjekatId, u.RadnikId, u.DatumOd, u.DatumDo
    FROM impl.Radnik r
    INNER JOIN impl.RadnoMesto rm ON r.RadnoMestoId = rm.RadnoMestoId
    INNER JOIN impl.Sluzba s ON r.SluzbaId = s.SluzbaId
    LEFT JOIN impl.Ucestvuje u ON r.RadnikId = u.RadnikId
    ORDER BY r.Ime ASC;
END;
GO

CREATE OR ALTER PROCEDURE [spec].[spr_Radnik_GetById]
    @RadnikId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. RADNIK
        r.RadnikId, r.Ime, r.RadnoMestoId, r.SluzbaId,
        -- 2. RADNOMESTO (split on RadnoMestoId)
        rm.RadnoMestoId, rm.Naziv,
        -- 3. SLUZBA (split on SluzbaId)
        s.SluzbaId, s.Naziv,
        -- 4. UCESTVUJE (split on ProjekatId)
        u.ProjekatId, u.RadnikId, u.DatumOd, u.DatumDo
    FROM impl.Radnik r
    INNER JOIN impl.RadnoMesto rm ON r.RadnoMestoId = rm.RadnoMestoId
    INNER JOIN impl.Sluzba s ON r.SluzbaId = s.SluzbaId
    LEFT JOIN impl.Ucestvuje u ON r.RadnikId = u.RadnikId
    WHERE r.RadnikId = @RadnikId;
END;
GO

-- ============================================================
-- ISPLATA — Read
-- ============================================================

-- GetByRadnikId: Sve isplate za datog radnika
CREATE OR ALTER PROCEDURE [spec].[spr_Isplata_GetByRadnikId]
    @RadnikId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IsplataId, RadnikId, Vrsta, Datum, Iznos
    FROM impl.Isplata
    WHERE RadnikId = @RadnikId
    ORDER BY Datum DESC;
END;
GO

-- GetById: Jedna isplata sa Radnik navigacijom
-- Dapper splitOn: "RadnikId"
CREATE OR ALTER PROCEDURE [spec].[spr_Isplata_GetById]
    @IsplataId BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        -- 1. ISPLATA
        i.IsplataId, i.RadnikId, i.Vrsta, i.Datum, i.Iznos,
        -- 2. RADNIK (split on RadnikId)
        r.RadnikId, r.Ime, r.RadnoMestoId, r.SluzbaId
    FROM impl.Isplata i
    INNER JOIN impl.Radnik r ON i.RadnikId = r.RadnikId
    WHERE i.IsplataId = @IsplataId;
END;
GO
