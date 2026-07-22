/* ============================================================
   TARGET MODEL - ETL DAVAX
   Schema curenta: HR
   ============================================================ */


/* ============================================================
   1. DIM_EMPLOYEE
   ============================================================ */

CREATE TABLE DIM_EMPLOYEE
(
    EMPLOYEE_KEY      NUMBER GENERATED ALWAYS AS IDENTITY,
    EMPLOYEE_ID       VARCHAR2(50) NOT NULL,
    EMPLOYEE_NAME     VARCHAR2(200) NOT NULL,
    GRADE             VARCHAR2(100),
    DISCIPLINE        VARCHAR2(150),
    LINE_MANAGER      VARCHAR2(200),
    DELIVERY_UNIT     VARCHAR2(150),

    CONSTRAINT PK_DIM_EMPLOYEE
        PRIMARY KEY (EMPLOYEE_KEY),

    CONSTRAINT UQ_DIM_EMPLOYEE_ID
        UNIQUE (EMPLOYEE_ID)
);


/* ============================================================
   2. DIM_DATE
   ============================================================ */

CREATE TABLE DIM_DATE
(
    DATE_KEY          NUMBER(8) NOT NULL,
    FULL_DATE         DATE NOT NULL,
    DAY_NUMBER        NUMBER(2) NOT NULL,
    MONTH_NUMBER      NUMBER(2) NOT NULL,
    MONTH_NAME        VARCHAR2(20) NOT NULL,
    QUARTER_NUMBER    NUMBER(1) NOT NULL,
    YEAR_NUMBER       NUMBER(4) NOT NULL,
    WEEK_NUMBER       NUMBER(2) NOT NULL,
    DAY_NAME          VARCHAR2(20),
    IS_WEEKEND        CHAR(1),

    CONSTRAINT PK_DIM_DATE
        PRIMARY KEY (DATE_KEY),

    CONSTRAINT UQ_DIM_DATE_FULL_DATE
        UNIQUE (FULL_DATE),

    CONSTRAINT CK_DIM_DATE_MONTH
        CHECK (MONTH_NUMBER BETWEEN 1 AND 12),

    CONSTRAINT CK_DIM_DATE_QUARTER
        CHECK (QUARTER_NUMBER BETWEEN 1 AND 4),

    CONSTRAINT CK_DIM_DATE_WEEKEND
        CHECK (IS_WEEKEND IN ('Y', 'N'))
);


/* ============================================================
   3. DIM_PROJECT
   ============================================================ */

CREATE TABLE DIM_PROJECT
(
    PROJECT_KEY       NUMBER GENERATED ALWAYS AS IDENTITY,
    PROJECT_CODE      VARCHAR2(100) NOT NULL,
    PROJECT_NAME      VARCHAR2(200),

    CONSTRAINT PK_DIM_PROJECT
        PRIMARY KEY (PROJECT_KEY),

    CONSTRAINT UQ_DIM_PROJECT_CODE
        UNIQUE (PROJECT_CODE)
);


/* ============================================================
   4. DIM_ACTIVITY_TYPE
   ============================================================ */

CREATE TABLE DIM_ACTIVITY_TYPE
(
    ACTIVITY_TYPE_KEY   NUMBER GENERATED ALWAYS AS IDENTITY,
    ACTIVITY_TYPE_NAME  VARCHAR2(100) NOT NULL,
    CATEGORY            VARCHAR2(100),

    CONSTRAINT PK_DIM_ACTIVITY_TYPE
        PRIMARY KEY (ACTIVITY_TYPE_KEY),

    CONSTRAINT UQ_DIM_ACTIVITY_TYPE_NAME
        UNIQUE (ACTIVITY_TYPE_NAME)
);


/* ============================================================
   5. DIM_TRAINING
   ============================================================ */

CREATE TABLE DIM_TRAINING
(
    TRAINING_KEY      NUMBER GENERATED ALWAYS AS IDENTITY,
    TRAINING_NAME     VARCHAR2(250) NOT NULL,
    CATEGORY          VARCHAR2(100),

    CONSTRAINT PK_DIM_TRAINING
        PRIMARY KEY (TRAINING_KEY),

    CONSTRAINT UQ_DIM_TRAINING_NAME
        UNIQUE (TRAINING_NAME)
);


/* ============================================================
   6. FACT_ACTIVITY
   O linie = activitatea unui angajat intr-o anumita zi.
   ============================================================ */

CREATE TABLE FACT_ACTIVITY
(
    ACTIVITY_KEY         NUMBER GENERATED ALWAYS AS IDENTITY,
    EMPLOYEE_KEY         NUMBER NOT NULL,
    DATE_KEY             NUMBER(8) NOT NULL,
    ACTIVITY_TYPE_KEY    NUMBER NOT NULL,
    PROJECT_KEY          NUMBER,
    TRAINING_KEY         NUMBER,
    HOURS_WORKED         NUMBER(8,2),
    SOURCE_SYSTEM        VARCHAR2(100) NOT NULL,
    LOAD_TIMESTAMP       TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_FACT_ACTIVITY
        PRIMARY KEY (ACTIVITY_KEY),

    CONSTRAINT FK_FACT_EMPLOYEE
        FOREIGN KEY (EMPLOYEE_KEY)
        REFERENCES DIM_EMPLOYEE (EMPLOYEE_KEY),

    CONSTRAINT FK_FACT_DATE
        FOREIGN KEY (DATE_KEY)
        REFERENCES DIM_DATE (DATE_KEY),

    CONSTRAINT FK_FACT_ACTIVITY_TYPE
        FOREIGN KEY (ACTIVITY_TYPE_KEY)
        REFERENCES DIM_ACTIVITY_TYPE (ACTIVITY_TYPE_KEY),

    CONSTRAINT FK_FACT_PROJECT
        FOREIGN KEY (PROJECT_KEY)
        REFERENCES DIM_PROJECT (PROJECT_KEY),

    CONSTRAINT FK_FACT_TRAINING
        FOREIGN KEY (TRAINING_KEY)
        REFERENCES DIM_TRAINING (TRAINING_KEY),

    CONSTRAINT CK_FACT_HOURS
        CHECK (
            HOURS_WORKED IS NULL
            OR HOURS_WORKED BETWEEN 0 AND 24
        )
);


/* ============================================================
   7. AUDIT_LOAD
   Tabel separat pentru evidenta proceselor ETL.
   ============================================================ */

CREATE TABLE AUDIT_LOAD
(
    AUDIT_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
    DATASET_NAME        VARCHAR2(100) NOT NULL,
    PROCESS_TIMESTAMP   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    SOURCE_ROWS         NUMBER DEFAULT 0 NOT NULL,
    LOADED_ROWS         NUMBER DEFAULT 0 NOT NULL,
    STATUS              VARCHAR2(30) NOT NULL,
    ERROR_MESSAGE       VARCHAR2(1000),

    CONSTRAINT PK_AUDIT_LOAD
        PRIMARY KEY (AUDIT_ID),

    CONSTRAINT CK_AUDIT_STATUS
        CHECK (STATUS IN ('STARTED', 'SUCCESS', 'FAILED', 'PARTIAL')),

    CONSTRAINT CK_AUDIT_SOURCE_ROWS
        CHECK (SOURCE_ROWS >= 0),

    CONSTRAINT CK_AUDIT_LOADED_ROWS
        CHECK (LOADED_ROWS >= 0)
);