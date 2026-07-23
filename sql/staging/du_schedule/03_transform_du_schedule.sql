-- File: 03_transform_du_schedule.sql
-- Purpose: Transform DU Schedule from matrix format to tabular format.
-- Layer: STAGING

INSERT INTO STAGING_DUSCHEDULE
(
    EmployeeId,
    EmployeeName,
    Grade,
    Discipline,
    LineManager,
    DeliveryUnit,
    ActivityDate,
    ActivityCode
)
SELECT
    EmployeeId,
    EmployeeName,
    Grade,
    Discipline,
    LineManager,
    DeliveryUnit,
    ActivityDate,
    ActivityCode
FROM SOURCE_DUSCHEDULE
UNPIVOT
(
    ActivityCode
    FOR ActivityDate IN
    (
        "01-Jun" AS DATE '2026-06-01',
        "02-Jun" AS DATE '2026-06-02',
        "03-Jun" AS DATE '2026-06-03',
        "04-Jun" AS DATE '2026-06-04',
        "05-Jun" AS DATE '2026-06-05',
        "06-Jun" AS DATE '2026-06-06',
        "07-Jun" AS DATE '2026-06-07',
        "08-Jun" AS DATE '2026-06-08',
        "09-Jun" AS DATE '2026-06-09',
        "10-Jun" AS DATE '2026-06-10',
        "11-Jun" AS DATE '2026-06-11',
        "12-Jun" AS DATE '2026-06-12',
        "13-Jun" AS DATE '2026-06-13',
        "14-Jun" AS DATE '2026-06-14',
        "15-Jun" AS DATE '2026-06-15',
        "16-Jun" AS DATE '2026-06-16',
        "17-Jun" AS DATE '2026-06-17',
        "18-Jun" AS DATE '2026-06-18',
        "19-Jun" AS DATE '2026-06-19',
        "20-Jun" AS DATE '2026-06-20',
        "21-Jun" AS DATE '2026-06-21',
        "22-Jun" AS DATE '2026-06-22',
        "23-Jun" AS DATE '2026-06-23',
        "24-Jun" AS DATE '2026-06-24',
        "25-Jun" AS DATE '2026-06-25',
        "26-Jun" AS DATE '2026-06-26',
        "27-Jun" AS DATE '2026-06-27',
        "28-Jun" AS DATE '2026-06-28',
        "29-Jun" AS DATE '2026-06-29',
        "30-Jun" AS DATE '2026-06-30',

        "01-Jul" AS DATE '2026-07-01',
        "02-Jul" AS DATE '2026-07-02',
        "03-Jul" AS DATE '2026-07-03',
        "04-Jul" AS DATE '2026-07-04',
        "05-Jul" AS DATE '2026-07-05',
        "06-Jul" AS DATE '2026-07-06',
        "07-Jul" AS DATE '2026-07-07',
        "08-Jul" AS DATE '2026-07-08',
        "09-Jul" AS DATE '2026-07-09',
        "10-Jul" AS DATE '2026-07-10',
        "11-Jul" AS DATE '2026-07-11',
        "12-Jul" AS DATE '2026-07-12',
        "13-Jul" AS DATE '2026-07-13',
        "14-Jul" AS DATE '2026-07-14',
        "15-Jul" AS DATE '2026-07-15',
        "16-Jul" AS DATE '2026-07-16',
        "17-Jul" AS DATE '2026-07-17',
        "18-Jul" AS DATE '2026-07-18',
        "19-Jul" AS DATE '2026-07-19',
        "20-Jul" AS DATE '2026-07-20',
        "21-Jul" AS DATE '2026-07-21',
        "22-Jul" AS DATE '2026-07-22',
        "23-Jul" AS DATE '2026-07-23',
        "24-Jul" AS DATE '2026-07-24',
        "25-Jul" AS DATE '2026-07-25',
        "26-Jul" AS DATE '2026-07-26',
        "27-Jul" AS DATE '2026-07-27',
        "28-Jul" AS DATE '2026-07-28',
        "29-Jul" AS DATE '2026-07-29',
        "30-Jul" AS DATE '2026-07-30'
    )
);

UPDATE STAGING_DUSCHEDULE
SET
    EmployeeId = TRIM(EmployeeId),
    EmployeeName = TRIM(EmployeeName),
    Grade = TRIM(Grade),
    Discipline = TRIM(Discipline),
    LineManager = TRIM(LineManager),
    DeliveryUnit = TRIM(DeliveryUnit),
    ActivityCode = TRIM(ActivityCode);

COMMIT;


UPDATE STAGING_DUSCHEDULE
SET ActivityCode = UPPER(ActivityCode);

COMMIT;


UPDATE STAGING_DUSCHEDULE
SET ActivityCode = NULL
WHERE TRIM(ActivityCode) IS NULL;

COMMIT;

