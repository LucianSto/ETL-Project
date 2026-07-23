-- ==========================================
-- load_dim_activity_type.sql -> Incarca tipurile de absenta normalizate in DIM_ACTIVITY_TYPE
-- ==========================================

MERGE INTO dim_activity_type target
USING
(
    SELECT DISTINCT
        normalized_absence_type AS activity_type_name,
        'Absence' AS category
    FROM staging_absences
    WHERE validation_status = 'VALID'
      AND normalized_absence_type IS NOT NULL
      AND normalized_absence_type <> 'Unknown'
) source
ON
(
    target.activity_type_name = source.activity_type_name
)
WHEN NOT MATCHED THEN
    INSERT
    (
        activity_type_name,
        category
    )
    VALUES
    (
        source.activity_type_name,
        source.category
    );