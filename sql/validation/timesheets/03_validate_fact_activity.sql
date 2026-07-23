/*
Module  : Timesheets
Layer   : VALIDATION

Purpose:
Validate the data loaded into FACT_ACTIVITY.

This script verifies:
- row count
- duplicate business records
- foreign key integrity
- NULL values
- business rules

*/

------------------------------------------------------------
-- 1. Total number of records
------------------------------------------------------------
SELECT COUNT(*) AS TOTAL_ROWS
FROM FACT_ACTIVITY;

-- Expected Result: 3050 rows
-- Result: 3050 rows


------------------------------------------------------------
-- 2. Check duplicate business activities
------------------------------------------------------------
SELECT
    EMPLOYEE_KEY,
    DATE_KEY,
    ACTIVITY_TYPE_KEY,
    PROJECT_KEY,
    HOURS_WORKED,
    COUNT(*) AS NUMBER_OF_OCCURRENCES
FROM FACT_ACTIVITY
GROUP BY
    EMPLOYEE_KEY,
    DATE_KEY,
    ACTIVITY_TYPE_KEY,
    PROJECT_KEY,
    HOURS_WORKED
HAVING COUNT(*) > 1;

-- Expected Result: No rows selected
-- Result: No rows selected


------------------------------------------------------------
-- 3. Check NULL Employee Keys
------------------------------------------------------------
SELECT *
FROM FACT_ACTIVITY
WHERE EMPLOYEE_KEY IS NULL;

-- Expected Result: No rows selected
-- Result: No rows selected



------------------------------------------------------------
-- 4. Check NULL Date Keys
------------------------------------------------------------
SELECT *
FROM FACT_ACTIVITY
WHERE DATE_KEY IS NULL;


-- Expected Result: No rows selected
-- Result: No rows selected



------------------------------------------------------------
-- 5. Check NULL Activity Type Keys
------------------------------------------------------------
SELECT *
FROM FACT_ACTIVITY
WHERE ACTIVITY_TYPE_KEY IS NULL;


-- Expected Result: No rows selected
-- Result: No rows selected



------------------------------------------------------------
-- 6. Check NULL Project Keys
------------------------------------------------------------
SELECT *
FROM FACT_ACTIVITY
WHERE PROJECT_KEY IS NULL;

-- Expected Result: No rows selected
-- Result: No rows selected



------------------------------------------------------------
-- 7. Check invalid Hours
------------------------------------------------------------
SELECT *
FROM FACT_ACTIVITY
WHERE HOURS_WORKED < 0
   OR HOURS_WORKED > 24;


-- Expected Result: No rows selected
-- Result: No rows selected



------------------------------------------------------------
-- 8. Check Source System
------------------------------------------------------------
SELECT DISTINCT SOURCE_SYSTEM
FROM FACT_ACTIVITY;

-- Expected Result: TIMESHEETS
-- Result: TIMESHEETS


------------------------------------------------------------
-- 9. Check Load Timestamp
------------------------------------------------------------
SELECT
    MIN(LOAD_TIMESTAMP) AS FIRST_LOAD,
    MAX(LOAD_TIMESTAMP) AS LAST_LOAD
FROM FACT_ACTIVITY;

-- Expected Result:
-- Both timestamps should be populated.
-- Result: 
--22-JUL-26 09.06.49.021531000 AM	22-JUL-26 09.06.49.021531000 AM


------------------------------------------------------------
-- 10. Check referential integrity
------------------------------------------------------------

-- Employee
SELECT COUNT(*) AS INVALID_EMPLOYEES
FROM FACT_ACTIVITY FA
LEFT JOIN DIM_EMPLOYEE DE
ON FA.EMPLOYEE_KEY = DE.EMPLOYEE_KEY
WHERE DE.EMPLOYEE_KEY IS NULL;

-- Expected Result: 0
-- Result: 0


-- Date
SELECT COUNT(*) AS INVALID_DATES
FROM FACT_ACTIVITY FA
LEFT JOIN DIM_DATE DD
ON FA.DATE_KEY = DD.DATE_KEY
WHERE DD.DATE_KEY IS NULL;


-- Expected Result: 0
-- Result: 0


-- Project
SELECT COUNT(*) AS INVALID_PROJECTS
FROM FACT_ACTIVITY FA
LEFT JOIN DIM_PROJECT DP
ON FA.PROJECT_KEY = DP.PROJECT_KEY
WHERE DP.PROJECT_KEY IS NULL;

-- Expected Result: 0
-- Result: 0


-- Activity Type
SELECT COUNT(*) AS INVALID_ACTIVITY_TYPES
FROM FACT_ACTIVITY FA
LEFT JOIN DIM_ACTIVITY_TYPE DAT
ON FA.ACTIVITY_TYPE_KEY = DAT.ACTIVITY_TYPE_KEY
WHERE DAT.ACTIVITY_TYPE_KEY IS NULL;

-- Expected Result: 0
-- Result: 0


------------------------------------------------------------
-- 11. Preview FactActivity
------------------------------------------------------------
SELECT *
FROM FACT_ACTIVITY
FETCH FIRST 20 ROWS ONLY;