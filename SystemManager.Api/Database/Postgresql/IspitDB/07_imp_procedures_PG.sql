-- ============================================================
-- ZVANJE
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_zvanje_insert(
    p_naziv VARCHAR(35)
)
RETURNS INT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id INT;
BEGIN
    PERFORM spec.spr_zvanje_check_value_constraints(p_naziv := p_naziv, p_is_insert := TRUE);

    INSERT INTO impl.zvanje (naziv) VALUES (p_naziv)
    RETURNING id_zvanje INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_zvanje_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_zvanje_update(
    p_id_zvanje INT,
    p_naziv     VARCHAR(35)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_zvanje_check_value_constraints(p_naziv := p_naziv, p_is_insert := FALSE);

    UPDATE impl.zvanje SET naziv = p_naziv WHERE id_zvanje = p_id_zvanje;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_zvanje_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_zvanje_delete(
    p_id_zvanje INT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.zvanje WHERE id_zvanje = p_id_zvanje;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_zvanje_delete');
    RAISE;
END;
$$;

-- ============================================================
-- PREDMET
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_predmet_insert(
    p_naziv VARCHAR(35),
    p_espb  SMALLINT DEFAULT 4
)
RETURNS INT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id INT;
BEGIN
    PERFORM spec.spr_predmet_check_value_constraints(
        p_id_predmet := NULL, p_naziv := p_naziv, p_espb := p_espb, p_is_insert := TRUE);

    INSERT INTO impl.predmet (naziv, espb) VALUES (p_naziv, p_espb)
    RETURNING id_predmet INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_predmet_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_predmet_update(
    p_id_predmet INT,
    p_naziv      VARCHAR(35),
    p_espb       SMALLINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_predmet_check_value_constraints(
        p_id_predmet := p_id_predmet, p_naziv := p_naziv, p_espb := p_espb, p_is_insert := FALSE);

    UPDATE impl.predmet SET naziv = p_naziv, espb = p_espb WHERE id_predmet = p_id_predmet;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_predmet_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_predmet_delete(
    p_id_predmet INT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.predmet WHERE id_predmet = p_id_predmet;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_predmet_delete');
    RAISE;
END;
$$;

-- ============================================================
-- STUDENT
-- ============================================================

-- INSERT (broj_indeksa je prirodni ključ — ne vraća ID)
CREATE OR REPLACE FUNCTION spec.spr_student_insert(
    p_broj_indeksa   VARCHAR(7),
    p_ime            VARCHAR(22),
    p_datum_rodjenja DATE,
    p_semestar       VARCHAR(4)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_student_check_value_constraints(
        p_broj_indeksa := p_broj_indeksa, p_ime := p_ime,
        p_datum_rodjenja := p_datum_rodjenja, p_semestar := p_semestar, p_is_insert := TRUE);

    INSERT INTO impl.student (broj_indeksa, ime, datum_rodjenja, semestar)
    VALUES (p_broj_indeksa, p_ime, p_datum_rodjenja, p_semestar);
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_student_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_student_update(
    p_broj_indeksa   VARCHAR(7),
    p_ime            VARCHAR(22),
    p_datum_rodjenja DATE,
    p_semestar       VARCHAR(4)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_student_check_value_constraints(
        p_broj_indeksa := p_broj_indeksa, p_ime := p_ime,
        p_datum_rodjenja := p_datum_rodjenja, p_semestar := p_semestar, p_is_insert := FALSE);

    UPDATE impl.student
    SET ime = p_ime, datum_rodjenja = p_datum_rodjenja, semestar = p_semestar
    WHERE broj_indeksa = p_broj_indeksa;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_student_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_student_delete(
    p_broj_indeksa VARCHAR(7)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.student WHERE broj_indeksa = p_broj_indeksa;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_student_delete');
    RAISE;
END;
$$;

-- ============================================================
-- NASTAVNIK
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_nastavnik_insert(
    p_ime       VARCHAR(22),
    p_id_zvanje INT
)
RETURNS INT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id INT;
BEGIN
    PERFORM spec.spr_nastavnik_check_value_constraints(
        p_ime := p_ime, p_id_zvanje := p_id_zvanje, p_is_insert := TRUE);

    INSERT INTO impl.nastavnik (ime, id_zvanje) VALUES (p_ime, p_id_zvanje)
    RETURNING id_nastavnik INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_nastavnik_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_nastavnik_update(
    p_id_nastavnik INT,
    p_ime          VARCHAR(22),
    p_id_zvanje    INT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_nastavnik_check_value_constraints(
        p_ime := p_ime, p_id_zvanje := p_id_zvanje, p_is_insert := FALSE);

    UPDATE impl.nastavnik SET ime = p_ime, id_zvanje = p_id_zvanje WHERE id_nastavnik = p_id_nastavnik;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_nastavnik_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_nastavnik_delete(
    p_id_nastavnik INT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.nastavnik WHERE id_nastavnik = p_id_nastavnik;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_nastavnik_delete');
    RAISE;
END;
$$;

-- ============================================================
-- ISPIT
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_ispit_insert(
    p_ocena          SMALLINT,
    p_datum_polaganja DATE,
    p_broj_indeksa   VARCHAR(7),
    p_id_predmet     INT,
    p_id_nastavnik   INT
)
RETURNS INT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id INT;
BEGIN
    PERFORM spec.spr_ispit_check_value_constraints(
        p_id_ispit := NULL, p_ocena := p_ocena, p_datum_polaganja := p_datum_polaganja,
        p_broj_indeksa := p_broj_indeksa, p_id_predmet := p_id_predmet, p_id_nastavnik := p_id_nastavnik,
        p_is_insert := TRUE);

    INSERT INTO impl.ispit (ocena, datum_polaganja, broj_indeksa, id_predmet, id_nastavnik)
    VALUES (p_ocena, p_datum_polaganja, p_broj_indeksa, p_id_predmet, p_id_nastavnik)
    RETURNING id_ispit INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_ispit_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_ispit_update(
    p_id_ispit       INT,
    p_ocena          SMALLINT,
    p_datum_polaganja DATE,
    p_broj_indeksa   VARCHAR(7),
    p_id_predmet     INT,
    p_id_nastavnik   INT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_ispit_check_value_constraints(
        p_id_ispit := p_id_ispit, p_ocena := p_ocena, p_datum_polaganja := p_datum_polaganja,
        p_broj_indeksa := p_broj_indeksa, p_id_predmet := p_id_predmet, p_id_nastavnik := p_id_nastavnik,
        p_is_insert := FALSE);

    UPDATE impl.ispit
    SET ocena = p_ocena, datum_polaganja = p_datum_polaganja,
        broj_indeksa = p_broj_indeksa, id_predmet = p_id_predmet, id_nastavnik = p_id_nastavnik
    WHERE id_ispit = p_id_ispit;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_ispit_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_ispit_delete(
    p_id_ispit INT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.ispit WHERE id_ispit = p_id_ispit;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_ispit_delete');
    RAISE;
END;
$$;

-- ============================================================
-- READ FUNCTIONS (spec layer — called by api wrappers)
-- ============================================================

-- ============================================================
-- ZVANJE — Read
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_zvanje_getall()
RETURNS TABLE(id_zvanje INT, naziv VARCHAR)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT id_zvanje, naziv
    FROM impl.zvanje
    ORDER BY id_zvanje;
$$;

CREATE OR REPLACE FUNCTION spec.spr_zvanje_getbyid(p_id_zvanje INT)
RETURNS TABLE(id_zvanje INT, naziv VARCHAR)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT id_zvanje, naziv
    FROM impl.zvanje
    WHERE id_zvanje = p_id_zvanje;
$$;

-- ============================================================
-- PREDMET — Read
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_predmet_getall()
RETURNS TABLE(id_predmet INT, naziv VARCHAR, espb SMALLINT)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT id_predmet, naziv, espb
    FROM impl.predmet
    ORDER BY naziv;
$$;

CREATE OR REPLACE FUNCTION spec.spr_predmet_getbyid(p_id_predmet INT)
RETURNS TABLE(id_predmet INT, naziv VARCHAR, espb SMALLINT)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT id_predmet, naziv, espb
    FROM impl.predmet
    WHERE id_predmet = p_id_predmet;
$$;

-- ============================================================
-- STUDENT — Read (koristi impl.v_student pogled za kolonu starost)
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_student_getall()
RETURNS TABLE(
    broj_indeksa VARCHAR,
    ime VARCHAR,
    datum_rodjenja DATE,
    semestar VARCHAR,
    starost INT,
    prosecna_ocena DECIMAL
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        broj_indeksa,
        ime,
        datum_rodjenja,
        semestar,
        starost,
        prosecna_ocena
    FROM impl.v_student
    ORDER BY broj_indeksa ASC;
$$;

CREATE OR REPLACE FUNCTION spec.spr_student_getbyid(p_broj_indeksa VARCHAR)
RETURNS TABLE(
    broj_indeksa VARCHAR,
    ime VARCHAR,
    datum_rodjenja DATE,
    semestar VARCHAR,
    starost INT,
    prosecna_ocena DECIMAL
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        broj_indeksa,
        ime,
        datum_rodjenja,
        semestar,
        starost,
        prosecna_ocena
    FROM impl.v_student
    WHERE broj_indeksa = p_broj_indeksa;
$$;

-- ============================================================
-- NASTAVNIK — Read (sa JOIN na Zvanje za navigacioni property)
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_nastavnik_getall()
RETURNS TABLE(
    id_nastavnik INT,
    ime VARCHAR,
    id_zvanje INT,          -- Kraj Nastavnik dela
    id_zvanje_z INT,        -- Pochetak Zvanje dela (splitOn)
    naziv VARCHAR
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        n.id_nastavnik,
        n.ime,
        n.id_zvanje,        -- Kraj Nastavnik dela
        z.id_zvanje,        -- Pochetak Zvanje dela (splitOn)
        z.naziv
    FROM impl.nastavnik n
    INNER JOIN impl.zvanje z ON n.id_zvanje = z.id_zvanje
    ORDER BY n.ime ASC;
$$;

CREATE OR REPLACE FUNCTION spec.spr_nastavnik_getbyid(p_id_nastavnik INT)
RETURNS TABLE(
    id_nastavnik INT,
    ime VARCHAR,
    id_zvanje INT,
    id_zvanje_z INT,
    naziv VARCHAR
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        n.id_nastavnik,
        n.ime,
        n.id_zvanje,        -- Kraj Nastavnik dela
        z.id_zvanje,        -- Pochetak Zvanje dela (splitOn)
        z.naziv
    FROM impl.nastavnik n
    INNER JOIN impl.zvanje z ON n.id_zvanje = z.id_zvanje
    WHERE n.id_nastavnik = p_id_nastavnik;
$$;

-- ============================================================
-- ISPIT — Read (sa JOIN na Student, Nastavnik, Zvanje, Predmet)
-- Redosled kolona identican postojecem za Dapper multi-mapping
-- splitOn: "s_broj_indeksa,n_id_nastavnik,z_id_zvanje,id_predmet"
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_ispit_getall(p_broj_indeksa VARCHAR DEFAULT NULL)
RETURNS TABLE(
    -- 1. ISPIT
    id_ispit INT,
    ocena SMALLINT,
    datum_polaganja DATE,
    broj_indeksa VARCHAR,
    i_id_predmet INT,
    id_nastavnik INT,
    -- 2. STUDENT
    s_broj_indeksa VARCHAR,
    s_ime VARCHAR,
    datum_rodjenja DATE,
    semestar VARCHAR,
    starost INT,
    prosecna_ocena DECIMAL,
    -- 3. NASTAVNIK
    n_id_nastavnik INT,
    ime VARCHAR,
    id_zvanje INT,
    -- 4. ZVANJE
    z_id_zvanje INT,
    naziv VARCHAR,
    -- 5. PREDMET
    id_predmet INT,
    p_naziv VARCHAR,
    espb SMALLINT
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        -- 1. ISPIT
        i.id_ispit,
        i.ocena,
        i.datum_polaganja,
        i.broj_indeksa,
        i.id_predmet,
        i.id_nastavnik,
        -- 2. STUDENT
        s.broj_indeksa,
        s.ime,
        s.datum_rodjenja,
        s.semestar,
        s.starost,
        s.prosecna_ocena,
        -- 3. NASTAVNIK
        n.id_nastavnik,
        n.ime,
        n.id_zvanje,
        -- 4. ZVANJE
        z.id_zvanje,
        z.naziv,
        -- 5. PREDMET
        p.id_predmet,
        p.naziv,
        p.espb
    FROM impl.ispit i
    INNER JOIN impl.v_student s ON i.broj_indeksa = s.broj_indeksa
    INNER JOIN impl.nastavnik n ON i.id_nastavnik = n.id_nastavnik
    INNER JOIN impl.zvanje z ON n.id_zvanje = z.id_zvanje
    INNER JOIN impl.predmet p ON i.id_predmet = p.id_predmet
    WHERE (p_broj_indeksa IS NULL OR i.broj_indeksa = p_broj_indeksa)
    ORDER BY i.datum_polaganja DESC;
$$;

CREATE OR REPLACE FUNCTION spec.spr_ispit_getbyid(p_id_ispit INT)
RETURNS TABLE(
    -- 1. ISPIT
    id_ispit INT,
    ocena SMALLINT,
    datum_polaganja DATE,
    broj_indeksa VARCHAR,
    i_id_predmet INT,
    id_nastavnik INT,
    -- 2. STUDENT
    s_broj_indeksa VARCHAR,
    s_ime VARCHAR,
    datum_rodjenja DATE,
    semestar VARCHAR,
    starost INT,
    prosecna_ocena DECIMAL,
    -- 3. NASTAVNIK
    n_id_nastavnik INT,
    ime VARCHAR,
    id_zvanje INT,
    -- 4. ZVANJE
    z_id_zvanje INT,
    naziv VARCHAR,
    -- 5. PREDMET
    id_predmet INT,
    p_naziv VARCHAR,
    espb SMALLINT
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        -- 1. ISPIT
        i.id_ispit,
        i.ocena,
        i.datum_polaganja,
        i.broj_indeksa,
        i.id_predmet,
        i.id_nastavnik,
        -- 2. STUDENT
        s.broj_indeksa,
        s.ime,
        s.datum_rodjenja,
        s.semestar,
        s.starost,
        s.prosecna_ocena,
        -- 3. NASTAVNIK
        n.id_nastavnik,
        n.ime,
        n.id_zvanje,
        -- 4. ZVANJE
        z.id_zvanje,
        z.naziv,
        -- 5. PREDMET
        p.id_predmet,
        p.naziv,
        p.espb
    FROM impl.ispit i
    INNER JOIN impl.v_student s ON i.broj_indeksa = s.broj_indeksa
    INNER JOIN impl.nastavnik n ON i.id_nastavnik = n.id_nastavnik
    INNER JOIN impl.zvanje z ON n.id_zvanje = z.id_zvanje
    INNER JOIN impl.predmet p ON i.id_predmet = p.id_predmet
    WHERE i.id_ispit = p_id_ispit;
$$;
