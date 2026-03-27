-- ============================================================
-- RADNOMESTO — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_radnomesto_check_value_constraints(
    p_id         BIGINT,          -- NULL za INSERT, postojeći ID za UPDATE
    p_naziv      VARCHAR(22),
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_naziv IS NULL OR TRIM(p_naziv) = '' THEN
        RAISE EXCEPTION 'Greška: Naziv radnog mesta ne sme biti prazan.';
    END IF;

    IF p_naziv !~ '^[A-ZČĆŽŠĐ]' THEN
        RAISE EXCEPTION 'Greška: Naziv radnog mesta mora počinjati velikim slovom.';
    END IF;

    -- Provera jedinstvenosti naziva
    IF p_is_insert THEN
        IF EXISTS (SELECT 1 FROM impl.radno_mesto WHERE naziv = p_naziv) THEN
            RAISE EXCEPTION 'Greška: Radno mesto sa ovim nazivom već postoji u bazi.';
        END IF;
    ELSE
        IF EXISTS (SELECT 1 FROM impl.radno_mesto WHERE naziv = p_naziv AND radno_mesto_id <> p_id) THEN
            RAISE EXCEPTION 'Greška: Drugo radno mesto sa ovim nazivom već postoji u bazi.';
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- SLUZBA — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_sluzba_check_value_constraints(
    p_id         BIGINT,
    p_naziv      VARCHAR(22),
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_naziv IS NULL OR TRIM(p_naziv) = '' THEN
        RAISE EXCEPTION 'Greška: Naziv službe ne sme biti prazan.';
    END IF;

    -- Provera jedinstvenosti naziva
    IF p_is_insert THEN
        IF EXISTS (SELECT 1 FROM impl.sluzba WHERE naziv = p_naziv) THEN
            RAISE EXCEPTION 'Greška: Služba sa ovim nazivom već postoji u bazi.';
        END IF;
    ELSE
        IF EXISTS (SELECT 1 FROM impl.sluzba WHERE naziv = p_naziv AND sluzba_id <> p_id) THEN
            RAISE EXCEPTION 'Greška: Druga služba sa ovim nazivom već postoji u bazi.';
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- PROJEKAT — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_projekat_check_value_constraints(
    p_id         BIGINT,
    p_naziv      VARCHAR(50),
    p_budzet     NUMERIC,
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_naziv IS NULL OR TRIM(p_naziv) = '' THEN
        RAISE EXCEPTION 'Greška: Naziv projekta ne sme biti prazan.';
    END IF;

    IF p_naziv NOT LIKE 'PR-%' THEN
        RAISE EXCEPTION 'Greška: Naziv projekta mora počinjati sa PR- (npr. PR-MojProjekat).';
    END IF;

    IF p_budzet IS NULL OR p_budzet <= 0 THEN
        RAISE EXCEPTION 'Greška: Budžet mora biti veći od 0.';
    END IF;

    -- Provera jedinstvenosti naziva
    IF p_is_insert THEN
        IF EXISTS (SELECT 1 FROM impl.projekat WHERE naziv = p_naziv) THEN
            RAISE EXCEPTION 'Greška: Projekat sa ovim nazivom već postoji u bazi.';
        END IF;
    ELSE
        IF EXISTS (SELECT 1 FROM impl.projekat WHERE naziv = p_naziv AND projekat_id <> p_id) THEN
            RAISE EXCEPTION 'Greška: Drugi projekat sa ovim nazivom već postoji u bazi.';
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- RADNIK — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_radnik_check_value_constraints(
    p_id             BIGINT,
    p_ime            VARCHAR(22),
    p_sluzba_id      BIGINT,
    p_radno_mesto_id BIGINT,
    p_is_insert      BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_ime IS NULL OR TRIM(p_ime) = '' THEN
        RAISE EXCEPTION 'Greška: Ime radnika ne sme biti prazno.';
    END IF;

    IF p_ime !~ '^[A-ZČĆŽŠĐ]' THEN
        RAISE EXCEPTION 'Greška: Ime radnika mora počinjati velikim slovom.';
    END IF;

    IF p_sluzba_id IS NULL THEN
        RAISE EXCEPTION 'Greška: Služba je obavezna.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.sluzba WHERE sluzba_id = p_sluzba_id) THEN
        RAISE EXCEPTION 'Greška: Služba sa datim ID-jem ne postoji.';
    END IF;

    IF p_radno_mesto_id IS NULL THEN
        RAISE EXCEPTION 'Greška: Radno mesto je obavezno.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.radno_mesto WHERE radno_mesto_id = p_radno_mesto_id) THEN
        RAISE EXCEPTION 'Greška: Radno mesto sa datim ID-jem ne postoji.';
    END IF;
END;
$$;

-- ============================================================
-- ISPLATA — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_isplata_check_value_constraints(
    p_isplata_id BIGINT,          -- NULL za INSERT
    p_radnik_id  BIGINT,
    p_vrsta      VARCHAR(11),
    p_datum      DATE,
    p_iznos      NUMERIC,
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_radnik_id IS NULL THEN
        RAISE EXCEPTION 'Greška: Radnik je obavezan.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.radnik WHERE radnik_id = p_radnik_id) THEN
        RAISE EXCEPTION 'Greška: Radnik sa datim ID-jem ne postoji.';
    END IF;

    IF p_vrsta IS NULL OR p_vrsta NOT IN ('REGRES', 'BONUS', 'PLATA') THEN
        RAISE EXCEPTION 'Greška: Vrsta isplate mora biti REGRES, BONUS ili PLATA.';
    END IF;

    IF p_datum IS NULL THEN
        RAISE EXCEPTION 'Greška: Datum isplate je obavezan.';
    END IF;

    IF p_iznos IS NULL OR p_iznos <= 0 THEN
        RAISE EXCEPTION 'Greška: Iznos isplate mora biti veći od 0.';
    END IF;
END;
$$;
