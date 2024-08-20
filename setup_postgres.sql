-- Cumulative Distinct Count
CREATE TABLE IF NOT EXISTS problems.public.hackers (
    hacker_id   INT PRIMARY KEY,
    hacker_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS problems.public.submissions (
    submission_date TIMESTAMP,
    submission_id   INT PRIMARY KEY,
    hacker_id       INT,
    score           INT
);

COPY problems.public.hackers (hacker_id, hacker_name)
    FROM '/data/hackers.csv'
    DELIMITER ','
    CSV HEADER;

COPY problems.public.submissions (submission_date, submission_id, hacker_id, score)
    FROM '/data/submissions.csv'
    DELIMITER ','
    CSV HEADER;

-- Cumulative Table Design
CREATE TABLE IF NOT EXISTS problems.public.user_actions (
    event_id UUID PRIMARY KEY,
    user_id  INT,
    country  VARCHAR(2),
    event_ts BIGINT,
    action   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS problems.public.users (
    user_id        INT PRIMARY KEY,
    country        VARCHAR(2),
    first_login_ts BIGINT,
    last_login_ts  BIGINT,
    user_segment   VARCHAR(10),
    partition_date DATE
);

COPY problems.public.user_actions (event_id, user_id, country, event_ts, action)
    FROM '/data/user_actions.csv'
    DELIMITER ','
    CSV HEADER;

COPY problems.public.users (user_id, country, first_login_ts, last_login_ts, user_segment, partition_date)
    FROM '/data/users.csv'
    DELIMITER ','
    CSV HEADER;
