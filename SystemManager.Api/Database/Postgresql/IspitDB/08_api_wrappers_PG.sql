-- ============================================================
-- ZVANJE
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_zvanje_create(p_naziv VARCHAR(35))
RETURNS INT
LANGUAGE sql AS $$
    SELECT spec.spr_zvanje_insert(p_naziv := p_naziv);
$$;

CREATE OR REPLACE FUNCTION api.usp_zvanje_update(p_id_zvanje INT, p_naziv VARCHAR(35))
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_zvanje_update(p_id_zvanje := p_id_zvanje, p_naziv := p_naziv);
$$;

CREATE OR REPLACE FUNCTION api.usp_zvanje_delete(p_id_zvanje INT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_zvanje_delete(p_id_zvanje := p_id_zvanje);
$$;

-- ============================================================
-- PREDMET
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_predmet_create(p_naziv VARCHAR(35), p_espb SMALLINT DEFAULT 4)
RETURNS INT
LANGUAGE sql AS $$
    SELECT spec.spr_predmet_insert(p_naziv := p_naziv, p_espb := p_espb);
$$;

CREATE OR REPLACE FUNCTION api.usp_predmet_update(p_id_predmet INT, p_naziv VARCHAR(35), p_espb SMALLINT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_predmet_update(p_id_predmet := p_id_predmet, p_naziv := p_naziv, p_espb := p_espb);
$$;

CREATE OR REPLACE FUNCTION api.usp_predmet_delete(p_id_predmet INT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_predmet_delete(p_id_predmet := p_id_predmet);
$$;

-- ============================================================
-- STUDENT
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_student_create(
    p_broj_indeksa VARCHAR(7), p_ime VARCHAR(22), p_datum_rodjenja DATE, p_semestar VARCHAR(4)
)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_student_insert(
        p_broj_indeksa := p_broj_indeksa, p_ime := p_ime,
        p_datum_rodjenja := p_datum_rodjenja, p_semestar := p_semestar);
$$;

CREATE OR REPLACE FUNCTION api.usp_student_update(
    p_broj_indeksa VARCHAR(7), p_ime VARCHAR(22), p_datum_rodjenja DATE, p_semestar VARCHAR(4)
)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_student_update(
        p_broj_indeksa := p_broj_indeksa, p_ime := p_ime,
        p_datum_rodjenja := p_datum_rodjenja, p_semestar := p_semestar);
$$;

CREATE OR REPLACE FUNCTION api.usp_student_delete(p_broj_indeksa VARCHAR(7))
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_student_delete(p_broj_indeksa := p_broj_indeksa);
$$;

-- ============================================================
-- NASTAVNIK
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_nastavnik_create(p_ime VARCHAR(22), p_id_zvanje INT)
RETURNS INT
LANGUAGE sql AS $$
    SELECT spec.spr_nastavnik_insert(p_ime := p_ime, p_id_zvanje := p_id_zvanje);
$$;

CREATE OR REPLACE FUNCTION api.usp_nastavnik_update(p_id_nastavnik INT, p_ime VARCHAR(22), p_id_zvanje INT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_nastavnik_update(p_id_nastavnik := p_id_nastavnik, p_ime := p_ime, p_id_zvanje := p_id_zvanje);
$$;

CREATE OR REPLACE FUNCTION api.usp_nastavnik_delete(p_id_nastavnik INT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_nastavnik_delete(p_id_nastavnik := p_id_nastavnik);
$$;

-- ============================================================
-- ISPIT
-- ============================================================

CREATE OR REPLACE FUNCTION api.usp_ispit_create(
    p_ocena SMALLINT, p_datum_polaganja DATE, p_broj_indeksa VARCHAR(7), p_id_predmet INT, p_id_nastavnik INT
)
RETURNS INT
LANGUAGE sql AS $$
    SELECT spec.spr_ispit_insert(
        p_ocena := p_ocena, p_datum_polaganja := p_datum_polaganja,
        p_broj_indeksa := p_broj_indeksa, p_id_predmet := p_id_predmet, p_id_nastavnik := p_id_nastavnik);
$$;

CREATE OR REPLACE FUNCTION api.usp_ispit_update(
    p_id_ispit INT, p_ocena SMALLINT, p_datum_polaganja DATE, p_broj_indeksa VARCHAR(7), p_id_predmet INT, p_id_nastavnik INT
)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_ispit_update(
        p_id_ispit := p_id_ispit, p_ocena := p_ocena, p_datum_polaganja := p_datum_polaganja,
        p_broj_indeksa := p_broj_indeksa, p_id_predmet := p_id_predmet, p_id_nastavnik := p_id_nastavnik);
$$;

CREATE OR REPLACE FUNCTION api.usp_ispit_delete(p_id_ispit INT)
RETURNS void
LANGUAGE sql AS $$
    SELECT spec.spr_ispit_delete(p_id_ispit := p_id_ispit);
$$;
