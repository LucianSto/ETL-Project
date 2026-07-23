-- ==========================================
-- Validation Absences
-- ==========================================

-- 1. Verificare nr de randuri in Source
SELECT COUNT (*) AS source_row_count
FROM source_absences;

-- 2. Verificare nr de randuri in Staging
SELECT COUNT(*) AS staging_row_count
FROM staging_absences;

-- 3. Distributia randurilor VALIDE si INVALIDE
SELECT
    validation_status,
    COUNT(*) AS row_count
FROM staging_absences
GROUP BY validation_status
ORDER BY validation_status;

-- 4. Afisare randuri INVALIDE
SELECT *
FROM staging_absences
WHERE validation_status = 'INVALID';

-- 5. Verificarea tipurilor de absente normalizate
SELECT
    normalized_absence_type,
    COUNT(*) AS row_count
FROM staging_absences
GROUP BY normalized_absence_type
ORDER BY normalized_absence_type;

-- 6. Verificarea EmployeeID dupa curatare (TRIM - elimina spatiile | UPPER - transforma in majuscule)
SELECT *
FROM staging_absences
WHERE employee_id <> UPPER(TRIM(employee_id));

-- 7. Verificare daca exista absente cu end_date mai mic decat start_date
SELECT *
FROM staging_absences
WHERE end_date < start_date;

-- 8. Verificarea valorilor obligatorii lipsa
SELECT *
FROM staging_absences
WHERE absence_id IS NULL
   OR employee_id IS NULL
   OR start_date IS NULL
   OR end_date IS NULL
   OR normalized_absence_type IS NULL;

-- 9. Verificarea duplicatelor pe baza AbsenceID
SELECT
    absence_id,
    COUNT(*) AS duplicate_count
FROM staging_absences
GROUP BY absence_id
HAVING COUNT(*) > 1;

-- 10. Compararea numarului de randuri intre Source si Staging (daca absentele au fost incarcate corect)
SELECT
    (SELECT COUNT(*) FROM source_absences) AS source_rows,
    (SELECT COUNT(*) FROM staging_absences) AS staging_rows
FROM dual;

-- 11. Verificarea daca toti angajatii valizi exista in DIM_EMPLOYEE
SELECT DISTINCT
    s.employee_id
FROM staging_absences s
LEFT JOIN dim_employee e
    ON e.employee_id = s.employee_id
WHERE s.validation_status = 'VALID'
    AND e.employee_key IS NULL;

-- 12. Verificarea daca toate tipurile de absenta exista in DIM_ACTIVITY_TYPE
SELECT DISTINCT
    s.normalized_absence_type
FROM staging_absences s
LEFT JOIN dim_activity_type a
    ON a.activity_type_name = s.normalized_absence_type
WHERE s.validation_status = 'VALID'
    AND a.activity_type_key IS NULL;

-- 13. Verificarea numarului de randuri in FACT_ACTIVITY pentru absente
SELECT COUNT(*) AS fact_absences_row_count
FROM fact_activity
WHERE source_system = 'Absences';