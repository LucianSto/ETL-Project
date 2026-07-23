/* ============================================================
   LOAD DIM_ACTIVITY_TYPE
   ============================================================ */

INSERT INTO DIM_ACTIVITY_TYPE
(
    ACTIVITY_TYPE_NAME,
    CATEGORY
)
SELECT
    'TRAINING',
    'Learning'
FROM DUAL
WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_ACTIVITY_TYPE
    WHERE ACTIVITY_TYPE_NAME = 'TRAINING'
);