/* ============================================================
   STAGING - TRAINING ATTENDANCE
   Cleaned and transformed data
   ============================================================ */

CREATE TABLE STG_TRAINING
(
    ATTENDANCE_ID      VARCHAR2(20)    NOT NULL,
    EMPLOYEE_ID        VARCHAR2(20)    NOT NULL,
    EMPLOYEE_NAME      VARCHAR2(200)   NOT NULL,
    GRADE              VARCHAR2(100),
    DISCIPLINE         VARCHAR2(100),
    LINE_MANAGER       VARCHAR2(200),
    DELIVERY_UNIT      VARCHAR2(150),
    TRAINING_DATE      DATE,
    TRAINING_NAME      VARCHAR2(250),
    CATEGORY           VARCHAR2(100),
    DURATION_HOURS     NUMBER(5,2),
    STATUS             VARCHAR2(50)
);