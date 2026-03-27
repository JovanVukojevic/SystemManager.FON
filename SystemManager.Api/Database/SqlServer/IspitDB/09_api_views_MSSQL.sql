-- ============================================================
-- ZVANJE
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Zvanje_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Zvanje_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Zvanje_GetById]
    @IdZvanje INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Zvanje_GetById @IdZvanje = @IdZvanje;
END;
GO

-- ============================================================
-- PREDMET
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Predmet_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Predmet_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Predmet_GetById]
    @IdPredmet INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Predmet_GetById @IdPredmet = @IdPredmet;
END;
GO

-- ============================================================
-- STUDENT
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Student_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Student_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Student_GetById]
    @BrojIndeksa VARCHAR(7)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Student_GetById @BrojIndeksa = @BrojIndeksa;
END;
GO

-- ============================================================
-- NASTAVNIK
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Nastavnik_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Nastavnik_GetAll;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Nastavnik_GetById]
    @IdNastavnik INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Nastavnik_GetById @IdNastavnik = @IdNastavnik;
END;
GO

-- ============================================================
-- ISPIT
-- ============================================================

CREATE OR ALTER PROCEDURE [api].[usp_Ispit_GetAll]
    @BrojIndeksa VARCHAR(7) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ispit_GetAll @BrojIndeksa = @BrojIndeksa;
END;
GO

CREATE OR ALTER PROCEDURE [api].[usp_Ispit_GetById]
    @IdIspit INT
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.spr_Ispit_GetById @IdIspit = @IdIspit;
END;
GO
