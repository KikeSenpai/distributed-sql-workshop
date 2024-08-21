CREATE SCHEMA IF NOT EXISTS hive.problems
    WITH (location = 's3a://problems/');

-- Cumulative Distinct Count
CREATE TABLE IF NOT EXISTS hive.problems.hackers (
    hacker_id   INT,
    hacker_name VARCHAR
) WITH (
    external_location = 's3a://problems/hackers/',
    format = 'PARQUET'
);

CREATE TABLE IF NOT EXISTS hive.problems.submissions (
    submission_date DATE,
    submission_id   INT,
    hacker_id       INT,
    score           INT
) WITH (
    external_location = 's3a://problems/submissions/',
    format = 'PARQUET'
);

-- Cumulative Table Design
CREATE TABLE IF NOT EXISTS hive.problems.user_actions (
    event_id VARCHAR,
    user_id  INT,
    country  VARCHAR,
    event_ts BIGINT,
    action   VARCHAR
) WITH (
    external_location = 's3a://problems/user_actions/',
    format = 'PARQUET'
);

CREATE TABLE IF NOT EXISTS hive.problems.users (
    user_id        INT,
    country        VARCHAR,
    first_login_ts BIGINT,
    last_login_ts  BIGINT,
    user_segment   VARCHAR,
    partition_date DATE
) WITH (
    external_location = 's3a://problems/users/',
    format = 'PARQUET'
);
