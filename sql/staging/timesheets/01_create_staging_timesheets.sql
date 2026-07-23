/*
Module  : Timesheets
Layer   : STAGING
Purpose : Create the cleaned Timesheets staging table 

*/


--STAGING Layer Design

/*
Unlike SOURCE_TIMESHEETS, the staging table stores cleaned
and standardized data.

Main differences compared to SOURCE:

1. Data type conversion
   - WORK_DATE is converted from VARCHAR2 to DATE.
   - HOURS is converted from VARCHAR2 to NUMBER(4,1).

   NUMBER(4,1) allows values such as:
      8.0
      7.5
      12.0
      999.9

2. Additional ETL metadata
   - SOURCE_SYSTEM stores the origin of the data
     (constant value: 'TIMESHEETS').
   - LOAD_TIMESTAMP stores the date and time when the ETL
     process loaded the record into the staging layer.

*/
CREATE TABLE STAGING_TIMESHEETS
(
    TIMESHEET_ID       VARCHAR2(30),
    EMPLOYEE_ID        VARCHAR2(30),
    EMPLOYEE_NAME      VARCHAR2(100),
    GRADE              VARCHAR2(30),
    DISCIPLINE         VARCHAR2(50),
    LINE_MANAGER       VARCHAR2(100),
    DELIVERY_UNIT      VARCHAR2(100),
    WORK_DATE          DATE,
    PROJECT_CODE       VARCHAR2(30),
    PROJECT_NAME       VARCHAR2(150),
    HOURS              NUMBER(4,1),

    SOURCE_SYSTEM      VARCHAR2(30),
    LOAD_TIMESTAMP     TIMESTAMP
);


