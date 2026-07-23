/*
Module  : Timesheets
Layer   : TARGET

Purpose:
Populate DIM_ACTIVITY_TYPE with the activity types
used by the Timesheets module.

For this source system, only one activity type exists:
WORK.

*/

INSERT INTO DIM_ACTIVITY_TYPE
(
    ACTIVITY_TYPE_NAME,
    CATEGORY
)

SELECT
    'WORK',
    'Work'

FROM DUAL

WHERE NOT EXISTS
(
    SELECT 1

    FROM DIM_ACTIVITY_TYPE DAT

    WHERE DAT.ACTIVITY_TYPE_NAME = 'WORK'
);

