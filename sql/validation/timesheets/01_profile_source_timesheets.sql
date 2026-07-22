

-- File: 01_profile_source_timesheets.sql
-- Purpose: Data profiling for SOURCE_TIMESHEETS
-- Layer: VALIDATION


-- 1. Total number of rows
SELECT COUNT(*) AS TotalRows
FROM SOURCE_TIMESHEETS;
-- Result: 3074

-- 2. Number of distinct employees
SELECT COUNT(DISTINCT EmployeeId) AS TotalEmployees
FROM SOURCE_TIMESHEETS;
-- Result: 80

-- 3. Number of distinct projects
SELECT COUNT(DISTINCT ProjectCode) AS TotalProjects
FROM SOURCE_TIMESHEETS;
-- Result: 8

-- 4. Preview first 10 rows
SELECT *
FROM SOURCE_TIMESHEETS
FETCH FIRST 10 ROWS ONLY;

-- 5. Employee IDs containing leading/trailing spaces
SELECT DISTINCT EmployeeId
FROM SOURCE_TIMESHEETS
WHERE EmployeeId LIKE ' %'
   OR EmployeeId LIKE '% ';
--Result:  E017
--         E034
 --        E051
 --        E068

-- 6. Distinct Employee IDs
SELECT DISTINCT EmployeeId
FROM SOURCE_TIMESHEETS
ORDER BY EmployeeId;
-- Result: We have different formate for IDs. Example: E077, e019

-- 7. Distinct Project Codes
SELECT DISTINCT ProjectCode
FROM SOURCE_TIMESHEETS
ORDER BY ProjectCo
--Result : We have same project, but with different code: PRJ-01 / PRJ01

-- 8. Distinct Project Names
SELECT DISTINCT ProjectName
FROM SOURCE_TIMESHEETS
ORDER BY ProjectName;
-- Result: Different name for the same project: banking app/ Banking App

-- 9. Distinct Hours values
SELECT DISTINCT Hours
FROM SOURCE_TIMESHEETS
ORDER BY Hours;
-- Result: 0.0
--         4.0
--         6.0
--         7.5
--         8.0


-- 10. Records with NULL Project Name
SELECT *
FROM SOURCE_TIMESHEETS
WHERE ProjectName IS NULL;
-- Result: 61 rows

-- 11. Duplicate Timesheet IDs
SELECT
    TimesheetId,
    COUNT(*) AS NumberOfOccurrences
FROM SOURCE_TIMESHEETS
GROUP BY TimesheetId
HAVING COUNT(*) > 1;
-- Result: 24 rows

-- 12. Duplicate complete records
SELECT
    EmployeeId,
    WorkDate,
    ProjectCode,
    Hours,
    COUNT(*) AS NumberOfOccurrences
FROM SOURCE_TIMESHEETS
GROUP BY
    EmployeeId,
    WorkDate,
    ProjectCode,
    Hours
HAVING COUNT(*) > 1;
--Result: 24 rows

-- 13. Rows with empty EmployeeId
SELECT *
FROM SOURCE_TIMESHEETS
WHERE EmployeeId IS NULL
   OR TRIM(EmployeeId) = '';
-- Result: 0 rows


-- 14. Rows with empty ProjectCode
SELECT *
FROM SOURCE_TIMESHEETS
WHERE ProjectCode IS NULL
   OR TRIM(ProjectCode) = '';
-- Resulr: 0 rows

-- 15. Distribution of hours
SELECT
    Hours,
    COUNT(*) AS NumberOfRows
FROM SOURCE_TIMESHEETS
GROUP BY Hours
ORDER BY Hours;
-- Result: Hours - nrRows
--           0.0	449
--           4.0	411
--           6.0	442
--           7.5	481
--           8.0	1291


-- 16. Number of rows per project
SELECT
    ProjectCode,
    COUNT(*) AS NumberOfRows
FROM SOURCE_TIMESHEETS
GROUP BY ProjectCode
ORDER BY NumberOfRows DESC;
-- Result:    ProjectCode  -  NrRows
--                 PRJ01	757
--                 PRJ04	749
--                 PRJ02	710
--                 PRJ03	700
--                 PRJ-04	51
--                 PRJ-02	44
--                 PRJ-01	33
--                 PRJ-03	30

-- 17. Number of rows per employee
SELECT
    EmployeeId,
    COUNT(*) AS NumberOfRows
FROM SOURCE_TIMESHEETS
GROUP BY EmployeeId
ORDER BY NumberOfRows DESC;
--Result : range 29-46



/*
# Data Quality Issues

| Issue | Details |
|-------|---------|
| Leading/trailing spaces | Employee IDs contain leading/trailing spaces (E017, E034, E051, E068). |
| Inconsistent letter case | Employee IDs are stored using different letter cases (e.g. `E019` and `e019`). |
| Inconsistent project codes | Same project appears with different codes (`PRJ01` / `PRJ-01`). |
| Inconsistent project names | Same project appears with different names (`Banking App` / `banking app`). |
| Missing project names | 61 records have `NULL` values for `ProjectName`. |
| Duplicate records | 24 duplicate `TimesheetId` values and 24 duplicate business records. |
| Data types stored as text | `WorkDate` and `Hours` are stored as `VARCHAR2` and require conversion in STAGING. |


# Summary

The source dataset contains several data quality issues that must be addressed in the STAGING layer before loading the data into the Star Schema.
*/
