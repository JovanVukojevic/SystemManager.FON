-- ============================================================
-- RADNOMESTO
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_radnomesto_insert(
    p_naziv VARCHAR(22)
)
RETURNS BIGINT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id BIGINT;
BEGIN
    PERFORM spec.spr_radnomesto_check_value_constraints(
        p_id := NULL, p_naziv := p_naziv, p_is_insert := TRUE);

    INSERT INTO impl.radno_mesto (naziv) VALUES (p_naziv)
    RETURNING radno_mesto_id INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_radnomesto_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_radnomesto_update(
    p_id    BIGINT,
    p_naziv VARCHAR(22)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_radnomesto_check_value_constraints(
        p_id := p_id, p_naziv := p_naziv, p_is_insert := FALSE);

    UPDATE impl.radno_mesto SET naziv = p_naziv WHERE radno_mesto_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_radnomesto_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_radnomesto_delete(
    p_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.radno_mesto WHERE radno_mesto_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_radnomesto_delete');
    RAISE;
END;
$$;

-- ============================================================
-- SLUZBA
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_sluzba_insert(
    p_naziv VARCHAR(22)
)
RETURNS BIGINT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id BIGINT;
BEGIN
    PERFORM spec.spr_sluzba_check_value_constraints(
        p_id := NULL, p_naziv := p_naziv, p_is_insert := TRUE);

    INSERT INTO impl.sluzba (naziv) VALUES (p_naziv)
    RETURNING sluzba_id INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_sluzba_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_sluzba_update(
    p_id    BIGINT,
    p_naziv VARCHAR(22)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_sluzba_check_value_constraints(
        p_id := p_id, p_naziv := p_naziv, p_is_insert := FALSE);

    UPDATE impl.sluzba SET naziv = p_naziv WHERE sluzba_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_sluzba_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_sluzba_delete(
    p_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.sluzba WHERE sluzba_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_sluzba_delete');
    RAISE;
END;
$$;

-- ============================================================
-- PROJEKAT
-- ============================================================

-- INSERT (klasa se NE prosleđuje — BEFORE triger ga postavlja)
CREATE OR REPLACE FUNCTION spec.spr_projekat_insert(
    p_naziv  VARCHAR(50),
    p_budzet NUMERIC
)
RETURNS BIGINT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id BIGINT;
BEGIN
    PERFORM spec.spr_projekat_check_value_constraints(
        p_id := NULL, p_naziv := p_naziv, p_budzet := p_budzet, p_is_insert := TRUE);

    INSERT INTO impl.projekat (naziv, budzet, klasa)
    VALUES (p_naziv, p_budzet, 1)
    RETURNING projekat_id INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_projekat_insert');
    RAISE;
END;
$$;

-- UPDATE (klasa se NE prosleđuje — triger ga ažurira pri promeni budžeta)
CREATE OR REPLACE FUNCTION spec.spr_projekat_update(
    p_id     BIGINT,
    p_naziv  VARCHAR(50),
    p_budzet NUMERIC
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_projekat_check_value_constraints(
        p_id := p_id, p_naziv := p_naziv, p_budzet := p_budzet, p_is_insert := FALSE);

    UPDATE impl.projekat SET naziv = p_naziv, budzet = p_budzet WHERE projekat_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_projekat_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_projekat_delete(
    p_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.projekat WHERE projekat_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_projekat_delete');
    RAISE;
END;
$$;

-- ============================================================
-- RADNIK
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_radnik_insert(
    p_ime            VARCHAR(22),
    p_sluzba_id      BIGINT,
    p_radno_mesto_id BIGINT
)
RETURNS BIGINT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id BIGINT;
BEGIN
    PERFORM spec.spr_radnik_check_value_constraints(
        p_id := NULL, p_ime := p_ime, p_sluzba_id := p_sluzba_id,
        p_radno_mesto_id := p_radno_mesto_id, p_is_insert := TRUE);

    INSERT INTO impl.radnik (ime, sluzba_id, radno_mesto_id)
    VALUES (p_ime, p_sluzba_id, p_radno_mesto_id)
    RETURNING radnik_id INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_radnik_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_radnik_update(
    p_id             BIGINT,
    p_ime            VARCHAR(22),
    p_sluzba_id      BIGINT,
    p_radno_mesto_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_radnik_check_value_constraints(
        p_id := p_id, p_ime := p_ime, p_sluzba_id := p_sluzba_id,
        p_radno_mesto_id := p_radno_mesto_id, p_is_insert := FALSE);

    UPDATE impl.radnik
    SET ime = p_ime, sluzba_id = p_sluzba_id, radno_mesto_id = p_radno_mesto_id
    WHERE radnik_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_radnik_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_radnik_delete(
    p_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.radnik WHERE radnik_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_radnik_delete');
    RAISE;
END;
$$;

-- ============================================================
-- ISPLATA (slab entitet — RadnikId dolazi iz rute)
-- ============================================================

-- INSERT (vraća IsplataId — RadnikId je ulazni parametar)
CREATE OR REPLACE FUNCTION spec.spr_isplata_insert(
    p_radnik_id BIGINT,
    p_datum     DATE,
    p_iznos     NUMERIC,
    p_vrsta     VARCHAR(11)
)
RETURNS BIGINT
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id BIGINT;
BEGIN
    PERFORM spec.spr_isplata_check_value_constraints(
        p_isplata_id := NULL, p_radnik_id := p_radnik_id,
        p_vrsta := p_vrsta, p_datum := p_datum, p_iznos := p_iznos, p_is_insert := TRUE);

    INSERT INTO impl.isplata (radnik_id, datum, iznos, vrsta)
    VALUES (p_radnik_id, p_datum, p_iznos, p_vrsta)
    RETURNING isplata_id INTO v_id;

    RETURN v_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_isplata_insert');
    RAISE;
END;
$$;

-- UPDATE
CREATE OR REPLACE FUNCTION spec.spr_isplata_update(
    p_id        BIGINT,
    p_radnik_id BIGINT,
    p_datum     DATE,
    p_iznos     NUMERIC,
    p_vrsta     VARCHAR(11)
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    PERFORM spec.spr_isplata_check_value_constraints(
        p_isplata_id := p_id, p_radnik_id := p_radnik_id,
        p_vrsta := p_vrsta, p_datum := p_datum, p_iznos := p_iznos, p_is_insert := FALSE);

    UPDATE impl.isplata
    SET radnik_id = p_radnik_id, datum = p_datum, iznos = p_iznos, vrsta = p_vrsta
    WHERE isplata_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_isplata_update');
    RAISE;
END;
$$;

-- DELETE
CREATE OR REPLACE FUNCTION spec.spr_isplata_delete(
    p_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.isplata WHERE isplata_id = p_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_isplata_delete');
    RAISE;
END;
$$;

-- ============================================================
-- UCESTVUJE (agregacioni entitet — triger validira)
-- ============================================================

-- INSERT
CREATE OR REPLACE FUNCTION spec.spr_ucestvuje_insert(
    p_radnik_id   BIGINT,
    p_projekat_id BIGINT,
    p_datum_od    DATE,
    p_datum_do    DATE DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    INSERT INTO impl.ucestvuje (radnik_id, projekat_id, datum_od, datum_do)
    VALUES (p_radnik_id, p_projekat_id, p_datum_od, p_datum_do);
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_ucestvuje_insert');
    RAISE;
END;
$$;

-- DELETE BY RADNIKID
CREATE OR REPLACE FUNCTION spec.spr_ucestvuje_delete_by_radnik_id(
    p_radnik_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.ucestvuje WHERE radnik_id = p_radnik_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_ucestvuje_delete_by_radnik_id');
    RAISE;
END;
$$;

-- DELETE BY PROJEKATID
CREATE OR REPLACE FUNCTION spec.spr_ucestvuje_delete_by_projekat_id(
    p_projekat_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.ucestvuje WHERE projekat_id = p_projekat_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_ucestvuje_delete_by_projekat_id');
    RAISE;
END;
$$;

-- ============================================================
-- RUKOVODI (agregacioni entitet — triger validira)
-- ============================================================

-- SET (UPSERT)
CREATE OR REPLACE FUNCTION spec.spr_rukovodi_set(
    p_projekat_id BIGINT,
    p_radnik_id   BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    INSERT INTO impl.rukovodi (projekat_id, radnik_id)
    VALUES (p_projekat_id, p_radnik_id)
    ON CONFLICT (projekat_id) DO UPDATE SET radnik_id = EXCLUDED.radnik_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_rukovodi_set');
    RAISE;
END;
$$;

-- DELETE BY PROJEKATID
CREATE OR REPLACE FUNCTION spec.spr_rukovodi_delete_by_projekat_id(
    p_projekat_id BIGINT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    DELETE FROM impl.rukovodi WHERE projekat_id = p_projekat_id;
EXCEPTION WHEN OTHERS THEN
    PERFORM spec.handle_error(SQLERRM, 'spec.spr_rukovodi_delete_by_projekat_id');
    RAISE;
END;
$$;

-- ============================================================
-- READ FUNCTIONS (spec layer — called by api wrappers)
-- ============================================================

-- ============================================================
-- RADNOMESTO — Read
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_radnomesto_getall()
RETURNS TABLE(radno_mesto_id BIGINT, naziv VARCHAR)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT radno_mesto_id, naziv
    FROM impl.radno_mesto
    ORDER BY naziv;
$$;

CREATE OR REPLACE FUNCTION spec.spr_radnomesto_getbyid(p_id BIGINT)
RETURNS TABLE(radno_mesto_id BIGINT, naziv VARCHAR)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT radno_mesto_id, naziv
    FROM impl.radno_mesto
    WHERE radno_mesto_id = p_id;
$$;

-- ============================================================
-- SLUZBA — Read
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_sluzba_getall()
RETURNS TABLE(sluzba_id BIGINT, naziv VARCHAR)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT sluzba_id, naziv
    FROM impl.sluzba
    ORDER BY naziv;
$$;

CREATE OR REPLACE FUNCTION spec.spr_sluzba_getbyid(p_id BIGINT)
RETURNS TABLE(sluzba_id BIGINT, naziv VARCHAR)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT sluzba_id, naziv
    FROM impl.sluzba
    WHERE sluzba_id = p_id;
$$;

-- ============================================================
-- PROJEKAT — Read (sa JOIN na Rukovodi + Ucestvuje za Dapper multi-mapping)
-- splitOn: "RadnikId" (prvi radnik_id posle Projekat kolona)
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_projekat_getall()
RETURNS TABLE(
    projekat_id BIGINT, naziv VARCHAR, budzet NUMERIC, klasa SMALLINT,
    rukovodi_radnik_id BIGINT,
    radnik_id BIGINT, u_projekat_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        p.projekat_id, p.naziv, p.budzet, p.klasa,
        ruk.radnik_id,
        u.radnik_id, u.projekat_id, u.datum_od, u.datum_do
    FROM impl.projekat p
    LEFT JOIN impl.rukovodi ruk ON p.projekat_id = ruk.projekat_id
    LEFT JOIN impl.ucestvuje u ON p.projekat_id = u.projekat_id
    ORDER BY p.naziv ASC;
$$;

CREATE OR REPLACE FUNCTION spec.spr_projekat_getbyid(p_id BIGINT)
RETURNS TABLE(
    projekat_id BIGINT, naziv VARCHAR, budzet NUMERIC, klasa SMALLINT,
    rukovodi_radnik_id BIGINT,
    radnik_id BIGINT, u_projekat_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        p.projekat_id, p.naziv, p.budzet, p.klasa,
        ruk.radnik_id,
        u.radnik_id, u.projekat_id, u.datum_od, u.datum_do
    FROM impl.projekat p
    LEFT JOIN impl.rukovodi ruk ON p.projekat_id = ruk.projekat_id
    LEFT JOIN impl.ucestvuje u ON p.projekat_id = u.projekat_id
    WHERE p.projekat_id = p_id;
$$;

-- ============================================================
-- RADNIK — Read (sa JOIN na RadnoMesto, Sluzba, Ucestvuje)
-- splitOn: "RadnoMestoId,SluzbaId,ProjekatId"
-- ============================================================

CREATE OR REPLACE FUNCTION spec.spr_radnik_getall()
RETURNS TABLE(
    radnik_id BIGINT, ime VARCHAR, radno_mesto_id BIGINT, sluzba_id BIGINT,
    rm_radno_mesto_id BIGINT, rm_naziv VARCHAR,
    s_sluzba_id BIGINT, s_naziv VARCHAR,
    projekat_id BIGINT, u_radnik_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        r.radnik_id, r.ime, r.radno_mesto_id, r.sluzba_id,
        rm.radno_mesto_id, rm.naziv,
        s.sluzba_id, s.naziv,
        u.projekat_id, u.radnik_id, u.datum_od, u.datum_do
    FROM impl.radnik r
    INNER JOIN impl.radno_mesto rm ON r.radno_mesto_id = rm.radno_mesto_id
    INNER JOIN impl.sluzba s ON r.sluzba_id = s.sluzba_id
    LEFT JOIN impl.ucestvuje u ON r.radnik_id = u.radnik_id
    ORDER BY r.ime ASC;
$$;

CREATE OR REPLACE FUNCTION spec.spr_radnik_getbyid(p_id BIGINT)
RETURNS TABLE(
    radnik_id BIGINT, ime VARCHAR, radno_mesto_id BIGINT, sluzba_id BIGINT,
    rm_radno_mesto_id BIGINT, rm_naziv VARCHAR,
    s_sluzba_id BIGINT, s_naziv VARCHAR,
    projekat_id BIGINT, u_radnik_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        r.radnik_id, r.ime, r.radno_mesto_id, r.sluzba_id,
        rm.radno_mesto_id, rm.naziv,
        s.sluzba_id, s.naziv,
        u.projekat_id, u.radnik_id, u.datum_od, u.datum_do
    FROM impl.radnik r
    INNER JOIN impl.radno_mesto rm ON r.radno_mesto_id = rm.radno_mesto_id
    INNER JOIN impl.sluzba s ON r.sluzba_id = s.sluzba_id
    LEFT JOIN impl.ucestvuje u ON r.radnik_id = u.radnik_id
    WHERE r.radnik_id = p_id;
$$;

-- ============================================================
-- ISPLATA — Read
-- ============================================================

-- GetByRadnikId
CREATE OR REPLACE FUNCTION spec.spr_isplata_getbyradnikid(p_id BIGINT)
RETURNS TABLE(isplata_id BIGINT, radnik_id BIGINT, vrsta VARCHAR, datum DATE, iznos NUMERIC)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT isplata_id, radnik_id, vrsta, datum, iznos
    FROM impl.isplata
    WHERE radnik_id = p_id
    ORDER BY datum DESC;
$$;

-- GetById (JOIN sa Radnik za Dapper multi-mapping, splitOn: "RadnikId")
CREATE OR REPLACE FUNCTION spec.spr_isplata_getbyid(p_id BIGINT)
RETURNS TABLE(
    isplata_id BIGINT, radnik_id BIGINT, vrsta VARCHAR, datum DATE, iznos NUMERIC,
    r_radnik_id BIGINT, ime VARCHAR, r_radno_mesto_id BIGINT, r_sluzba_id BIGINT
)
LANGUAGE sql SECURITY DEFINER AS $$
    SELECT
        i.isplata_id, i.radnik_id, i.vrsta, i.datum, i.iznos,
        r.radnik_id, r.ime, r.radno_mesto_id, r.sluzba_id
    FROM impl.isplata i
    INNER JOIN impl.radnik r ON i.radnik_id = r.radnik_id
    WHERE i.isplata_id = p_id;
$$;
