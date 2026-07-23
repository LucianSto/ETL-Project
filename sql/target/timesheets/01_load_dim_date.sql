/*
Module  : Timesheets
Layer   : TARGET

Purpose:
Populate DIM_DATE using the distinct dates available
in STAGING_TIMESHEETS.

Each calendar date is loaded only once.

*/



INSERT INTO DIM_DATE
(
    DATE_KEY,
    FULL_DATE,
    DAY_NUMBER,
    MONTH_NUMBER,
    MONTH_NAME,
    QUARTER_NUMBER,
    YEAR_NUMBER,
    WEEK_NUMBER,
    DAY_NAME,
    IS_WEEKEND
)

SELECT 

    -- Surrogate key in YYYYMMDD format
    TO_NUMBER(
        TO_CHAR(WORK_DATE,'YYYYMMDD')
    ) AS DATE_KEY,

    -- Original calendar date
    WORK_DATE AS FULL_DATE,

    -- Calendar day
    EXTRACT(DAY FROM WORK_DATE) AS DAY_NUMBER,

    -- Calendar month
    EXTRACT(MONTH FROM WORK_DATE) AS MONTH_NUMBER,

    -- Month name
    TRIM(
        TO_CHAR(
            WORK_DATE,
            'MONTH'
        )
    ) AS MONTH_NAME,

    -- Quarter
    TO_NUMBER(
        TO_CHAR(
            WORK_DATE,
            'Q'
        )
    ) AS QUARTER_NUMBER,

    -- Calendar year
    EXTRACT(YEAR FROM WORK_DATE) AS YEAR_NUMBER,

    -- ISO week number
    TO_NUMBER(
        TO_CHAR(
            WORK_DATE,
            'IW'
        )
    ) AS WEEK_NUMBER,

    -- Day name
    TRIM(
        TO_CHAR(
            WORK_DATE,
            'DAY'
        )
    ) AS DAY_NAME,

    -- Weekend indicator
    CASE

        WHEN TO_CHAR(
                WORK_DATE,
                'DY',
                'NLS_DATE_LANGUAGE=ENGLISH'
             )
             IN ('SAT','SUN')

        THEN 'Y'

        ELSE 'N'

    END AS IS_WEEKEND

FROM STAGING_TIMESHEETS STG

------------------------------------------------------------
-- Prevent duplicate dimension records.
--
-- The NOT EXISTS condition makes the ETL idempotent,
-- allowing the script to be executed multiple times
-- without inserting duplicate rows.
------------------------------------------------------------
WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_DATE DD
    WHERE DD.DATE_KEY =
          TO_NUMBER(TO_CHAR(STG.WORK_DATE,'YYYYMMDD'))
)

ORDER BY FULL_DATE;

