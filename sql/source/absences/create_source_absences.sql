-- ==========================================
-- Source Absences
-- ==========================================

CREATE TABLE source_absences
(
    absence_id      VARCHAR2(10),
    employee_id     VARCHAR2(20),
    employee_name   VARCHAR2(100),
    grade           VARCHAR2(30),
    discipline      VARCHAR2(100),
    line_manager    VARCHAR2(100),
    delivery_unit   VARCHAR2(100),
    start_date      DATE,
    end_date        DATE,
    absence_type    VARCHAR2(50)
);