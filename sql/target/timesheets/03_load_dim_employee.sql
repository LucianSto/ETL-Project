/*
Module  : Timesheets
Layer   : TARGET

Purpose:
Load unique employees from STAGING_TIMESHEETS into
DIM_EMPLOYEE.

Each employee is loaded only once based on EMPLOYEE_ID.

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

SELECT

    STG.EMPLOYEE_ID,

    STG.EMPLOYEE_NAME,

    STG.GRADE,

    STG.DISCIPLINE,

    STG.LINE_MANAGER,

    STG.DELIVERY_UNIT

FROM
(
    -- Group records by EMPLOYEE_ID.
    -- One employee must exist only once in DIM_EMPLOYEE.
    SELECT

        EMPLOYEE_ID,

        -- Choose one standardized value for each employee.
        MAX(EMPLOYEE_NAME) AS EMPLOYEE_NAME,

        MAX(GRADE) AS GRADE,

        MAX(DISCIPLINE) AS DISCIPLINE,

        MAX(LINE_MANAGER) AS LINE_MANAGER,

        MAX(DELIVERY_UNIT) AS DELIVERY_UNIT

    FROM STAGING_TIMESHEETS

    WHERE EMPLOYEE_ID IS NOT NULL

    GROUP BY EMPLOYEE_ID

) STG

-- Prevent duplicate employees from being inserted.
WHERE NOT EXISTS
(
    SELECT 1

    FROM DIM_EMPLOYEE DE

    WHERE DE.EMPLOYEE_ID = STG.EMPLOYEE_ID
);

