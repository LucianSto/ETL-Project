/* ============================================================
   VALIDATION - TRAINING ATTENDANCE
   ============================================================ */

-- Source vs Staging row count
SELECT COUNT(*) AS SRC_ROWS
FROM SRC_TRAINING;

SELECT COUNT(*) AS STG_ROWS
FROM STG_TRAINING;

-- Check for NULL Employee IDs
SELECT *
FROM STG_TRAINING
WHERE EMPLOYEE_ID IS NULL;

-- Check for NULL Training Dates
SELECT *
FROM STG_TRAINING
WHERE TRAINING_DATE IS NULL;

-- Check for invalid duration
SELECT *
FROM STG_TRAINING
WHERE DURATION_HOURS < 0;

-- Check normalized categories
SELECT DISTINCT CATEGORY
FROM STG_TRAINING
ORDER BY CATEGORY;

-- Check normalized training names
SELECT DISTINCT TRAINING_NAME
FROM STG_TRAINING
ORDER BY TRAINING_NAME;