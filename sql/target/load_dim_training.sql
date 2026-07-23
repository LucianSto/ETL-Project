/* ============================================================
   LOAD DIM_TRAINING
   Inserts only new trainings
   ============================================================ */

INSERT INTO DIM_TRAINING
(
    TRAINING_NAME,
    CATEGORY
)
SELECT
    ST.TRAINING_NAME,
    MIN(ST.CATEGORY)
FROM STG_TRAINING ST
WHERE NOT EXISTS
(
    SELECT 1
    FROM DIM_TRAINING DT
    WHERE DT.TRAINING_NAME = ST.TRAINING_NAME
)
GROUP BY ST.TRAINING_NAME;