/*
Module  : DU Schedule
Layer   : TARGET

Purpose:
Populate DIM_DATE using the distinct dates available
in STAGING_DUSCHEDULE.

Only missing dates are inserted.
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

SELECT DISTINCT

    TO_NUMBER(
        TO_CHAR(ActivityDate,'YYYYMMDD')
    ) AS DATE_KEY,

    ActivityDate,

    EXTRACT(DAY FROM ActivityDate),

    EXTRACT(MONTH FROM ActivityDate),

    TRIM(
        TO_CHAR(ActivityDate,'MONTH')
    ),

    TO_NUMBER(
        TO_CHAR(ActivityDate,'Q')
    ),

    EXTRACT(YEAR FROM ActivityDate),

    TO_NUMBER(
        TO_CHAR(ActivityDate,'IW')
    ),

    TRIM(
        TO_CHAR(ActivityDate,'DAY')
    ),

    CASE
        WHEN TO_CHAR(
                ActivityDate,
                'DY',
                'NLS_DATE_LANGUAGE=ENGLISH'
             ) IN ('SAT','SUN')
        THEN 'Y'
        ELSE 'N'
    END

FROM STAGING_DUSCHEDULE STG

WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_DATE DD
    WHERE DD.DATE_KEY =
          TO_NUMBER(TO_CHAR(STG.ActivityDate,'YYYYMMDD'))
);

COMMIT;