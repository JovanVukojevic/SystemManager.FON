-- ============================================================
-- AUDIT TRIGERI
-- ============================================================

-- ------------------------------------------------------------
-- ZVANJE — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Zvanje_Audit]
ON impl.Zvanje
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- DELETE: stare vrednosti
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Zvanje_Audit (ActionType, IdZvanje, Naziv)
        SELECT 'DEL', IdZvanje, Naziv FROM deleted;
    END

    -- INSERT: nove vrednosti
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Zvanje_Audit (ActionType, IdZvanje, Naziv)
        SELECT 'INS', IdZvanje, Naziv FROM inserted;
    END

    -- UPDATE: dva reda — stare pa nove vrednosti
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Zvanje_Audit (ActionType, IdZvanje, Naziv)
        SELECT 'UPD', IdZvanje, Naziv FROM deleted;

        INSERT INTO impl.Zvanje_Audit (ActionType, IdZvanje, Naziv)
        SELECT 'UPD', IdZvanje, Naziv FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- PREDMET — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Predmet_Audit]
ON impl.Predmet
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Predmet_Audit (ActionType, IdPredmet, Naziv, ESPB)
        SELECT 'DEL', IdPredmet, Naziv, ESPB FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Predmet_Audit (ActionType, IdPredmet, Naziv, ESPB)
        SELECT 'INS', IdPredmet, Naziv, ESPB FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Predmet_Audit (ActionType, IdPredmet, Naziv, ESPB)
        SELECT 'UPD', IdPredmet, Naziv, ESPB FROM deleted;

        INSERT INTO impl.Predmet_Audit (ActionType, IdPredmet, Naziv, ESPB)
        SELECT 'UPD', IdPredmet, Naziv, ESPB FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- STUDENT — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Student_Audit]
ON impl.Student
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Student_Audit (ActionType, BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena)
        SELECT 'DEL', BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Student_Audit (ActionType, BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena)
        SELECT 'INS', BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Student_Audit (ActionType, BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena)
        SELECT 'UPD', BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena FROM deleted;

        INSERT INTO impl.Student_Audit (ActionType, BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena)
        SELECT 'UPD', BrojIndeksa, Ime, DatumRodjenja, Semestar, ProsecnaOcena FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- NASTAVNIK — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Nastavnik_Audit]
ON impl.Nastavnik
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Nastavnik_Audit (ActionType, IdNastavnik, Ime, IdZvanje)
        SELECT 'DEL', IdNastavnik, Ime, IdZvanje FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Nastavnik_Audit (ActionType, IdNastavnik, Ime, IdZvanje)
        SELECT 'INS', IdNastavnik, Ime, IdZvanje FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Nastavnik_Audit (ActionType, IdNastavnik, Ime, IdZvanje)
        SELECT 'UPD', IdNastavnik, Ime, IdZvanje FROM deleted;

        INSERT INTO impl.Nastavnik_Audit (ActionType, IdNastavnik, Ime, IdZvanje)
        SELECT 'UPD', IdNastavnik, Ime, IdZvanje FROM inserted;
    END
END;
GO

-- ------------------------------------------------------------
-- ISPIT — Audit
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_Ispit_Audit]
ON impl.Ispit
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.Ispit_Audit (ActionType, IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik)
        SELECT 'DEL', IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik FROM deleted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Ispit_Audit (ActionType, IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik)
        SELECT 'INS', IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik FROM inserted;
    END

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.Ispit_Audit (ActionType, IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik)
        SELECT 'UPD', IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik FROM deleted;

        INSERT INTO impl.Ispit_Audit (ActionType, IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik)
        SELECT 'UPD', IdIspit, Ocena, DatumPolaganja, BrojIndeksa, IdPredmet, IdNastavnik FROM inserted;
    END
END;
GO

-- ============================================================
-- POSLOVNI TRIGERI (business logic — preneseni iz postojeće šeme)
-- ============================================================

-- ------------------------------------------------------------
-- STUDENT: Provera semestra III — mora imati položenu Matematiku
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_CheckSemestarIII]
ON impl.Student
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.Semestar IN ('III', 'IV', 'V', 'VI', 'VII', 'VIII')
          AND NOT EXISTS (
              SELECT 1
              FROM impl.Ispit isp
              INNER JOIN impl.Predmet p ON isp.IdPredmet = p.IdPredmet
              WHERE isp.BrojIndeksa = i.BrojIndeksa
                AND p.Naziv = 'Matematika'
                AND isp.Ocena > 5
          )
    )
    BEGIN
        RAISERROR ('Greška: Nije dozvoljeno da student bude u III semestru ako nema položenu Matematiku.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ------------------------------------------------------------
-- ISPIT: Ocena se ne sme smanjiti prilikom ponovnog polaganja
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_CheckOcenaIncrease]
ON impl.Ispit
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.IdIspit = d.IdIspit
        WHERE i.Ocena < d.Ocena
    )
    BEGIN
        RAISERROR ('Greška: Prilikom ponovnog polaganja, nova ocena ne sme biti manja od prethodne.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ------------------------------------------------------------
-- ISPIT: Programiranje i Algoritmi — samo Vanr./Red. prof.
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_CheckProfesorZvanje]
ON impl.Ispit
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN impl.Predmet p ON i.IdPredmet = p.IdPredmet
        JOIN impl.Nastavnik n ON i.IdNastavnik = n.IdNastavnik
        JOIN impl.Zvanje z ON n.IdZvanje = z.IdZvanje
        WHERE p.Naziv IN ('Programiranje', 'Algoritmi')
          AND z.Naziv NOT IN ('Vanr. prof.', 'Red. prof.')
    )
    BEGIN
        RAISERROR ('Greška: Predmete Programiranje i Algoritmi mogu overiti samo Redovni ili Vanredni profesori.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ------------------------------------------------------------
-- ISPIT: Ažuriranje prosečne ocene studenta
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER [impl].[trg_UpdateProsek]
ON impl.Ispit
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentsToUpdate TABLE (Indeks VARCHAR(7));

    INSERT INTO @StudentsToUpdate
    SELECT BrojIndeksa FROM inserted
    UNION
    SELECT BrojIndeksa FROM deleted;

    UPDATE s
    SET ProsecnaOcena = ISNULL((
        SELECT CAST(AVG(CAST(i.Ocena AS DECIMAL(4,2))) AS DECIMAL(4,2))
        FROM impl.Ispit i
        WHERE i.BrojIndeksa = s.BrojIndeksa
    ), 0)
    FROM impl.Student s
    WHERE s.BrojIndeksa IN (SELECT Indeks FROM @StudentsToUpdate);
END;
GO
