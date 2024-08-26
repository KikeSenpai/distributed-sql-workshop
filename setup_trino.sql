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

-- One Big Table Design
CREATE TABLE IF NOT EXISTS hive.problems.posts (
    post_id        INT,
    user_id        INT,
    post_content   VARCHAR,
    post_time      TIMESTAMP,
    start_time     TIMESTAMP,
    end_time       TIMESTAMP,
    is_deleted     BOOLEAN,
    is_current     BOOLEAN,
    partition_date DATE
) WITH (
    external_location = 's3a://problems/posts/',
    format = 'PARQUET'
);

CREATE TABLE IF NOT EXISTS hive.problems.post_actions (
    action_id   VARCHAR,
    post_id     INT,
    action      VARCHAR,
    action_time TIMESTAMP
) WITH (
    external_location = 's3a://problems/post_actions/',
    format = 'PARQUET'
);
