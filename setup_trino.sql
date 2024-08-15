CREATE SCHEMA IF NOT EXISTS hive.problems
    WITH (location = 's3a://problems/');

CREATE TABLE IF NOT EXISTS hive.problems.hackers (
    hacker_id   INT,
    hacker_name VARCHAR
) WITH (
    external_location = 's3a://problems/hackers/',
    format = 'PARQUET'
);

CREATE TABLE IF NOT EXISTS hive.problems.submissions (
    submission_date TIMESTAMP,
    submission_id   INT,
    hacker_id       INT,
    score           INT
) WITH (
    external_location = 's3a://problems/submissions/',
    format = 'PARQUET'
);
