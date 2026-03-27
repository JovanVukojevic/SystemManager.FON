-- ============================================================
-- RADNOMESTO
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_RadnoMesto_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_RadnoMesto_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_RadnoMesto_GetById]
    @RadnoMestoId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_RadnoMesto_GetById @RadnoMestoId = @RadnoMestoId;
END;
GO

-- ============================================================
-- SLUZBA
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Sluzba_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Sluzba_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Sluzba_GetById]
    @SluzbaId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Sluzba_GetById @SluzbaId = @SluzbaId;
END;
GO

-- ============================================================
-- PROJEKAT
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Projekat_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Projekat_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Projekat_GetById]
    @ProjekatId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Projekat_GetById @ProjekatId = @ProjekatId;
END;
GO

-- ============================================================
-- RADNIK
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Radnik_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Radnik_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Radnik_GetById]
    @RadnikId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Radnik_GetById @RadnikId = @RadnikId;
END;
GO

-- ============================================================
-- ISPLATA
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Isplata_GetByRadnikId]
    @RadnikId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Isplata_GetByRadnikId @RadnikId = @RadnikId;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Isplata_GetById]
    @IsplataId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Isplata_GetById @IsplataId = @IsplataId;
END;
GO

