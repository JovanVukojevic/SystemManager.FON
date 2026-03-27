-- ============================================================
-- RADNOMESTO
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_radnomesto_create(p_naziv VARCHAR(22))
RETURNS BIGINT
LANGUAGE sql AS $$
    SELECT spec.spr_radnomesto_insert(p_naziv := p_naziv);
$$;

CREATE OR REPLACE FUNCTION api.usp_radnomesto_update(p_id BIGINT, p_naziv VARCHAR(22))
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_radnomesto_update(p_id := p_id, p_naziv := p_naziv);
$$;

CREATE OR REPLACE FUNCTION api.usp_radnomesto_delete(p_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_radnomesto_delete(p_id := p_id);
$$;

-- ============================================================
-- SLUZBA
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_sluzba_create(p_naziv VARCHAR(22))
RETURNS BIGINT
LANGUAGE sql AS $$
    SELECT spec.spr_sluzba_insert(p_naziv := p_naziv);
$$;

CREATE OR REPLACE FUNCTION api.usp_sluzba_update(p_id BIGINT, p_naziv VARCHAR(22))
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_sluzba_update(p_id := p_id, p_naziv := p_naziv);
$$;

CREATE OR REPLACE FUNCTION api.usp_sluzba_delete(p_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_sluzba_delete(p_id := p_id);
$$;

-- ============================================================
-- PROJEKAT
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_projekat_create(p_naziv VARCHAR(50), p_budzet NUMERIC)
RETURNS BIGINT
LANGUAGE sql AS $$
    SELECT spec.spr_projekat_insert(p_naziv := p_naziv, p_budzet := p_budzet);
$$;

CREATE OR REPLACE FUNCTION api.usp_projekat_update(p_id BIGINT, p_naziv VARCHAR(50), p_budzet NUMERIC)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_projekat_update(p_id := p_id, p_naziv := p_naziv, p_budzet := p_budzet);
$$;

CREATE OR REPLACE FUNCTION api.usp_projekat_delete(p_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_projekat_delete(p_id := p_id);
$$;

-- ============================================================
-- RADNIK
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_radnik_create(p_ime VARCHAR(22), p_sluzba_id BIGINT, p_radno_mesto_id BIGINT)
RETURNS BIGINT
LANGUAGE sql AS $$
    SELECT spec.spr_radnik_insert(p_ime := p_ime, p_sluzba_id := p_sluzba_id, p_radno_mesto_id := p_radno_mesto_id);
$$;

CREATE OR REPLACE FUNCTION api.usp_radnik_update(p_id BIGINT, p_ime VARCHAR(22), p_sluzba_id BIGINT, p_radno_mesto_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_radnik_update(p_id := p_id, p_ime := p_ime, p_sluzba_id := p_sluzba_id, p_radno_mesto_id := p_radno_mesto_id);
$$;

CREATE OR REPLACE FUNCTION api.usp_radnik_delete(p_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_radnik_delete(p_id := p_id);
$$;

-- ============================================================
-- ISPLATA
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_isplata_create(p_radnik_id BIGINT, p_datum DATE, p_iznos NUMERIC, p_vrsta VARCHAR(11))
RETURNS BIGINT
LANGUAGE sql AS $$
    SELECT spec.spr_isplata_insert(p_radnik_id := p_radnik_id, p_datum := p_datum, p_iznos := p_iznos, p_vrsta := p_vrsta);
$$;

CREATE OR REPLACE FUNCTION api.usp_isplata_update(p_id BIGINT, p_radnik_id BIGINT, p_datum DATE, p_iznos NUMERIC, p_vrsta VARCHAR(11))
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_isplata_update(p_id := p_id, p_radnik_id := p_radnik_id, p_datum := p_datum, p_iznos := p_iznos, p_vrsta := p_vrsta);
$$;

CREATE OR REPLACE FUNCTION api.usp_isplata_delete(p_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_isplata_delete(p_id := p_id);
$$;

-- ============================================================
-- UCESTVUJE
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_ucestvuje_insert(p_radnik_id BIGINT, p_projekat_id BIGINT, p_datum_od DATE, p_datum_do DATE DEFAULT NULL)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_ucestvuje_insert(p_radnik_id := p_radnik_id, p_projekat_id := p_projekat_id, p_datum_od := p_datum_od, p_datum_do := p_datum_do);
$$;

CREATE OR REPLACE FUNCTION api.usp_ucestvuje_deletebyradnikid(p_radnik_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_ucestvuje_delete_by_radnik_id(p_radnik_id := p_radnik_id);
$$;

CREATE OR REPLACE FUNCTION api.usp_ucestvuje_deletebyprojekatid(p_projekat_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_ucestvuje_delete_by_projekat_id(p_projekat_id := p_projekat_id);
$$;

-- ============================================================
-- RUKOVODI
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_rukovodi_set(p_projekat_id BIGINT, p_radnik_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_rukovodi_set(p_projekat_id := p_projekat_id, p_radnik_id := p_radnik_id);
$$;

CREATE OR REPLACE FUNCTION api.usp_rukovodi_deletebyprojekatid(p_projekat_id BIGINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_rukovodi_delete_by_projekat_id(p_projekat_id := p_projekat_id);
$$;
