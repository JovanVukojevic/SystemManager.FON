-- ============================================================
-- ZVANJE
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_zvanje_getall()
RETURNS TABLE(id_zvanje INT, naziv VARCHAR)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_zvanje_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_zvanje_getbyid(p_id_zvanje INT)
RETURNS TABLE(id_zvanje INT, naziv VARCHAR)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_zvanje_getbyid(p_id_zvanje := p_id_zvanje);
$$;

-- ============================================================
-- PREDMET
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_predmet_getall()
RETURNS TABLE(id_predmet INT, naziv VARCHAR, espb SMALLINT)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_predmet_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_predmet_getbyid(p_id_predmet INT)
RETURNS TABLE(id_predmet INT, naziv VARCHAR, espb SMALLINT)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_predmet_getbyid(p_id_predmet := p_id_predmet);
$$;

-- ============================================================
-- STUDENT (koristi impl.v_student pogled za kolonu starost)
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_student_getall()
RETURNS TABLE(
    broj_indeksa VARCHAR,
    ime VARCHAR,
    datum_rodjenja DATE,
    semestar VARCHAR,
    starost INT,
    prosecna_ocena DECIMAL
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_student_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_student_getbyid(p_broj_indeksa VARCHAR)
RETURNS TABLE(
    broj_indeksa VARCHAR,
    ime VARCHAR,
    datum_rodjenja DATE,
    semestar VARCHAR,
    starost INT,
    prosecna_ocena DECIMAL
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_student_getbyid(p_broj_indeksa := p_broj_indeksa);
$$;

-- ============================================================
-- NASTAVNIK (sa JOIN na Zvanje za navigacioni property)
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_nastavnik_getall()
RETURNS TABLE(
    id_nastavnik INT,
    ime VARCHAR,
    id_zvanje INT,
    id_zvanje_z INT,
    naziv VARCHAR
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_nastavnik_getall();
$$;

CREATE OR REPLACE FUNCTION api.usp_nastavnik_getbyid(p_id_nastavnik INT)
RETURNS TABLE(
    id_nastavnik INT,
    ime VARCHAR,
    id_zvanje INT,
    id_zvanje_z INT,
    naziv VARCHAR
)
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_nastavnik_getbyid(p_id_nastavnik := p_id_nastavnik);
$$;

-- ============================================================
-- ISPIT (sa JOIN na Student, Nastavnik, Zvanje, Predmet)
-- Redosled kolona identican postojecem za Dapper multi-mapping
-- splitOn: "s_broj_indeksa,n_id_nastavnik,z_id_zvanje,id_predmet"
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_ispit_getall(p_broj_indeksa VARCHAR DEFAULT NULL)
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
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_ispit_getall(p_broj_indeksa := p_broj_indeksa);
$$;

CREATE OR REPLACE FUNCTION api.usp_ispit_getbyid(p_id_ispit INT)
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
LANGUAGE sql AS $$
    SELECT * FROM spec.spr_ispit_getbyid(p_id_ispit := p_id_ispit);
$$;
