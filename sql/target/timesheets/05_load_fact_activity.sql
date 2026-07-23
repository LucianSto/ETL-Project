/*
Module  : Timesheets
Layer   : TARGET

Purpose:
Load employee work activities from STAGING_TIMESHEETS
into FACT_ACTIVITY.

Business keys are replaced with surrogate keys from
the dimension tables.

One record in FACT_ACTIVITY represents one employee
activity for one calendar date.

*/

INSERT INTO FACT_ACTIVITY
(
    EMPLOYEE_KEY,
    DATE_KEY,
    ACTIVITY_TYPE_KEY,
    PROJECT_KEY,
    TRAINING_KEY,
    HOURS_WORKED,
    SOURCE_SYSTEM,
    LOAD_TIMESTAMP
)

SELECT

    -- Employee surrogate key
    DE.EMPLOYEE_KEY,

    -- Calendar date surrogate key
    DD.DATE_KEY,

    -- Activity type surrogate key
    DAT.ACTIVITY_TYPE_KEY,

    -- Project surrogate key
    DP.PROJECT_KEY,

    -- Timesheets do not contain training activities.
    NULL AS TRAINING_KEY,

    -- Number of worked hours.
    STG.HOURS AS HOURS_WORKED,

    -- Source system identifier.
    STG.SOURCE_SYSTEM,

    -- ETL execution timestamp.
    STG.LOAD_TIMESTAMP

FROM STAGING_TIMESHEETS STG

-- Match employee using EmployeeId.
INNER JOIN DIM_EMPLOYEE DE
    ON STG.EMPLOYEE_ID = DE.EMPLOYEE_ID

-- Match project using ProjectCode.
INNER JOIN DIM_PROJECT DP
    ON STG.PROJECT_CODE = DP.PROJECT_CODE

-- Match calendar date using WorkDate.
INNER JOIN DIM_DATE DD
    ON STG.WORK_DATE = DD.FULL_DATE

------------------------------------------------------------
-- Match activity type.
--
-- All records from the Timesheets module represent
-- WORK activities.
------------------------------------------------------------
INNER JOIN DIM_ACTIVITY_TYPE DAT
    ON DAT.ACTIVITY_TYPE_NAME = 'WORK'

------------------------------------------------------------
-- Prevent duplicate fact records.
--
-- The ETL can be executed multiple times without
-- inserting duplicate business activities.
------------------------------------------------------------
WHERE NOT EXISTS
(
    SELECT 1
    FROM FACT_ACTIVITY FA
    WHERE FA.EMPLOYEE_KEY = DE.EMPLOYEE_KEY
      AND FA.DATE_KEY = DD.DATE_KEY
      AND FA.ACTIVITY_TYPE_KEY = DAT.ACTIVITY_TYPE_KEY
      AND FA.PROJECT_KEY = DP.PROJECT_KEY
      AND NVL(FA.HOURS_WORKED,-1) = NVL(STG.HOURS,-1)
);
