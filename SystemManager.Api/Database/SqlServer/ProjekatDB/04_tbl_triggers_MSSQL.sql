-- ============================================================
-- AUDIT TRIGERI
-- ============================================================

-- ------------------------------------------------------------
-- RADNOMESTO — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_RadnoMesto_Audit]
ON impl.RadnoMesto
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- DELETE: stare vrednosti
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.RadnoMesto_Audit (ActionType, RadnoMestoId, Naziv)
        SELECT 'DEL', RadnoMestoId, Naziv FROM deleted;
    END

    -- INSERT: nove vrednosti
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.RadnoMesto_Audit (ActionType, RadnoMestoId, Naziv)
        SELECT 'INS', RadnoMestoId, Naziv FROM inserted;
    END

    -- UPDATE: dva reda — stare pa nove vrednosti
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.RadnoMesto_Audit (ActionType, RadnoMestoId, Naziv)
        SELECT 'UPD', RadnoMestoId, Naziv FROM deleted;

        INSERT INTO impl.RadnoMesto_Audit (ActionType, RadnoMestoId, Naziv)
        SELECT 'UPD', RadnoMestoId, Naziv FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- SLUZBA — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Sluzba_Audit]
ON impl.Sluzba
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Sluzba_Audit (ActionType, SluzbaId, Naziv)
        SELECT 'DEL', SluzbaId, Naziv FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Sluzba_Audit (ActionType, SluzbaId, Naziv)
        SELECT 'INS', SluzbaId, Naziv FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Sluzba_Audit (ActionType, SluzbaId, Naziv)
        SELECT 'UPD', SluzbaId, Naziv FROM deleted;

        INSERT INTO impl.Sluzba_Audit (ActionType, SluzbaId, Naziv)
        SELECT 'UPD', SluzbaId, Naziv FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- PROJEKAT — Audit (bez Klasa — computed kolona)
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Projekat_Audit]
ON impl.Projekat
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Projekat_Audit (ActionType, ProjekatId, Naziv, Budzet)
        SELECT 'DEL', ProjekatId, Naziv, Budzet FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Projekat_Audit (ActionType, ProjekatId, Naziv, Budzet)
        SELECT 'INS', ProjekatId, Naziv, Budzet FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Projekat_Audit (ActionType, ProjekatId, Naziv, Budzet)
        SELECT 'UPD', ProjekatId, Naziv, Budzet FROM deleted;

        INSERT INTO impl.Projekat_Audit (ActionType, ProjekatId, Naziv, Budzet)
        SELECT 'UPD', ProjekatId, Naziv, Budzet FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- RADNIK — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Radnik_Audit]
ON impl.Radnik
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Radnik_Audit (ActionType, RadnikId, Ime, SluzbaId, RadnoMestoId)
        SELECT 'DEL', RadnikId, Ime, SluzbaId, RadnoMestoId FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Radnik_Audit (ActionType, RadnikId, Ime, SluzbaId, RadnoMestoId)
        SELECT 'INS', RadnikId, Ime, SluzbaId, RadnoMestoId FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Radnik_Audit (ActionType, RadnikId, Ime, SluzbaId, RadnoMestoId)
        SELECT 'UPD', RadnikId, Ime, SluzbaId, RadnoMestoId FROM deleted;

        INSERT INTO impl.Radnik_Audit (ActionType, RadnikId, Ime, SluzbaId, RadnoMestoId)
        SELECT 'UPD', RadnikId, Ime, SluzbaId, RadnoMestoId FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- ISPLATA — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Isplata_Audit]
ON impl.Isplata
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Isplata_Audit (ActionType, RadnikId, IsplataId, Datum, Iznos, Vrsta)
        SELECT 'DEL', RadnikId, IsplataId, Datum, Iznos, Vrsta FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Isplata_Audit (ActionType, RadnikId, IsplataId, Datum, Iznos, Vrsta)
        SELECT 'INS', RadnikId, IsplataId, Datum, Iznos, Vrsta FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Isplata_Audit (ActionType, RadnikId, IsplataId, Datum, Iznos, Vrsta)
        SELECT 'UPD', RadnikId, IsplataId, Datum, Iznos, Vrsta FROM deleted;

        INSERT INTO impl.Isplata_Audit (ActionType, RadnikId, IsplataId, Datum, Iznos, Vrsta)
        SELECT 'UPD', RadnikId, IsplataId, Datum, Iznos, Vrsta FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- UCESTVUJE — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Ucestvuje_Audit]
ON impl.Ucestvuje
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Ucestvuje_Audit (ActionType, UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId)
        SELECT 'DEL', UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Ucestvuje_Audit (ActionType, UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId)
        SELECT 'INS', UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Ucestvuje_Audit (ActionType, UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId)
        SELECT 'UPD', UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId FROM deleted;

        INSERT INTO impl.Ucestvuje_Audit (ActionType, UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId)
        SELECT 'UPD', UcestvujeId, DatumOd, DatumDo, RadnikId, ProjekatId FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- RUKOVODI — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Rukovodi_Audit]
ON impl.Rukovodi
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Rukovodi_Audit (ActionType, RukovodiId, RadnikId, ProjekatId)
        SELECT 'DEL', RukovodiId, RadnikId, ProjekatId FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Rukovodi_Audit (ActionType, RukovodiId, RadnikId, ProjekatId)
        SELECT 'INS', RukovodiId, RadnikId, ProjekatId FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Rukovodi_Audit (ActionType, RukovodiId, RadnikId, ProjekatId)
        SELECT 'UPD', RukovodiId, RadnikId, ProjekatId FROM deleted;

        INSERT INTO impl.Rukovodi_Audit (ActionType, RukovodiId, RadnikId, ProjekatId)
        SELECT 'UPD', RukovodiId, RadnikId, ProjekatId FROM inserted;
    END
END;
GO

-- ============================================================
-- POSLOVNI TRIGERI (business logic — preneseni iz postojeće šeme)
-- ============================================================

-- ------------------------------------------------------------
-- ISPLATA: Dnevni limit (max 3) i mesečni limit (max 500 n.j.)
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_IsplataLimitiCheck]
ON impl.Isplata
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Provera dnevnog limita (maksimalno 3 isplate dnevno)
    IF EXISTS (
        SELECT 1
        FROM impl.Isplata ispl
        WHERE ispl.RadnikId IN (SELECT RadnikId FROM inserted)
        GROUP BY ispl.RadnikId, ispl.Datum
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR ('Greška: Radnik ne može imati više od tri isplate u istom danu.', 16, 1);
        RETURN;
    END

    -- 2. Provera mesečnog limita (maksimalno 500 n.j.)
    IF EXISTS (
        SELECT 1
        FROM impl.Isplata ispl
        WHERE ispl.RadnikId IN (SELECT RadnikId FROM inserted)
        GROUP BY ispl.RadnikId, MONTH(ispl.Datum), YEAR(ispl.Datum)
        HAVING SUM(ispl.Iznos) > 500
    )
    BEGIN
        RAISERROR ('Greška: Mesečna suma isplata radniku ne sme preći 500 n.j.', 16, 1);
    END
END;
GO

-- ------------------------------------------------------------
-- PROJEKAT: Promena budžeta ne sme biti veća od +/- 12%
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_ProjekatBudzetCheck]
ON impl.Projekat
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Budzet)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.ProjekatId = d.ProjekatId
            WHERE i.Budzet < d.Budzet * 0.88 OR i.Budzet > d.Budzet * 1.12
        )
        BEGIN
            RAISERROR ('Greška: Nije dozvoljena promena budžeta veća od +/- 12%%.', 16, 1);
        END
    END
END;
GO

-- ------------------------------------------------------------
-- RUKOVODI: Samo ŠEF ili NAČELNIK + mora učestvovati na projektu
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_RukovodiCheck]
ON impl.Rukovodi
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Provera kvalifikacije (Šef ili Načelnik)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN impl.Radnik r ON i.RadnikId = r.RadnikId
        JOIN impl.RadnoMesto rm ON r.RadnoMestoId = rm.RadnoMestoId
        WHERE UPPER(rm.Naziv) NOT IN (N'ŠEF', N'NAČELNIK')
    )
    BEGIN
        RAISERROR ('Greška: Projektom može rukovoditi samo radnik sa radnog mesta ŠEF ili NAČELNIK.', 16, 1);
        RETURN;
    END

    -- 2. Provera da li je rukovodilac istovremeno i učesnik
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1 FROM impl.Ucestvuje u
            WHERE u.RadnikId = i.RadnikId AND u.ProjekatId = i.ProjekatId
        )
    )
    BEGIN
        RAISERROR ('Greška: Radnik ne može rukovoditi projektom ako na njemu ne učestvuje.', 16, 1);
    END
END;
GO

-- ------------------------------------------------------------
-- UCESTVUJE: Radnici službe RAČUNOVODSTVO ne mogu učestvovati
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_UcestvujeRacunvodstvoCheck]
ON impl.Ucestvuje
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN impl.Radnik r ON i.RadnikId = r.RadnikId
        JOIN impl.Sluzba s ON r.SluzbaId = s.SluzbaId
        WHERE UPPER(s.Naziv) = N'RAČUNOVODSTVO'
    )
    BEGIN
        RAISERROR ('Greška: Radnici službe RAČUNOVODSTVO ne mogu učestvovati na projektima.', 16, 1);
    END
END;
GO
