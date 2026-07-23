# Timesheets Module Documentation

## Project

**Project:** DavaX ETL

**Module:** Timesheets

**Author:** Bianca

---

# 1. Module Overview

The Timesheets module is responsible for importing, analysing, cleaning and transforming employee timesheet data before loading it into the Star Schema.

The implemented ETL pipeline follows the layered architecture required by the project.

```
Timesheets.csv
        │
        ▼
SOURCE_TIMESHEETS
        │
        ▼
STAGING_TIMESHEETS
        │
        ▼
DIM_DATE
DIM_PROJECT
DIM_EMPLOYEE
DIM_ACTIVITY_TYPE
        │
        ▼
FACT_ACTIVITY
```

---

# 2. Source Dataset

Source file:

```
Timesheets.csv
```

Imported into:

```
SOURCE_TIMESHEETS
```

Initial statistics:

| Metric | Value |
|---------|------:|
| Imported Rows | 3074 |
| Distinct Employees | 80 |
| Distinct Projects | 8 |

---

# 3. Source Layer

The SOURCE layer stores the original CSV data exactly as received.

No transformations are applied in this layer.

The objective of the SOURCE layer is to preserve the original data and guarantee traceability throughout the ETL process.

Columns such as `WorkDate` and `Hours` are intentionally stored as `VARCHAR2` because data conversion is performed only in the STAGING layer.

---

# 4. Data Profiling

Several SQL profiling queries were executed in order to analyse the quality of the source data before implementing the ETL process.

The following data quality issues were identified.

| Issue | Description |
|--------|-------------|
| Employee IDs with leading/trailing spaces | Some Employee IDs contained unnecessary spaces. |
| Employee IDs with inconsistent case | Employee IDs were stored using both uppercase and lowercase letters (example: E019 / e019). |
| Inconsistent Project Codes | The same project appeared with different codes (PRJ01 / PRJ-01). |
| Inconsistent Project Names | Project names had inconsistent capitalization (Banking App / banking app). |
| Missing Project Names | 61 records contained NULL values. |
| Duplicate Records | 24 duplicate Timesheet records were identified. |
| WorkDate stored as text | Dates required conversion to DATE. |
| Hours stored as text | Hours required conversion to NUMBER. |

---

# 5. Staging Layer

The STAGING layer contains cleaned and standardized data.

Unlike the SOURCE layer, STAGING performs all required transformations before the data is loaded into the Star Schema.

The following transformations were implemented.

| Source Data | Transformation |
|--------------|----------------|
| EmployeeId | TRIM + UPPER |
| EmployeeName | INITCAP(LOWER()) |
| Grade | INITCAP(LOWER()) |
| Discipline | INITCAP(LOWER()) |
| LineManager | INITCAP(LOWER()) |
| DeliveryUnit | INITCAP(LOWER()) |
| WorkDate | TO_DATE |
| ProjectCode | REPLACE('-', '') |
| ProjectName | INITCAP(LOWER()) + NVL |
| Hours | TO_NUMBER |

Additional ETL metadata was also added:

- SourceSystem
- LoadTimestamp

Duplicate business records were removed using the ROW_NUMBER() analytic function.

---

# 6. Loading the Star Schema

After the data was standardized, it was loaded into the dimensional model.

The following dimension tables are populated from STAGING_TIMESHEETS.

## DIM_DATE

Contains one row for every distinct calendar date.

Attributes generated:

- DateKey
- FullDate
- Day
- Month
- Quarter
- Year
- Week
- Day Name
- Weekend Indicator

---

## DIM_PROJECT

Contains one row for every unique project.

Projects are grouped by ProjectCode.

Duplicate projects are prevented using:

```
WHERE NOT EXISTS(...)
```

---

## DIM_EMPLOYEE

Contains one row for every employee.

Employees are grouped by EmployeeId.

Duplicate employees are prevented using:

```
WHERE NOT EXISTS(...)
```

---

## DIM_ACTIVITY_TYPE

For the Timesheets module only one activity type exists.

```
WORK
```

---

## FACT_ACTIVITY

FACT_ACTIVITY represents the final output of the ETL process.

One row represents one employee activity for one calendar day.

Business keys were replaced with surrogate keys by joining the dimension tables.

The following joins were performed:

- STAGING_TIMESHEETS → DIM_EMPLOYEE
- STAGING_TIMESHEETS → DIM_PROJECT
- STAGING_TIMESHEETS → DIM_DATE
- STAGING_TIMESHEETS → DIM_ACTIVITY_TYPE

The following values are stored in FACT_ACTIVITY:

- EmployeeKey
- DateKey
- ActivityTypeKey
- ProjectKey
- TrainingKey (NULL for Timesheets)
- HoursWorked
- SourceSystem
- LoadTimestamp

---

# 7. Validation

Validation was performed after every ETL step.

Validation included:

- Imported row count
- Duplicate detection
- Employee ID standardization
- Project code normalization
- Project name consistency
- NULL value checks
- Hours validation
- Date validation
- Referential integrity
- Fact table validation

All validation checks returned the expected results.

---

# 8. ETL Scripts Developed

## Source

- 01_create_source_timesheets.sql

---

## Validation

- 01_profile_source_timesheets.sql

- 02_validate_staging_timesheets.sql

- 03_validate_fact_activity.sql

---

## Staging

- 01_create_staging_timesheets.sql

- 02_load_staging_timesheets.sql

---

## Target

- 01_load_dim_date.sql

- 02_load_dim_project.sql

- 03_load_dim_employee.sql

- 04_load_dim_activity_type.sql

- 05_load_fact_activity.sql

---

# 9. Design Decisions

The following design decisions were made during the implementation.

- SOURCE preserves the original data.
- All data cleansing is performed in STAGING.
- Duplicate business records are removed before loading the Star Schema.
- Dimension tables contain unique business entities.
- FactActivity stores only surrogate keys.
- ETL scripts are idempotent by using WHERE NOT EXISTS.
- Every ETL step is validated before continuing to the next layer.

---

# 10. Conclusion

The Timesheets module implements a complete ETL process from raw source data to the Star Schema.

The implementation includes:

- source ingestion
- data profiling
- data cleansing
- data standardization
- duplicate removal
- dimensional loading
- fact loading
- validation

The final output is a clean, validated dataset ready for reporting and analytical queries.