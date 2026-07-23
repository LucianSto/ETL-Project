/*
=========================================================
Module  : DU Schedule
Layer   : TARGET

Purpose:
Populate DIM_EMPLOYEE using data from STAGING_DUSCHEDULE.

Only new employees are inserted.
=========================================================
*/

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
    STG.EmployeeId,
    STG.EmployeeName,
    STG.Grade,
    STG.Discipline,
    STG.LineManager,
    STG.DeliveryUnit

FROM STAGING_DUSCHEDULE STG

WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_EMPLOYEE DE
    WHERE DE.EMPLOYEE_ID = STG.EmployeeId
);

COMMIT;