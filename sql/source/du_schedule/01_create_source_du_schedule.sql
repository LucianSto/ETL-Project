-- File: 01_create_source_du_schedule.sql
-- Purpose: Creates the raw source table for DU Exam & Absence Schedule data.
-- Layer: SOURCE

CREATE TABLE SOURCE_DUSCHEDULE
(
    EmployeeId      VARCHAR2(30),
    EmployeeName    VARCHAR2(100),
    Grade           VARCHAR2(30),
    Discipline      VARCHAR2(50),
    LineManager     VARCHAR2(100),
    DeliveryUnit    VARCHAR2(100),

    "01-Jun" VARCHAR2(10),
    "02-Jun" VARCHAR2(10),
    "03-Jun" VARCHAR2(10),
    "04-Jun" VARCHAR2(10),
    "05-Jun" VARCHAR2(10),
    "06-Jun" VARCHAR2(10),
    "07-Jun" VARCHAR2(10),
    "08-Jun" VARCHAR2(10),
    "09-Jun" VARCHAR2(10),
    "10-Jun" VARCHAR2(10),
    "11-Jun" VARCHAR2(10),
    "12-Jun" VARCHAR2(10),
    "13-Jun" VARCHAR2(10),
    "14-Jun" VARCHAR2(10),
    "15-Jun" VARCHAR2(10),
    "16-Jun" VARCHAR2(10),
    "17-Jun" VARCHAR2(10),
    "18-Jun" VARCHAR2(10),
    "19-Jun" VARCHAR2(10),
    "20-Jun" VARCHAR2(10),
    "21-Jun" VARCHAR2(10),
    "22-Jun" VARCHAR2(10),
    "23-Jun" VARCHAR2(10),
    "24-Jun" VARCHAR2(10),
    "25-Jun" VARCHAR2(10),
    "26-Jun" VARCHAR2(10),
    "27-Jun" VARCHAR2(10),
    "28-Jun" VARCHAR2(10),
    "29-Jun" VARCHAR2(10),
    "30-Jun" VARCHAR2(10),

    "01-Jul" VARCHAR2(10),
    "02-Jul" VARCHAR2(10),
    "03-Jul" VARCHAR2(10),
    "04-Jul" VARCHAR2(10),
    "05-Jul" VARCHAR2(10),
    "06-Jul" VARCHAR2(10),
    "07-Jul" VARCHAR2(10),
    "08-Jul" VARCHAR2(10),
    "09-Jul" VARCHAR2(10),
    "10-Jul" VARCHAR2(10),
    "11-Jul" VARCHAR2(10),
    "12-Jul" VARCHAR2(10),
    "13-Jul" VARCHAR2(10),
    "14-Jul" VARCHAR2(10),
    "15-Jul" VARCHAR2(10),
    "16-Jul" VARCHAR2(10),
    "17-Jul" VARCHAR2(10),
    "18-Jul" VARCHAR2(10),
    "19-Jul" VARCHAR2(10),
    "20-Jul" VARCHAR2(10),
    "21-Jul" VARCHAR2(10),
    "22-Jul" VARCHAR2(10),
    "23-Jul" VARCHAR2(10),
    "24-Jul" VARCHAR2(10),
    "25-Jul" VARCHAR2(10),
    "26-Jul" VARCHAR2(10),
    "27-Jul" VARCHAR2(10),
    "28-Jul" VARCHAR2(10),
    "29-Jul" VARCHAR2(10),
    "30-Jul" VARCHAR2(10)
);
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