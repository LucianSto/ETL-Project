-- ==========================================
-- Load Staging Absences
-- ==========================================

INSERT INTO staging_absences
(
    absence_id,
    employee_id,
    employee_name,
    grade,
    discipline,
    line_manager,
    delivery_unit,
    start_date,
    end_date,
    normalized_absence_type,
    validation_status,
    validation_message
)
SELECT
    TRIM(absence_id),
    UPPER(TRIM(employee_id)),
    TRIM(employee_name),
    TRIM(grade),
    TRIM(discipline),
    TRIM(line_manager),
    TRIM(delivery_unit),
    start_date,
    end_date,
    
    CASE
        WHEN UPPER(TRIM(absence_type)) IN ('AL', 'ANNUAL LEAVE')
            THEN 'Annual Leave'
        WHEN UPPER(TRIM(absence_type)) IN ('SL', 'SICK LEAVE')
            THEN 'Sick Leave'
        ELSE 'Unknown'
    END AS normalized_absence_type,
    
    CASE
        WHEN absence_id IS NULL
            THEN 'INVALID'
        WHEN employee_id IS NULL
            THEN 'INVALID'
        WHEN start_date IS NULL
            THEN 'INVALID'
        WHEN end_date IS NULL
            THEN 'INVALID'
        WHEN end_date < start_date
            THEN 'INVALID'
        WHEN UPPER(TRIM(absence_type)) NOT IN
            ('AL', 'ANNUAL LEAVE', 'SL', 'SICK LEAVE')
            THEN 'INVALID'
        ELSE 'VALID'
    END AS validation_status,
    
    CASE
        WHEN absence_id IS NULL
            THEN 'Missing AbsenceId'
        WHEN employee_id IS NULL
            THEN 'Missing EmployeeId'
        WHEN start_date IS NULL
            THEN 'Missing StartDate'
        WHEN end_date IS NULL
            THEN 'Missing EndDate'
        WHEN end_date < start_date
            THEN 'EndDate is before StartDate'
        WHEN UPPER(TRIM(absence_type)) NOT IN
            ('AL', 'ANNUAL LEAVE', 'SL', 'SICK LEAVE')
            THEN 'Unknown AbsenceType'
        ELSE NULL
    END AS validation_message
    
FROM source_absences;