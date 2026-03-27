-- ============================================================
-- RADNOMESTO
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_RadnoMesto_Create]
    @Naziv NVARCHAR(22)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_RadnoMesto_Insert @Naziv = @Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_RadnoMesto_Update]
    @RadnoMestoId   BIGINT,
    @Naziv          NVARCHAR(22)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_RadnoMesto_Update @RadnoMestoId = @RadnoMestoId, @Naziv = @Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_RadnoMesto_Delete]
    @RadnoMestoId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_RadnoMesto_Delete @RadnoMestoId = @RadnoMestoId;
END;
GO

-- ============================================================
-- SLUZBA
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Sluzba_Create]
    @Naziv NVARCHAR(22)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Sluzba_Insert @Naziv = @Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Sluzba_Update]
    @SluzbaId   BIGINT,
    @Naziv      NVARCHAR(22)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Sluzba_Update @SluzbaId = @SluzbaId, @Naziv = @Naziv;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Sluzba_Delete]
    @SluzbaId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Sluzba_Delete @SluzbaId = @SluzbaId;
END;
GO

-- ============================================================
-- PROJEKAT
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Projekat_Create]
    @Naziv  NVARCHAR(50),
    @Budzet MONEY
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Projekat_Insert @Naziv = @Naziv, @Budzet = @Budzet;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Projekat_Update]
    @ProjekatId BIGINT,
    @Naziv      NVARCHAR(50),
    @Budzet     MONEY
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Projekat_Update @ProjekatId = @ProjekatId, @Naziv = @Naziv, @Budzet = @Budzet;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Projekat_Delete]
    @ProjekatId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Projekat_Delete @ProjekatId = @ProjekatId;
END;
GO

-- ============================================================
-- RADNIK
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Radnik_Create]
    @Ime            NVARCHAR(22),
    @SluzbaId       BIGINT,
    @RadnoMestoId   BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Radnik_Insert @Ime = @Ime, @SluzbaId = @SluzbaId, @RadnoMestoId = @RadnoMestoId;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Radnik_Update]
    @RadnikId       BIGINT,
    @Ime            NVARCHAR(22),
    @SluzbaId       BIGINT,
    @RadnoMestoId   BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Radnik_Update
        @RadnikId = @RadnikId, @Ime = @Ime, @SluzbaId = @SluzbaId, @RadnoMestoId = @RadnoMestoId;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Radnik_Delete]
    @RadnikId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Radnik_Delete @RadnikId = @RadnikId;
END;
GO

-- ============================================================
-- ISPLATA
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Isplata_Create]
    @RadnikId   BIGINT,
    @Vrsta      NVARCHAR(11),
    @Datum      DATE,
    @Iznos      MONEY
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Isplata_Insert
        @RadnikId = @RadnikId, @Vrsta = @Vrsta, @Datum = @Datum, @Iznos = @Iznos;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Isplata_Update]
    @IsplataId  BIGINT,
    @RadnikId   BIGINT,
    @Vrsta      NVARCHAR(11),
    @Datum      DATE,
    @Iznos      MONEY
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Isplata_Update
        @IsplataId = @IsplataId, @RadnikId = @RadnikId, @Vrsta = @Vrsta, @Datum = @Datum, @Iznos = @Iznos;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Isplata_Delete]
    @IsplataId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Isplata_Delete @IsplataId = @IsplataId;
END;
GO

-- ============================================================
-- UCESTVUJE
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Ucestvuje_Insert]
    @RadnikId   BIGINT,
    @ProjekatId BIGINT,
    @DatumOd    DATE,
    @DatumDo    DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ucestvuje_Insert
        @RadnikId = @RadnikId, @ProjekatId = @ProjekatId, @DatumOd = @DatumOd, @DatumDo = @DatumDo;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Ucestvuje_DeleteByRadnikId]
    @RadnikId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ucestvuje_DeleteByRadnikId @RadnikId = @RadnikId;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Ucestvuje_DeleteByProjekatId]
    @ProjekatId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ucestvuje_DeleteByProjekatId @ProjekatId = @ProjekatId;
END;
GO

-- ============================================================
-- RUKOVODI
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Rukovodi_Set]
    @ProjekatId BIGINT,
    @RadnikId   BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Rukovodi_Set @ProjekatId = @ProjekatId, @RadnikId = @RadnikId;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Rukovodi_DeleteByProjekatId]
    @ProjekatId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Rukovodi_DeleteByProjekatId @ProjekatId = @ProjekatId;
END;
GO
