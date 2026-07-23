-- File: 02_create_staging_du_schedule.sql
-- Purpose: Creates the staging table for DU Exam & Absence Schedule data.
-- Layer: STAGING

/*
=========================================================
IMPORTANT

Before running the staging scripts, import the source CSV
file (DUExamAbsenceSchedule.csv) into SOURCE_DUSCHEDULE
using Oracle SQL Developer -> Import Data.

The source table must be populated before executing:
    - 02_create_staging_du_schedule.sql
    - 03_load_staging_du_schedule.sql

=========================================================
*/

CREATE TABLE STAGING_DUSCHEDULE
(
    EmployeeId      VARCHAR2(30),
    EmployeeName    VARCHAR2(100),
    Grade           VARCHAR2(30),
    Discipline      VARCHAR2(50),
    LineManager     VARCHAR2(100),
    DeliveryUnit    VARCHAR2(100),

    ActivityDate    DATE,
    ActivityCode    VARCHAR2(10)
);