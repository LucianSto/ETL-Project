/* ============================================================
   LOAD DIM_EMPLOYEE
   Inserts only new employees from STG_TRAINING
   ============================================================ */

INSERT INTO DIM_EMPLOYEE
(
    EMPLOYEE_ID,
    EMPLOYEE_NAME,
    GRADE,
    DISCIPLINE,
    LINE_MANAGER,
    DELIVERY_UNIT
)
SELECT DISTINCT
    ST.EMPLOYEE_ID,
    ST.EMPLOYEE_NAME,
    ST.GRADE,
    ST.DISCIPLINE,
    ST.LINE_MANAGER,
    ST.DELIVERY_UNIT
FROM STG_TRAINING ST
WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_EMPLOYEE DE
    WHERE DE.EMPLOYEE_ID = ST.EMPLOYEE_ID
);