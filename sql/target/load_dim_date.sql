/*
Module  : Training
Layer   : TARGET

Purpose:
Load dates from STG_TRAINING into DIM_DATE.
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
        TO_CHAR(STG.TRAINING_DATE,'YYYYMMDD')
    ) AS DATE_KEY,

    STG.TRAINING_DATE,

    EXTRACT(DAY FROM STG.TRAINING_DATE),

    EXTRACT(MONTH FROM STG.TRAINING_DATE),

    TRIM(
        TO_CHAR(
            STG.TRAINING_DATE,
            'MONTH'
        )
    ),

    TO_NUMBER(
        TO_CHAR(
            STG.TRAINING_DATE,
            'Q'
        )
    ),

    EXTRACT(YEAR FROM STG.TRAINING_DATE),

    TO_NUMBER(
        TO_CHAR(
            STG.TRAINING_DATE,
            'IW'
        )
    ),

    TRIM(
        TO_CHAR(
            STG.TRAINING_DATE,
            'DAY'
        )
    ),

    CASE
        WHEN TO_CHAR(
                STG.TRAINING_DATE,
                'DY',
                'NLS_DATE_LANGUAGE=ENGLISH'
             )
             IN ('SAT','SUN')
        THEN 'Y'
        ELSE 'N'
    END

FROM STG_TRAINING STG

WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_DATE DD
    WHERE DD.DATE_KEY =
          TO_NUMBER(
              TO_CHAR(
                  STG.TRAINING_DATE,
                  'YYYYMMDD'
              )
          )
);