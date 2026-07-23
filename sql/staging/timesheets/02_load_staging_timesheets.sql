/*
Module  : Timesheets
Layer   : STAGING
Purpose : Clean and load data from SOURCE_TIMESHEETS into
          STAGING_TIMESHEETS

This ETL process performs the following operations:

1. Removes leading/trailing spaces.
2. Standardizes text values.
3. Converts dates from VARCHAR2 to DATE.
4. Converts hours from VARCHAR2 to NUMBER.
5. Standardizes project codes.
6. Replaces missing project names.
7. Removes duplicate records.
8. Adds ETL metadata.

*/

INSERT INTO STAGING_TIMESHEETS
(
    TIMESHEET_ID,
    EMPLOYEE_ID,
    EMPLOYEE_NAME,
    GRADE,
    DISCIPLINE,
    LINE_MANAGER,
    DELIVERY_UNIT,
    WORK_DATE,
    PROJECT_CODE,
    PROJECT_NAME,
    HOURS,
    SOURCE_SYSTEM,
    LOAD_TIMESTAMP
)

SELECT

    -- *Remove unnecessary spaces from TimesheetId
    TRIM(TimesheetId) AS TIMESHEET_ID,

    -- *Standardize EmployeeId:
    -- 1. Remove leading/trailing spaces
    -- 2. Convert to uppercase
    UPPER(TRIM(EmployeeId)) AS EMPLOYEE_ID,

    -- *Standardize employee name format
    -- Example:
    -- "employee 1" -> "Employee 1"
    INITCAP(LOWER(TRIM(EmployeeName))) AS EMPLOYEE_NAME,

    -- *Standardize Grade values
    INITCAP(LOWER(TRIM(Grade))) AS GRADE,

    -- *Standardize Discipline values
    INITCAP(LOWER(TRIM(Discipline))) AS DISCIPLINE,

    -- *Standardize Line Manager names
    INITCAP(LOWER(TRIM(LineManager))) AS LINE_MANAGER,

    -- *Standardize Delivery Unit names
    INITCAP(LOWER(TRIM(DeliveryUnit))) AS DELIVERY_UNIT,

    -- *Convert WorkDate from VARCHAR2 to DATE
    TO_DATE(TRIM(WorkDate),'YYYY-MM-DD') AS WORK_DATE,

    -- *Normalize project codes
    -- Example: PRJ-01 -> PRJ01
    UPPER(REPLACE(TRIM(ProjectCode),'-','')) AS PROJECT_CODE,

    -- *Standardize project names.
    --
    -- Remove unnecessary spaces.
    -- Convert text to a consistent format.
    --
    -- If ProjectName is NULL, replace it with
    -- 'Unknown Project'.
    NVL(
        INITCAP(
            LOWER(
                TRIM(ProjectName)
            )
        ),
        'Unknown Project'
    ) AS PROJECT_NAME,

    -- *Convert Hours from VARCHAR2 to NUMBER
    TO_NUMBER(Hours) AS HOURS,

    -- *Constant identifying the source system
    'TIMESHEETS' AS SOURCE_SYSTEM,

    -- *Timestamp indicating when the ETL loaded the record
    SYSTIMESTAMP AS LOAD_TIMESTAMP

FROM
(
    -- Identify duplicate records.
    --
    -- ROW_NUMBER assigns:
    -- 1 -> first occurrence
    -- 2 -> duplicate
    -- 3 -> duplicate
    SELECT
        s.*,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                UPPER(TRIM(EmployeeId)),
                TO_DATE(TRIM(WorkDate), 'YYYY-MM-DD'),
                UPPER(REPLACE(TRIM(ProjectCode), '-', '')),
                TO_NUMBER(Hours)
             ORDER BY ROWID
        ) AS duplicate_number

        FROM SOURCE_TIMESHEETS s
)

-- *Keep only the first occurrence of each business.
WHERE duplicate_number = 1;
