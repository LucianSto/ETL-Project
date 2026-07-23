/*
=========================================================
Module  : DU Schedule
Layer   : TARGET

Purpose:
Populate DIM_ACTIVITY_TYPE using data from STAGING_DUSCHEDULE.

Only new activity types are inserted.
=========================================================
*/

INSERT INTO DIM_ACTIVITY_TYPE
(
    ACTIVITY_TYPE_NAME,
    CATEGORY
)

SELECT DISTINCT

    STG.ActivityCode,

    CASE STG.ActivityCode

        WHEN 'W' THEN 'Work'
        WHEN 'TR' THEN 'Training'
        WHEN 'EX' THEN 'Exam'
        WHEN 'AL' THEN 'Annual Leave'
        WHEN 'SL' THEN 'Sick Leave'

        ELSE 'Other'

    END AS CATEGORY

FROM STAGING_DUSCHEDULE STG

WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_ACTIVITY_TYPE DAT
    WHERE DAT.ACTIVITY_TYPE_NAME = STG.ActivityCode
);

COMMIT;