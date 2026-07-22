-- ==========================================
-- load_dim_employee.sql -> Incarca angajatii valizi din STAGING_ABSENCES in DIM_EMPLOYEE
-- ==========================================

MERGE INTO dim_employee target
USING
(
    SELECT
        employee_id,
        MAX(employee_name) AS employee_name,
        MAX(grade) AS grade,
        MAX(discipline) AS discipline,
        MAX(line_manager) AS line_manager,
        MAX(delivery_unit) AS delivery_unit
    FROM staging_absences
    WHERE validation_status = 'VALID'
      AND employee_id IS NOT NULL
    GROUP BY employee_id
) source
ON
(
    target.employee_id = source.employee_id
)
WHEN NOT MATCHED THEN
    INSERT
    (
        employee_id,
        employee_name,
        grade,
        discipline,
        line_manager,
        delivery_unit
    )
    VALUES
    (
        source.employee_id,
        source.employee_name,
        source.grade,
        source.discipline,
        source.line_manager,
        source.delivery_unit
    );