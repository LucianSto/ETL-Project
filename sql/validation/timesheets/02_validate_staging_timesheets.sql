/*
Module  : Timesheets
Layer   : VALIDATION
Purpose:
Validate the data loaded into STAGING_TIMESHEETS
before loading it into the Star Schema.

*/

------------------------------------------------------------
-- 1. Total number of rows
------------------------------------------------------------
SELECT COUNT(*) AS TOTAL_ROWS
FROM STAGING_TIMESHEETS;

-- Expected Result: 3050 rows
-- Result: 3050 rows



------------------------------------------------------------
-- 2. Check duplicate business records
------------------------------------------------------------
SELECT
    EMPLOYEE_ID,
    WORK_DATE,
    PROJECT_CODE,
    HOURS,
    COUNT(*) AS NUMBER_OF_OCCURRENCES
FROM STAGING_TIMESHEETS
GROUP BY
    EMPLOYEE_ID,
    WORK_DATE,
    PROJECT_CODE,
    HOURS
HAVING COUNT(*) > 1;

-- Expected Result: No rows selected
-- Result: No rows selected


------------------------------------------------------------
-- 3. Check EmployeeId with leading/trailing spaces
------------------------------------------------------------
SELECT *
FROM STAGING_TIMESHEETS
WHERE EMPLOYEE_ID <> TRIM(EMPLOYEE_ID);

-- Expected Result: No rows selected
-- Result: No rows selected


------------------------------------------------------------
-- 4. Check lowercase Employee IDs
------------------------------------------------------------
SELECT DISTINCT EMPLOYEE_ID
FROM STAGING_TIMESHEETS
WHERE EMPLOYEE_ID <> UPPER(EMPLOYEE_ID);

-- Expected Result: No rows selected
-- Result: No rows selected


------------------------------------------------------------
-- 5. Check normalized Project Codes
------------------------------------------------------------
SELECT DISTINCT PROJECT_CODE
FROM STAGING_TIMESHEETS
ORDER BY PROJECT_CODE;

-- Expected Result:
-- PRJ01
-- PRJ02
-- PRJ03
-- PRJ04
-------------------------------------------------------------
-- Result:
-- PRJ01
-- PRJ02
-- PRJ03
-- PRJ04


------------------------------------------------------------
-- 6. Check Project Names
------------------------------------------------------------
SELECT DISTINCT PROJECT_NAME
FROM STAGING_TIMESHEETS
ORDER BY PROJECT_NAME;

-- Expected Result:
-- Banking App
-- CRM Modernization
-- Data Lake
-- Payments Platform
-- Unknown Project (if NULL values existed)
------------------------------------------------------------
-- Result:
-- Banking App
-- CRM Modernization
-- Data Lake
-- Payments Platform
-- Unknown Project 


------------------------------------------------------------
-- 7. Check NULL Project Names
------------------------------------------------------------
SELECT COUNT(*) AS NULL_PROJECT_NAMES
FROM STAGING_TIMESHEETS
WHERE PROJECT_NAME IS NULL;

-- Expected Result: 0
-- Result: 0


------------------------------------------------------------
-- 8. Check Hours values
------------------------------------------------------------
SELECT DISTINCT HOURS
FROM STAGING_TIMESHEETS
ORDER BY HOURS;

-- Expected Result:
-- 0
-- 4
-- 6
-- 7.5
-- 8
------------------------------------------------------------
-- Result:
-- 0
-- 4
-- 6
-- 7.5
-- 8

------------------------------------------------------------
-- 9. Check invalid Hours
------------------------------------------------------------
SELECT *
FROM STAGING_TIMESHEETS
WHERE HOURS < 0
   OR HOURS > 24;

-- Expected Result: No rows selected
-- Result: No rows selected


------------------------------------------------------------
-- 10. Check NULL WorkDate
------------------------------------------------------------
SELECT *
FROM STAGING_TIMESHEETS
WHERE WORK_DATE IS NULL;


-- Expected Result: No rows selected
-- Result: No rows selected


------------------------------------------------------------
-- 11. Preview cleaned data
------------------------------------------------------------
SELECT *
FROM STAGING_TIMESHEETS
FETCH FIRST 20 ROWS ONLY;


------------------------------------------------------------
-- 12. Deleted rows
------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM SOURCE_TIMESHEETS) -
    (SELECT COUNT(*) FROM STAGING_TIMESHEETS)
    AS REMOVED_ROWS
FROM DUAL;

-- Expected Result: 24
-- Result: 24
