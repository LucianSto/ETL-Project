-- ==========================================
-- load_fact_activity.sql -> Incarca datele despre absente in FACT_ACTIVITY
-- ==========================================

INSERT INTO fact_activity
(
    employee_key,
    date_key,
    activity_type_key,
    project_key,
    training_key,
    hours_worked,
    source_system
)
SELECT
    e.employee_key,
    d.date_key,
    a.activity_type_key,
    NULL AS project_key,
    NULL AS training_key,
    8 AS hours_worked,
    'Absences' AS source_system
FROM staging_absences s
INNER JOIN dim_employee e
    ON e.employee_id = s.employee_id
INNER JOIN dim_activity_type a
    ON a.activity_type_name = s.normalized_absence_type
INNER JOIN dim_date d
    ON d.full_date BETWEEN s.start_date AND s.end_date
WHERE s.validation_status = 'VALID'
  AND d.is_weekend = 'N'
  AND NOT EXISTS
  (
      SELECT 1
      FROM fact_activity f
      WHERE f.employee_key = e.employee_key
        AND f.date_key = d.date_key
        AND f.activity_type_key = a.activity_type_key
        AND f.source_system = 'Absences'
  );