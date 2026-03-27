-- ============================================================
-- ZVANJE — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_zvanje_check_value_constraints(
    p_naziv      VARCHAR(35),
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_naziv IS NULL OR TRIM(p_naziv) = '' THEN
        RAISE EXCEPTION 'Greška: Naziv zvanja ne sme biti prazan.';
    END IF;

    IF p_naziv NOT IN ('Docent', 'Vanr. prof.', 'Red. prof.') THEN
        RAISE EXCEPTION 'Greška: Naziv zvanja mora biti Docent, Vanr. prof. ili Red. prof.';
    END IF;
END;
$$;

-- ============================================================
-- PREDMET — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_predmet_check_value_constraints(
    p_id_predmet INT,          -- NULL za INSERT, postojeći ID za UPDATE
    p_naziv      VARCHAR(35),
    p_espb       SMALLINT,
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_naziv IS NULL OR TRIM(p_naziv) = '' THEN
        RAISE EXCEPTION 'Greška: Naziv predmeta ne sme biti prazan.';
    END IF;

    IF p_naziv !~ '^[A-ZČĆŽŠĐ]' THEN
        RAISE EXCEPTION 'Greška: Naziv predmeta mora počinjati velikim slovom.';
    END IF;

    IF p_espb IS NOT NULL AND p_espb <= 2 THEN
        RAISE EXCEPTION 'Greška: ESPB mora biti veći od 2.';
    END IF;

    -- Provera jedinstvenosti naziva
    IF p_is_insert THEN
        IF EXISTS (SELECT 1 FROM impl.predmet WHERE naziv = p_naziv) THEN
            RAISE EXCEPTION 'Greška: Predmet sa ovim nazivom već postoji u bazi.';
        END IF;
    ELSE
        IF EXISTS (SELECT 1 FROM impl.predmet WHERE naziv = p_naziv AND id_predmet <> p_id_predmet) THEN
            RAISE EXCEPTION 'Greška: Drugi predmet sa ovim nazivom već postoji u bazi.';
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- STUDENT — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_student_check_value_constraints(
    p_broj_indeksa   VARCHAR(7),
    p_ime            VARCHAR(22),
    p_datum_rodjenja DATE,
    p_semestar       VARCHAR(4),
    p_is_insert      BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_broj_indeksa IS NULL OR TRIM(p_broj_indeksa) = '' THEN
        RAISE EXCEPTION 'Greška: Broj indeksa ne sme biti prazan.';
    END IF;

    IF p_broj_indeksa !~ '^[0-9]{2}/[0-9]{4}$' THEN
        RAISE EXCEPTION 'Greška: Broj indeksa mora biti u formatu XX/XXXX (npr. 01/2024).';
    END IF;

    IF p_ime IS NULL OR TRIM(p_ime) = '' THEN
        RAISE EXCEPTION 'Greška: Ime studenta ne sme biti prazno.';
    END IF;

    IF p_ime !~ '^[A-ZČĆŽŠĐ]' THEN
        RAISE EXCEPTION 'Greška: Ime studenta mora počinjati velikim slovom.';
    END IF;

    IF p_datum_rodjenja IS NULL THEN
        RAISE EXCEPTION 'Greška: Datum rođenja je obavezan.';
    END IF;

    IF p_semestar IS NOT NULL AND p_semestar NOT IN ('I','II','III','IV','V','VI','VII','VIII') THEN
        RAISE EXCEPTION 'Greška: Semestar mora biti između I i VIII.';
    END IF;

    -- Provera jedinstvenosti indeksa kod unosa
    IF p_is_insert THEN
        IF EXISTS (SELECT 1 FROM impl.student WHERE broj_indeksa = p_broj_indeksa) THEN
            RAISE EXCEPTION 'Greška: Student sa ovim brojem indeksa već postoji.';
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- NASTAVNIK — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_nastavnik_check_value_constraints(
    p_ime        VARCHAR(22),
    p_id_zvanje  INT,
    p_is_insert  BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_ime IS NULL OR TRIM(p_ime) = '' THEN
        RAISE EXCEPTION 'Greška: Ime nastavnika ne sme biti prazno.';
    END IF;

    IF p_ime !~ '^[A-ZČĆŽŠĐ]' THEN
        RAISE EXCEPTION 'Greška: Ime nastavnika mora počinjati velikim slovom.';
    END IF;

    IF p_id_zvanje IS NULL THEN
        RAISE EXCEPTION 'Greška: Zvanje je obavezno.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.zvanje WHERE id_zvanje = p_id_zvanje) THEN
        RAISE EXCEPTION 'Greška: Zvanje sa datim ID-jem ne postoji.';
    END IF;
END;
$$;

-- ============================================================
-- ISPIT — CheckValueConstraints
-- ============================================================
CREATE OR REPLACE FUNCTION spec.spr_ispit_check_value_constraints(
    p_id_ispit       INT,          -- NULL za INSERT
    p_ocena          SMALLINT,
    p_datum_polaganja DATE,
    p_broj_indeksa   VARCHAR(7),
    p_id_predmet     INT,
    p_id_nastavnik   INT,
    p_is_insert      BOOLEAN DEFAULT FALSE
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    IF p_ocena < 6 OR p_ocena > 10 THEN
        RAISE EXCEPTION 'Greška: Ocena mora biti između 6 i 10.';
    END IF;

    IF p_datum_polaganja IS NULL THEN
        RAISE EXCEPTION 'Greška: Datum polaganja je obavezan.';
    END IF;

    IF p_datum_polaganja > CURRENT_DATE THEN
        RAISE EXCEPTION 'Greška: Datum polaganja ne može biti u budućnosti.';
    END IF;

    IF p_broj_indeksa IS NULL OR TRIM(p_broj_indeksa) = '' THEN
        RAISE EXCEPTION 'Greška: Broj indeksa je obavezan.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.student WHERE broj_indeksa = p_broj_indeksa) THEN
        RAISE EXCEPTION 'Greška: Student sa datim brojem indeksa ne postoji.';
    END IF;

    IF p_id_predmet IS NULL THEN
        RAISE EXCEPTION 'Greška: Predmet je obavezan.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.predmet WHERE id_predmet = p_id_predmet) THEN
        RAISE EXCEPTION 'Greška: Predmet sa datim ID-jem ne postoji.';
    END IF;

    IF p_id_nastavnik IS NULL THEN
        RAISE EXCEPTION 'Greška: Nastavnik je obavezan.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM impl.nastavnik WHERE id_nastavnik = p_id_nastavnik) THEN
        RAISE EXCEPTION 'Greška: Nastavnik sa datim ID-jem ne postoji.';
    END IF;

    -- Jedinstvenost kombinacije Student+Predmet
    IF p_is_insert THEN
        IF EXISTS (SELECT 1 FROM impl.ispit WHERE broj_indeksa = p_broj_indeksa AND id_predmet = p_id_predmet) THEN
            RAISE EXCEPTION 'Greška: Student već ima upisan ispit iz ovog predmeta.';
        END IF;
    ELSE
        IF EXISTS (SELECT 1 FROM impl.ispit WHERE broj_indeksa = p_broj_indeksa AND id_predmet = p_id_predmet AND id_ispit <> p_id_ispit) THEN
            RAISE EXCEPTION 'Greška: Drugi ispit sa istom kombinacijom studenta i predmeta već postoji.';
        END IF;
    END IF;
END;
$$;
