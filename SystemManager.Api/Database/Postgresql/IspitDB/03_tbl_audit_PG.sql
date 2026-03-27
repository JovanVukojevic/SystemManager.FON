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
-- ZVANJE_AUDIT
-- ============================================================
CREATE TABLE impl.zvanje_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,   -- 'INS','UPD','DEL'
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    id_zvanje   INT                                     NOT NULL,
    naziv       VARCHAR(35)                             NULL,

    CONSTRAINT pk_zvanje_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- PREDMET_AUDIT
-- ============================================================
CREATE TABLE impl.predmet_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    id_predmet  INT                                     NOT NULL,
    naziv       VARCHAR(35)                             NULL,
    espb        SMALLINT                                NULL,

    CONSTRAINT pk_predmet_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- STUDENT_AUDIT
-- ============================================================
CREATE TABLE impl.student_audit
(
    audit_id        BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type     CHAR(3)                                 NOT NULL,
    changed_at      TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by      TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns (bez starost — izvedena kolona)
    broj_indeksa    VARCHAR(7)                              NOT NULL,
    ime             VARCHAR(22)                             NULL,
    datum_rodjenja  DATE                                    NULL,
    semestar        VARCHAR(4)                              NULL,
    prosecna_ocena  DECIMAL(4,2)                            NULL,

    CONSTRAINT pk_student_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- NASTAVNIK_AUDIT
-- ============================================================
CREATE TABLE impl.nastavnik_audit
(
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type CHAR(3)                                 NOT NULL,
    changed_at  TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by  TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    id_nastavnik INT                                    NOT NULL,
    ime         VARCHAR(22)                             NULL,
    id_zvanje   INT                                     NULL,

    CONSTRAINT pk_nastavnik_audit PRIMARY KEY (audit_id)
);

-- ============================================================
-- ISPIT_AUDIT
-- ============================================================
CREATE TABLE impl.ispit_audit
(
    audit_id        BIGINT GENERATED ALWAYS AS IDENTITY     NOT NULL,
    action_type     CHAR(3)                                 NOT NULL,
    changed_at      TIMESTAMPTZ                             NOT NULL    DEFAULT NOW(),
    changed_by      TEXT                                    NOT NULL    DEFAULT CURRENT_USER,

    -- Mirror columns
    id_ispit        INT                                     NOT NULL,
    ocena           SMALLINT                                NULL,
    datum_polaganja DATE                                    NULL,
    broj_indeksa    VARCHAR(7)                              NULL,
    id_predmet      INT                                     NULL,
    id_nastavnik    INT                                     NULL,

    CONSTRAINT pk_ispit_audit PRIMARY KEY (audit_id)
);
