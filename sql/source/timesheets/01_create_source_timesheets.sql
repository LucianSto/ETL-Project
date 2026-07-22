
-- File: 01_create_source_timesheets.sql
-- Purpose: Creates the raw source table for Timesheets data.
-- Layer: SOURCE
CREATE TABLE SOURCE_TIMESHEETS
(
    TimesheetId    VARCHAR2(30),
    EmployeeId     VARCHAR2(30),
    EmployeeName   VARCHAR2(100),
    Grade          VARCHAR2(30),
    Discipline     VARCHAR2(50),
    LineManager    VARCHAR2(100),
    DeliveryUnit   VARCHAR2(100),
    WorkDate       VARCHAR2(30),
    ProjectCode    VARCHAR2(30),
    ProjectName    VARCHAR2(150),
    Hours          VARCHAR2(20)
);