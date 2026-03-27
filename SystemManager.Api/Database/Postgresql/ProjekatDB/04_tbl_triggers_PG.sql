-- ============================================================
-- AUDIT TRIGERI
-- ============================================================

-- ------------------------------------------------------------
-- SLUZBA — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_sluzba_audit()
RETURNS TRIGGER AS $$
BEGIN
    -- DELETE: stare vrednosti
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.sluzba_audit (action_type, sluzba_id, naziv)
        VALUES ('DEL', OLD.sluzba_id, OLD.naziv);
        RETURN OLD;
    END IF;

    -- INSERT: nove vrednosti
    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.sluzba_audit (action_type, sluzba_id, naziv)
        VALUES ('INS', NEW.sluzba_id, NEW.naziv);
        RETURN NEW;
    END IF;

    -- UPDATE: dva reda — stare pa nove vrednosti
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.sluzba_audit (action_type, sluzba_id, naziv)
        VALUES ('UPD', OLD.sluzba_id, OLD.naziv);

        INSERT INTO impl.sluzba_audit (action_type, sluzba_id, naziv)
        VALUES ('UPD', NEW.sluzba_id, NEW.naziv);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sluzba_audit ON impl.sluzba;
CREATE TRIGGER trg_sluzba_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.sluzba
FOR EACH ROW
EXECUTE FUNCTION impl.fn_sluzba_audit();

-- ------------------------------------------------------------
-- RADNO_MESTO — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_radno_mesto_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.radno_mesto_audit (action_type, radno_mesto_id, naziv)
        VALUES ('DEL', OLD.radno_mesto_id, OLD.naziv);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.radno_mesto_audit (action_type, radno_mesto_id, naziv)
        VALUES ('INS', NEW.radno_mesto_id, NEW.naziv);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.radno_mesto_audit (action_type, radno_mesto_id, naziv)
        VALUES ('UPD', OLD.radno_mesto_id, OLD.naziv);

        INSERT INTO impl.radno_mesto_audit (action_type, radno_mesto_id, naziv)
        VALUES ('UPD', NEW.radno_mesto_id, NEW.naziv);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_radno_mesto_audit ON impl.radno_mesto;
CREATE TRIGGER trg_radno_mesto_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.radno_mesto
FOR EACH ROW
EXECUTE FUNCTION impl.fn_radno_mesto_audit();

-- ------------------------------------------------------------
-- PROJEKAT — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_projekat_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.projekat_audit (action_type, projekat_id, naziv, budzet, klasa)
        VALUES ('DEL', OLD.projekat_id, OLD.naziv, OLD.budzet, OLD.klasa);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.projekat_audit (action_type, projekat_id, naziv, budzet, klasa)
        VALUES ('INS', NEW.projekat_id, NEW.naziv, NEW.budzet, NEW.klasa);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.projekat_audit (action_type, projekat_id, naziv, budzet, klasa)
        VALUES ('UPD', OLD.projekat_id, OLD.naziv, OLD.budzet, OLD.klasa);

        INSERT INTO impl.projekat_audit (action_type, projekat_id, naziv, budzet, klasa)
        VALUES ('UPD', NEW.projekat_id, NEW.naziv, NEW.budzet, NEW.klasa);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_projekat_audit ON impl.projekat;
CREATE TRIGGER trg_projekat_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.projekat
FOR EACH ROW
EXECUTE FUNCTION impl.fn_projekat_audit();

-- ------------------------------------------------------------
-- RADNIK — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_radnik_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.radnik_audit (action_type, radnik_id, ime, sluzba_id, radno_mesto_id)
        VALUES ('DEL', OLD.radnik_id, OLD.ime, OLD.sluzba_id, OLD.radno_mesto_id);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.radnik_audit (action_type, radnik_id, ime, sluzba_id, radno_mesto_id)
        VALUES ('INS', NEW.radnik_id, NEW.ime, NEW.sluzba_id, NEW.radno_mesto_id);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.radnik_audit (action_type, radnik_id, ime, sluzba_id, radno_mesto_id)
        VALUES ('UPD', OLD.radnik_id, OLD.ime, OLD.sluzba_id, OLD.radno_mesto_id);

        INSERT INTO impl.radnik_audit (action_type, radnik_id, ime, sluzba_id, radno_mesto_id)
        VALUES ('UPD', NEW.radnik_id, NEW.ime, NEW.sluzba_id, NEW.radno_mesto_id);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_radnik_audit ON impl.radnik;
CREATE TRIGGER trg_radnik_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.radnik
FOR EACH ROW
EXECUTE FUNCTION impl.fn_radnik_audit();

-- ------------------------------------------------------------
-- ISPLATA — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_isplata_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.isplata_audit (action_type, radnik_id, isplata_id, datum, iznos, vrsta)
        VALUES ('DEL', OLD.radnik_id, OLD.isplata_id, OLD.datum, OLD.iznos, OLD.vrsta);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.isplata_audit (action_type, radnik_id, isplata_id, datum, iznos, vrsta)
        VALUES ('INS', NEW.radnik_id, NEW.isplata_id, NEW.datum, NEW.iznos, NEW.vrsta);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.isplata_audit (action_type, radnik_id, isplata_id, datum, iznos, vrsta)
        VALUES ('UPD', OLD.radnik_id, OLD.isplata_id, OLD.datum, OLD.iznos, OLD.vrsta);

        INSERT INTO impl.isplata_audit (action_type, radnik_id, isplata_id, datum, iznos, vrsta)
        VALUES ('UPD', NEW.radnik_id, NEW.isplata_id, NEW.datum, NEW.iznos, NEW.vrsta);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_isplata_audit ON impl.isplata;
CREATE TRIGGER trg_isplata_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.isplata
FOR EACH ROW
EXECUTE FUNCTION impl.fn_isplata_audit();

-- ------------------------------------------------------------
-- UCESTVUJE — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_ucestvuje_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.ucestvuje_audit (action_type, ucestvuje_id, datum_od, datum_do, radnik_id, projekat_id)
        VALUES ('DEL', OLD.ucestvuje_id, OLD.datum_od, OLD.datum_do, OLD.radnik_id, OLD.projekat_id);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.ucestvuje_audit (action_type, ucestvuje_id, datum_od, datum_do, radnik_id, projekat_id)
        VALUES ('INS', NEW.ucestvuje_id, NEW.datum_od, NEW.datum_do, NEW.radnik_id, NEW.projekat_id);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.ucestvuje_audit (action_type, ucestvuje_id, datum_od, datum_do, radnik_id, projekat_id)
        VALUES ('UPD', OLD.ucestvuje_id, OLD.datum_od, OLD.datum_do, OLD.radnik_id, OLD.projekat_id);

        INSERT INTO impl.ucestvuje_audit (action_type, ucestvuje_id, datum_od, datum_do, radnik_id, projekat_id)
        VALUES ('UPD', NEW.ucestvuje_id, NEW.datum_od, NEW.datum_do, NEW.radnik_id, NEW.projekat_id);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_ucestvuje_audit ON impl.ucestvuje;
CREATE TRIGGER trg_ucestvuje_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.ucestvuje
FOR EACH ROW
EXECUTE FUNCTION impl.fn_ucestvuje_audit();

-- ------------------------------------------------------------
-- RUKOVODI — Audit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_rukovodi_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO impl.rukovodi_audit (action_type, rukovodi_id, radnik_id, projekat_id)
        VALUES ('DEL', OLD.rukovodi_id, OLD.radnik_id, OLD.projekat_id);
        RETURN OLD;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO impl.rukovodi_audit (action_type, rukovodi_id, radnik_id, projekat_id)
        VALUES ('INS', NEW.rukovodi_id, NEW.radnik_id, NEW.projekat_id);
        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        INSERT INTO impl.rukovodi_audit (action_type, rukovodi_id, radnik_id, projekat_id)
        VALUES ('UPD', OLD.rukovodi_id, OLD.radnik_id, OLD.projekat_id);

        INSERT INTO impl.rukovodi_audit (action_type, rukovodi_id, radnik_id, projekat_id)
        VALUES ('UPD', NEW.rukovodi_id, NEW.radnik_id, NEW.projekat_id);
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_rukovodi_audit ON impl.rukovodi;
CREATE TRIGGER trg_rukovodi_audit
AFTER INSERT OR UPDATE OR DELETE ON impl.rukovodi
FOR EACH ROW
EXECUTE FUNCTION impl.fn_rukovodi_audit();

-- ============================================================
-- POSLOVNI TRIGERI (business logic — preneseni iz postojeće šeme)
-- ============================================================

-- ------------------------------------------------------------
-- PROJEKAT: Automatska klasifikacija po budžetu
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_auto_klasifikacija()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.budzet <= 1000 THEN
        NEW.klasa := 3;
    ELSIF NEW.budzet > 1000 AND NEW.budzet <= 5000 THEN
        NEW.klasa := 2;
    ELSE
        NEW.klasa := 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_klasifikacija ON impl.projekat;
CREATE TRIGGER trg_auto_klasifikacija
BEFORE INSERT OR UPDATE OF budzet ON impl.projekat
FOR EACH ROW
EXECUTE FUNCTION impl.fn_auto_klasifikacija();

-- ------------------------------------------------------------
-- PROJEKAT: Kontrola promene budžeta (maksimalno ±12%)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_budzet_promena()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.budzet < OLD.budzet * 0.88 OR NEW.budzet > OLD.budzet * 1.12 THEN
        RAISE EXCEPTION 'Nije dozvoljena promena budžeta veća od +/- 12%%.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_budzet_promena ON impl.projekat;
CREATE TRIGGER trg_check_budzet_promena
BEFORE UPDATE OF budzet ON impl.projekat
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_budzet_promena();

-- ------------------------------------------------------------
-- RUKOVODI: Validacija rukovodioca (radno mesto i učešće)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_rukovodilac()
RETURNS TRIGGER AS $$
DECLARE
    v_naziv_rm VARCHAR;
    v_ucesnik BOOLEAN;
BEGIN
    SELECT rm.naziv INTO v_naziv_rm
    FROM impl.radnik r
    JOIN impl.radno_mesto rm ON r.radno_mesto_id = rm.radno_mesto_id
    WHERE r.radnik_id = NEW.radnik_id;

    IF v_naziv_rm IS NULL THEN
        RAISE EXCEPTION 'Projektom može rukovoditi samo radnik sa radnog mesta ŠEF ili NAČELNIK.';
    END IF;

    IF UPPER(v_naziv_rm) NOT IN ('ŠEF', 'NAČELNIK') THEN
        RAISE EXCEPTION 'Projektom može rukovoditi samo radnik sa radnog mesta ŠEF ili NAČELNIK.';
    END IF;

    SELECT EXISTS(
        SELECT 1 FROM impl.ucestvuje u
        WHERE u.radnik_id = NEW.radnik_id AND u.projekat_id = NEW.projekat_id
    ) INTO v_ucesnik;

    IF NOT v_ucesnik THEN
        RAISE EXCEPTION 'Radnik ne može rukovoditi projektom ako na njemu ne učestvuje.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_rukovodilac ON impl.rukovodi;
CREATE TRIGGER trg_check_rukovodilac
BEFORE INSERT OR UPDATE ON impl.rukovodi
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_rukovodilac();

-- ------------------------------------------------------------
-- ISPLATA: Limiti isplata (maks. 3 dnevno, 500 n.j. mesečno)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_isplata_limiti()
RETURNS TRIGGER AS $$
DECLARE
    v_cnt_dnevni INT;
    v_sum_mesecni NUMERIC;
BEGIN
    SELECT COUNT(*) INTO v_cnt_dnevni
    FROM impl.isplata
    WHERE radnik_id = NEW.radnik_id AND datum = NEW.datum
      AND (TG_OP = 'INSERT' OR isplata_id IS DISTINCT FROM NEW.isplata_id);

    IF v_cnt_dnevni >= 3 THEN
        RAISE EXCEPTION 'Radnik ne može imati više od tri isplate u istom danu.';
    END IF;

    SELECT COALESCE(SUM(iznos), 0) INTO v_sum_mesecni
    FROM impl.isplata
    WHERE radnik_id = NEW.radnik_id
      AND EXTRACT(MONTH FROM datum) = EXTRACT(MONTH FROM NEW.datum)
      AND EXTRACT(YEAR FROM datum) = EXTRACT(YEAR FROM NEW.datum)
      AND (TG_OP = 'INSERT' OR isplata_id IS DISTINCT FROM NEW.isplata_id);

    IF (v_sum_mesecni + NEW.iznos) > 500 THEN
        RAISE EXCEPTION 'Mesečna suma isplata radniku ne sme preći 500 n.j.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_isplata_limiti ON impl.isplata;
CREATE TRIGGER trg_check_isplata_limiti
BEFORE INSERT OR UPDATE ON impl.isplata
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_isplata_limiti();

-- ------------------------------------------------------------
-- UCESTVUJE: Restrikcija za službu Računovodstvo
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION impl.fn_check_racunovodstvo()
RETURNS TRIGGER AS $$
DECLARE
    v_sluzba VARCHAR;
BEGIN
    SELECT s.naziv INTO v_sluzba
    FROM impl.radnik r
    JOIN impl.sluzba s ON r.sluzba_id = s.sluzba_id
    WHERE r.radnik_id = NEW.radnik_id;

    IF UPPER(v_sluzba) = 'RAČUNOVODSTVO' THEN
        RAISE EXCEPTION 'Radnici službe RAČUNOVODSTVO ne mogu učestvovati na projektima.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_racunovodstvo ON impl.ucestvuje;
CREATE TRIGGER trg_check_racunovodstvo
BEFORE INSERT OR UPDATE ON impl.ucestvuje
FOR EACH ROW
EXECUTE FUNCTION impl.fn_check_racunovodstvo();
