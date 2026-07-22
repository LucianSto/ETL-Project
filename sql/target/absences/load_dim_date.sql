-- ==========================================
-- load_dim_date.sql -> Incarca datele calendaristice in DIM_DATE
-- ==========================================

MERGE INTO dim_date target
USING
(
    SELECT
        TO_NUMBER(TO_CHAR(calendar_date, 'YYYYMMDD')) AS date_key,
        calendar_date AS full_date,
        TO_NUMBER(TO_CHAR(calendar_date, 'DD')) AS day_number,
        TO_NUMBER(TO_CHAR(calendar_date, 'MM')) AS month_number,
        TRIM(
            TO_CHAR(
                calendar_date,
                'Month',
                'NLS_DATE_LANGUAGE=English'
            )
        ) AS month_name,
        TO_NUMBER(TO_CHAR(calendar_date, 'Q')) AS quarter_number,
        TO_NUMBER(TO_CHAR(calendar_date, 'YYYY')) AS year_number,
        TO_NUMBER(TO_CHAR(calendar_date, 'IW')) AS week_number,
        TRIM(
            TO_CHAR(
                calendar_date,
                'Day',
                'NLS_DATE_LANGUAGE=English'
            )
        ) AS day_name,
        CASE
            WHEN TO_CHAR(
                     calendar_date,
                     'DY',
                     'NLS_DATE_LANGUAGE=English'
                 ) IN ('SAT', 'SUN')
            THEN 'Y'
            ELSE 'N'
        END AS is_weekend
    FROM
    (
        SELECT
            min_date + LEVEL - 1 AS calendar_date
        FROM
        (
            SELECT
                MIN(start_date) AS min_date,
                MAX(end_date) AS max_date
            FROM staging_absences
            WHERE validation_status = 'VALID'
        )
        CONNECT BY LEVEL <= max_date - min_date + 1
    )
) source
ON
(
    target.full_date = source.full_date
)
WHEN NOT MATCHED THEN
    INSERT
    (
        date_key,
        full_date,
        day_number,
        month_number,
        month_name,
        quarter_number,
        year_number,
        week_number,
        day_name,
        is_weekend
    )
    VALUES
    (
        source.date_key,
        source.full_date,
        source.day_number,
        source.month_number,
        source.month_name,
        source.quarter_number,
        source.year_number,
        source.week_number,
        source.day_name,
        source.is_weekend
    );