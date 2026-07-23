/*
    Validation queries
    Dataset: DU Exam & Absence Schedule
    Author: Andrei
*/
-- Validation 1 - Source row count
SELECT COUNT(*) FROM SOURCE_DUSCHEDULE;

-- Validation 2 - Staging row count
SELECT COUNT(*) FROM STAGING_DUSCHEDULE;

-- Validation 3 - Missing EmployeeId
SELECT *
FROM STAGING_DUSCHEDULE
WHERE EmployeeId IS NULL;

-- Validation 4 - Missing mandatory fields
SELECT *
FROM STAGING_DUSCHEDULE
WHERE EmployeeName IS NULL
   OR Grade IS NULL
   OR Discipline IS NULL
   OR LineManager IS NULL
   OR DeliveryUnit IS NULL;

-- Validation 5 - Activity codes
SELECT DISTINCT ActivityCode
FROM STAGING_DUSCHEDULE
ORDER BY ActivityCode;

-- Validation 6 - Duplicate records
SELECT EmployeeId,
       ActivityDate,
       ActivityCode,
       COUNT(*)
FROM STAGING_DUSCHEDULE
GROUP BY EmployeeId,
         ActivityDate,
         ActivityCode
HAVING COUNT(*) > 1;