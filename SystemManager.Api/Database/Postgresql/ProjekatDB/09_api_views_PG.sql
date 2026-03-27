-- ============================================================
-- RADNOMESTO
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_radnomesto_getall()
RETURNS TABLE(radno_mesto_id BIGINT, naziv VARCHAR)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_radnomesto_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_radnomesto_getbyid(p_id BIGINT)
RETURNS TABLE(radno_mesto_id BIGINT, naziv VARCHAR)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_radnomesto_getbyid(p_id := p_id);
$$;

-- ============================================================
-- SLUZBA
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_sluzba_getall()
RETURNS TABLE(sluzba_id BIGINT, naziv VARCHAR)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_sluzba_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_sluzba_getbyid(p_id BIGINT)
RETURNS TABLE(sluzba_id BIGINT, naziv VARCHAR)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_sluzba_getbyid(p_id := p_id);
$$;

-- ============================================================
-- PROJEKAT (sa JOIN na Rukovodi + Ucestvuje za Dapper multi-mapping)
-- splitOn: "RadnikId" (prvi radnik_id posle Projekat kolona)
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_projekat_getall()
RETURNS TABLE(
    projekat_id BIGINT, naziv VARCHAR, budzet NUMERIC, klasa SMALLINT,
    rukovodi_radnik_id BIGINT,
    radnik_id BIGINT, u_projekat_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_projekat_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_projekat_getbyid(p_id BIGINT)
RETURNS TABLE(
    projekat_id BIGINT, naziv VARCHAR, budzet NUMERIC, klasa SMALLINT,
    rukovodi_radnik_id BIGINT,
    radnik_id BIGINT, u_projekat_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_projekat_getbyid(p_id := p_id);
$$;

-- ============================================================
-- RADNIK (sa JOIN na RadnoMesto, Sluzba, Ucestvuje)
-- splitOn: "RadnoMestoId,SluzbaId,ProjekatId"
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_radnik_getall()
RETURNS TABLE(
    radnik_id BIGINT, ime VARCHAR, radno_mesto_id BIGINT, sluzba_id BIGINT,
    rm_radno_mesto_id BIGINT, rm_naziv VARCHAR,
    s_sluzba_id BIGINT, s_naziv VARCHAR,
    projekat_id BIGINT, u_radnik_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_radnik_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_radnik_getbyid(p_id BIGINT)
RETURNS TABLE(
    radnik_id BIGINT, ime VARCHAR, radno_mesto_id BIGINT, sluzba_id BIGINT,
    rm_radno_mesto_id BIGINT, rm_naziv VARCHAR,
    s_sluzba_id BIGINT, s_naziv VARCHAR,
    projekat_id BIGINT, u_radnik_id BIGINT, datum_od DATE, datum_do DATE
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_radnik_getbyid(p_id := p_id);
$$;

-- ============================================================
-- ISPLATA
-- ============================================================

-- GetByRadnikId
CREATE OR REPLACE FUNCTION api.usp_isplata_getbyradnikid(p_id BIGINT)
RETURNS TABLE(isplata_id BIGINT, radnik_id BIGINT, vrsta VARCHAR, datum DATE, iznos NUMERIC)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_isplata_getbyradnikid(p_id := p_id);
$$;

-- GetById (JOIN sa Radnik za Dapper multi-mapping, splitOn: "RadnikId")
CREATE OR REPLACE FUNCTION api.usp_isplata_getbyid(p_id BIGINT)
RETURNS TABLE(
    isplata_id BIGINT, radnik_id BIGINT, vrsta VARCHAR, datum DATE, iznos NUMERIC,
    r_radnik_id BIGINT, ime VARCHAR, r_radno_mesto_id BIGINT, r_sluzba_id BIGINT
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_isplata_getbyid(p_id := p_id);
$$;

-- ============================================================
