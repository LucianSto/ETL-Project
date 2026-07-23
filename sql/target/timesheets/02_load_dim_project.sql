/*
Module  : Timesheets
Layer   : TARGET

Purpose:
Load unique projects from STAGING_TIMESHEETS into DIM_PROJECT.

Each project is loaded only once based on PROJECT_CODE.

*/

INSERT INTO DIM_PROJECT
(
    PROJECT_CODE,
    PROJECT_NAME
)

SELECT
    STG.PROJECT_CODE,
    STG.PROJECT_NAME

FROM
(
    -- Group records by PROJECT_CODE.
    -- One project must exist only once in DIM_PROJECT.
    SELECT

        PROJECT_CODE,

        ----------------------------------------------------
        -- Choose the best available project name.
        --
        -- "Unknown Project" values are ignored if a valid
        -- project name exists for the same project code.
        --
        -- If all project names are unknown, keep
        -- "Unknown Project".
        ----------------------------------------------------
        NVL(
            MAX
            (
                CASE
                    WHEN PROJECT_NAME <> 'Unknown Project'
                    THEN PROJECT_NAME
                END
            ),
            'Unknown Project'
        ) AS PROJECT_NAME

    FROM STAGING_TIMESHEETS

    -- Ignore records with missing project codes.
    WHERE PROJECT_CODE IS NOT NULL

    GROUP BY PROJECT_CODE

) STG

------------------------------------------------------------
-- Prevent duplicate projects from being inserted.
--
-- This allows the ETL process to be executed multiple
-- times without violating the UNIQUE constraint on
-- PROJECT_CODE.
------------------------------------------------------------
WHERE NOT EXISTS
(
    SELECT 1

    FROM DIM_PROJECT DP

    WHERE DP.PROJECT_CODE = STG.PROJECT_CODE
);

