-- ============================================================
-- ERROR_LOG (jedna za celu bazu)
-- ============================================================
CREATE TABLE impl.error_log
(
    log_id          BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    error_number    INT                                     NULL,
    error_message   TEXT                                    NULL,
    procedure_name  TEXT                                    NULL,
    log_date        TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),

    CONSTRAINT pk_error_log PRIMARY KEY (log_id)
);

-- ============================================================
-- SLUZBA_AUDIT
-- ============================================================
CREATE TABLE impl.sluzba_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,   -- 'INS','UPD','DEL'
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    sluzba_id   BIGINT                                  NOT NULL,
    naziv       VARCHAR(22)                             NULL,

    CONSTRAINT pk_sluzba_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- RADNO_MESTO_AUDIT
-- ============================================================
CREATE TABLE impl.radno_mesto_audit
(
    audit_id       BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type    CHAR(3)                                 NOT NULL,
    changed_at     TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by     TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    radno_mesto_id BIGINT                                  NOT NULL,
    naziv          VARCHAR(22)                             NULL,

    CONSTRAINT pk_radno_mesto_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- PROJEKAT_AUDIT
-- ============================================================
CREATE TABLE impl.projekat_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    projekat_id BIGINT                                  NOT NULL,
    naziv       VARCHAR(50)                             NULL,
    budzet      NUMERIC(15,2)                           NULL,
    klasa       SMALLINT                                NULL,

    CONSTRAINT pk_projekat_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- RADNIK_AUDIT
-- ============================================================
CREATE TABLE impl.radnik_audit
(
    audit_id       BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type    CHAR(3)                                 NOT NULL,
    changed_at     TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by     TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    radnik_id      BIGINT                                  NOT NULL,
    ime            VARCHAR(22)                             NULL,
    sluzba_id      BIGINT                                  NULL,
    radno_mesto_id BIGINT                                  NULL,

    CONSTRAINT pk_radnik_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- ISPLATA_AUDIT
-- ============================================================
CREATE TABLE impl.isplata_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    radnik_id   BIGINT                                  NOT NULL,
    isplata_id  BIGINT                                  NOT NULL,
    datum       DATE                                    NULL,
    iznos       NUMERIC(15,2)                           NULL,
    vrsta       VARCHAR(11)                             NULL,

    CONSTRAINT pk_isplata_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- UCESTVUJE_AUDIT
-- ============================================================
CREATE TABLE impl.ucestvuje_audit
(
    audit_id     BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type  CHAR(3)                                 NOT NULL,
    changed_at   TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by   TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    ucestvuje_id BIGINT                                  NOT NULL,
    datum_od     DATE                                    NULL,
    datum_do     DATE                                    NULL,
    radnik_id    BIGINT                                  NULL,
    projekat_id  BIGINT                                  NULL,

    CONSTRAINT pk_ucestvuje_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- RUKOVODI_AUDIT
-- ============================================================
CREATE TABLE impl.rukovodi_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    rukovodi_id BIGINT                                  NOT NULL,
    radnik_id   BIGINT                                  NULL,
    projekat_id BIGINT                                  NULL,

    CONSTRAINT pk_rukovodi_audit PRIMARY KEY (audit_id)
);
