-- ==========================================
-- Validation Absences
-- ==========================================

-- 1. Verificare nr de randuri in Source
SELECT COUNT (*) AS source_row_count
FROM source_absecences;

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
   OR end_date IS NULL;

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