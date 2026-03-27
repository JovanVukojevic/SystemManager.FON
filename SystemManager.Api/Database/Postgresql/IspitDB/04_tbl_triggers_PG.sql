-- ============================================================
-- AUDIT TRIGERI
-- ============================================================

-- ------------------------------------------------------------
-- ZVANJE — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_zvanje_audit()
RETURNS TRIGGER AS $$
BEGIN
    -- DELETE: stare vrednosti
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.zvanje_audit (action_type, id_zvanje, naziv)
        VALUES ('DEL', OLD.id_zvanje, OLD.naziv);
        RETURN OLD;
    END IF;

    -- INSERT: nove vrednosti
    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.zvanje_audit (action_type, id_zvanje, naziv)
        VALUES ('INS', NEW.id_zvanje, NEW.naziv);
        RETURN NEW;
    END IF;

    -- UPDATE: dva reda — stare pa nove vrednosti
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.zvanje_audit (action_type, id_zvanje, naziv)
        VALUES ('UPD', OLD.id_zvanje, OLD.naziv);

        INSERT INTO impl.zvanje_audit (action_type, id_zvanje, naziv)
        VALUES ('UPD', NEW.id_zvanje, NEW.naziv);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_zvanje_audit ON impl.zvanje;
CREATE TRIGGER trg_zvanje_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.zvanje
FOR EACH ROW
EXECUTE FUNCTION impl.fn_zvanje_audit();

-- ------------------------------------------------------------
-- PREDMET — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_predmet_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.predmet_audit (action_type, id_predmet, naziv, espb)
        VALUES ('DEL', OLD.id_predmet, OLD.naziv, OLD.espb);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.predmet_audit (action_type, id_predmet, naziv, espb)
        VALUES ('INS', NEW.id_predmet, NEW.naziv, NEW.espb);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.predmet_audit (action_type, id_predmet, naziv, espb)
        VALUES ('UPD', OLD.id_predmet, OLD.naziv, OLD.espb);

        INSERT INTO impl.predmet_audit (action_type, id_predmet, naziv, espb)
        VALUES ('UPD', NEW.id_predmet, NEW.naziv, NEW.espb);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_predmet_audit ON impl.predmet;
CREATE TRIGGER trg_predmet_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.predmet
FOR EACH ROW
EXECUTE FUNCTION impl.fn_predmet_audit();

-- ------------------------------------------------------------
-- STUDENT — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_student_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.student_audit (action_type, broj_indeksa, ime, datum_rodjenja, semestar, prosecna_ocena)
        VALUES ('DEL', OLD.broj_indeksa, OLD.ime, OLD.datum_rodjenja, OLD.semestar, OLD.prosecna_ocena);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.student_audit (action_type, broj_indeksa, ime, datum_rodjenja, semestar, prosecna_ocena)
        VALUES ('INS', NEW.broj_indeksa, NEW.ime, NEW.datum_rodjenja, NEW.semestar, NEW.prosecna_ocena);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.student_audit (action_type, broj_indeksa, ime, datum_rodjenja, semestar, prosecna_ocena)
        VALUES ('UPD', OLD.broj_indeksa, OLD.ime, OLD.datum_rodjenja, OLD.semestar, OLD.prosecna_ocena);

        INSERT INTO impl.student_audit (action_type, broj_indeksa, ime, datum_rodjenja, semestar, prosecna_ocena)
        VALUES ('UPD', NEW.broj_indeksa, NEW.ime, NEW.datum_rodjenja, NEW.semestar, NEW.prosecna_ocena);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_student_audit ON impl.student;
CREATE TRIGGER trg_student_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.student
FOR EACH ROW
EXECUTE FUNCTION impl.fn_student_audit();

-- ------------------------------------------------------------
-- NASTAVNIK — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_nastavnik_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.nastavnik_audit (action_type, id_nastavnik, ime, id_zvanje)
        VALUES ('DEL', OLD.id_nastavnik, OLD.ime, OLD.id_zvanje);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.nastavnik_audit (action_type, id_nastavnik, ime, id_zvanje)
        VALUES ('INS', NEW.id_nastavnik, NEW.ime, NEW.id_zvanje);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.nastavnik_audit (action_type, id_nastavnik, ime, id_zvanje)
        VALUES ('UPD', OLD.id_nastavnik, OLD.ime, OLD.id_zvanje);

        INSERT INTO impl.nastavnik_audit (action_type, id_nastavnik, ime, id_zvanje)
        VALUES ('UPD', NEW.id_nastavnik, NEW.ime, NEW.id_zvanje);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_nastavnik_audit ON impl.nastavnik;
CREATE TRIGGER trg_nastavnik_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.nastavnik
FOR EACH ROW
EXECUTE FUNCTION impl.fn_nastavnik_audit();

-- ------------------------------------------------------------
-- ISPIT — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_ispit_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.ispit_audit (action_type, id_ispit, ocena, datum_polaganja, broj_indeksa, id_predmet, id_nastavnik)
        VALUES ('DEL', OLD.id_ispit, OLD.ocena, OLD.datum_polaganja, OLD.broj_indeksa, OLD.id_predmet, OLD.id_nastavnik);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.ispit_audit (action_type, id_ispit, ocena, datum_polaganja, broj_indeksa, id_predmet, id_nastavnik)
        VALUES ('INS', NEW.id_ispit, NEW.ocena, NEW.datum_polaganja, NEW.broj_indeksa, NEW.id_predmet, NEW.id_nastavnik);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.ispit_audit (action_type, id_ispit, ocena, datum_polaganja, broj_indeksa, id_predmet, id_nastavnik)
        VALUES ('UPD', OLD.id_ispit, OLD.ocena, OLD.datum_polaganja, OLD.broj_indeksa, OLD.id_predmet, OLD.id_nastavnik);

        INSERT INTO impl.ispit_audit (action_type, id_ispit, ocena, datum_polaganja, broj_indeksa, id_predmet, id_nastavnik)
        VALUES ('UPD', NEW.id_ispit, NEW.ocena, NEW.datum_polaganja, NEW.broj_indeksa, NEW.id_predmet, NEW.id_nastavnik);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_ispit_audit ON impl.ispit;
CREATE TRIGGER trg_ispit_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.ispit
FOR EACH ROW
EXECUTE FUNCTION impl.fn_ispit_audit();

-- ============================================================
-- POSLOVNI TRIGERI (business logic — preneseni iz postojeće šeme)
-- ============================================================

-- ------------------------------------------------------------
-- STUDENT: Provera semestra III — mora imati položenu Matematiku
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_semestar_iii()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.semestar IN ('III','IV','V','VI','VII','VIII') THEN
        IF NOT EXISTS (
            SELECT 1
            FROM impl.ispit i
            JOIN impl.predmet p ON i.id_predmet = p.id_predmet
            WHERE i.broj_indeksa = NEW.broj_indeksa
              AND p.naziv = 'Matematika'
              AND i.ocena > 5
        ) THEN
            RAISE EXCEPTION 'Greška: Nije dozvoljeno da student bude u III semestru ako nema položenu Matematiku.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_semestar_iii ON impl.student;
CREATE TRIGGER trg_check_semestar_iii
BEFORE INSERT OR UPDATE ON impl.student
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_semestar_iii();

-- ------------------------------------------------------------
-- ISPIT: Ocena se ne sme smanjiti prilikom ponovnog polaganja
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_ocena_increase()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ocena < OLD.ocena THEN
        RAISE EXCEPTION 'Greška: Prilikom ponovnog polaganja, nova ocena ne sme biti manja od prethodne.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_ocena_increase ON impl.ispit;
CREATE TRIGGER trg_check_ocena_increase
BEFORE UPDATE ON impl.ispit
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_ocena_increase();

-- ------------------------------------------------------------
-- ISPIT: Programiranje i Algoritmi — samo Vanr./Red. prof.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_profesor_zvanje()
RETURNS TRIGGER AS $$
DECLARE
    v_naziv_predmeta VARCHAR;
    v_naziv_zvanja VARCHAR;
BEGIN
    SELECT p.naziv INTO v_naziv_predmeta
    FROM impl.predmet p
    WHERE p.id_predmet = NEW.id_predmet;

    SELECT z.naziv INTO v_naziv_zvanja
    FROM impl.nastavnik n
    JOIN impl.zvanje z ON n.id_zvanje = z.id_zvanje
    WHERE n.id_nastavnik = NEW.id_nastavnik;

    IF v_naziv_predmeta IN ('Programiranje', 'Algoritmi')
       AND v_naziv_zvanja NOT IN ('Vanr. prof.', 'Red. prof.') THEN
        RAISE EXCEPTION 'Greška: Predmete Programiranje i Algoritmi mogu overiti samo Redovni ili Vanredni profesori.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_profesor_zvanje ON impl.ispit;
CREATE TRIGGER trg_check_profesor_zvanje
BEFORE INSERT OR UPDATE ON impl.ispit
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_profesor_zvanje();

-- ------------------------------------------------------------
-- ISPIT: Ažuriranje prosečne ocene studenta
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_update_prosek()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE impl.student s
    SET prosecna_ocena = COALESCE((
        SELECT CAST(AVG(i.ocena) AS DECIMAL(4,2))
        FROM impl.ispit i
        WHERE i.broj_indeksa = s.broj_indeksa
    ), 0)
    WHERE s.broj_indeksa = COALESCE(NEW.broj_indeksa, OLD.broj_indeksa);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_prosek ON impl.ispit;
CREATE TRIGGER trg_update_prosek
AFTER INSERT OR UPDATE OR DELETE ON impl.ispit
FOR EACH ROW
EXECUTE FUNCTION impl.fn_update_prosek();
