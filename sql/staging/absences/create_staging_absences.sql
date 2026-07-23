-- ==========================================
-- Staging Absences
-- ==========================================

CREATE TABLE staging_absences
(
    absence_id               VARCHAR2(10),
    employee_id              VARCHAR2(20),
    employee_name            VARCHAR2(100),
    grade                    VARCHAR2(30),
    discipline               VARCHAR2(100),
    line_manager             VARCHAR2(100),
    delivery_unit            VARCHAR2(100),
    start_date               DATE,
    end_date                 DATE,
    normalized_absence_type  VARCHAR2(50), -- valorile noi
    validation_status        VARCHAR2(20), -- VALID / INVALID
    validation_message       VARCHAR2(500), -- mesaj de eroare in caz de INVALID
    load_timestamp           TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- data si ora la care a fost incarcat in staging
);