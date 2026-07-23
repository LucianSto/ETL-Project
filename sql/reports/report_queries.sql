-- 1. Numarul total de activitati pentru fiecare sursa de date
SELECT
    source_system,
    COUNT(*) AS total_activities
FROM fact_activity
GROUP BY source_system
ORDER BY total_activities DESC;


-- 2. Numarul total de activitati inregistrate in FACT_ACTIVITY
SELECT
    COUNT(*) AS total_activities
FROM fact_activity;


-- 3. Totalul orelor inregistrate pentru fiecare sursa de date
SELECT
    source_system,
    SUM(hours_worked) AS total_hours
FROM fact_activity
GROUP BY source_system
ORDER BY total_hours DESC;


-- 4. Numarul de activitati pentru fiecare tip de activitate
SELECT
    a.activity_type_name,
    a.category,
    COUNT(*) AS total_activities
FROM fact_activity f
JOIN dim_activity_type a
    ON a.activity_type_key = f.activity_type_key
GROUP BY
    a.activity_type_name,
    a.category
ORDER BY total_activities DESC;


-- 5. Totalul orelor lucrate pentru fiecare angajat
SELECT
    e.employee_id,
    e.employee_name,
    SUM(f.hours_worked) AS total_hours
FROM fact_activity f
JOIN dim_employee e
    ON e.employee_key = f.employee_key
GROUP BY
    e.employee_id,
    e.employee_name
ORDER BY total_hours DESC;


-- 6. Primii 10 angajati cu cele mai multe activitati inregistrate
SELECT
    employee_id,
    employee_name,
    total_activities
FROM
(
    SELECT
        e.employee_id,
        e.employee_name,
        COUNT(*) AS total_activities
    FROM fact_activity f
    JOIN dim_employee e
        ON e.employee_key = f.employee_key
    GROUP BY
        e.employee_id,
        e.employee_name
    ORDER BY total_activities DESC
)
WHERE ROWNUM <= 10;


-- 7. Numarul de activitati si totalul orelor pentru fiecare DELIVERY_UNIT
SELECT
    e.delivery_unit,
    COUNT(*) AS total_activities,
    SUM(f.hours_worked) AS total_hours
FROM fact_activity f
JOIN dim_employee e
    ON e.employee_key = f.employee_key
GROUP BY e.delivery_unit
ORDER BY total_activities DESC;


-- 8. Numarul de activitati si totalul orelor pentru fiecare proiect
SELECT
    p.project_code,
    p.project_name,
    COUNT(*) AS total_activities,
    SUM(f.hours_worked) AS total_hours
FROM fact_activity f
JOIN dim_project p
    ON p.project_key = f.project_key
WHERE f.project_key IS NOT NULL
GROUP BY
    p.project_code,
    p.project_name
ORDER BY total_hours DESC;


-- 9. Numarul de participari la training pentru fiecare training
SELECT
    t.training_name,
    t.category,
    COUNT(*) AS total_attendances
FROM fact_activity f
JOIN dim_training t
    ON t.training_key = f.training_key
WHERE f.training_key IS NOT NULL
GROUP BY
    t.training_name,
    t.category
ORDER BY total_attendances DESC;


-- 10. Raport complet al activitatilor inregistrate in FACT_ACTIVITY
SELECT
    e.employee_id,
    e.employee_name,
    d.full_date,
    a.activity_type_name,
    p.project_name,
    t.training_name,
    f.hours_worked,
    f.source_system
FROM fact_activity f
JOIN dim_employee e
    ON e.employee_key = f.employee_key
JOIN dim_date d
    ON d.date_key = f.date_key
JOIN dim_activity_type a
    ON a.activity_type_key = f.activity_type_key
LEFT JOIN dim_project p
    ON p.project_key = f.project_key
LEFT JOIN dim_training t
    ON t.training_key = f.training_key
ORDER BY
    d.full_date,
    e.employee_name;