SET SESSION max_recursion_depth = 150;

WITH RECURSIVE
    consistent_hackers (submission_date, hacker_id) AS (
        SELECT
            submission_date
            , hacker_id
        FROM submissions
        WHERE submission_date = cast('2016-03-01' AS DATE)
        UNION ALL
        SELECT
            s.submission_date
            , s.hacker_id
        FROM submissions s
        INNER JOIN consistent_hackers h
            ON s.hacker_id = h.hacker_id
            AND s.submission_date = date_add('day', 1, h.submission_date)
    )

    , consistent_hackers_by_date (submission_date, num_of_consistent_hackers) AS (
        SELECT
            submission_date
            , COUNT(DISTINCT hacker_id) num_of_consistent_hackers
        FROM consistent_hackers
        GROUP BY submission_date
    )

    , submissions_by_hacker (submission_date, hacker_id, num_of_submissions) AS (
        SELECT
            submission_date
            , hacker_id
            , count(submission_id) num_of_submissions
        FROM submissions
        GROUP BY
            submission_date
            , hacker_id
    )

    , submissions_rank (submission_date, hacker_id, hacker_name, rnk) AS (
        SELECT
            s.submission_date
            , s.hacker_id
            , h.hacker_name
            , ROW_NUMBER() OVER (
                PARTITION BY s.submission_date
                ORDER BY s.num_of_submissions DESC, s.hacker_id
            ) rnk
        FROM submissions_by_hacker s
        LEFT JOIN hackers h
            ON s.hacker_id = h.hacker_id
    )

    , final_cte (submission_date, num_of_consistent_hackers, hacker_id, hacker_name) AS (
        SELECT
            h.submission_date
            , h.num_of_consistent_hackers
            , s.hacker_id
            , s.hacker_name
        FROM consistent_hackers_by_date h
        LEFT JOIN submissions_rank s
            ON s.submission_date = h.submission_date
            AND rnk = 1
    )

SELECT *
FROM final_cte
;
