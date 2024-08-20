WITH RECURSIVE
    consistent_hackers AS (
        SELECT
            submission_date
            , hacker_id
        FROM submissions
        WHERE submission_date = '2016-03-01'
        UNION ALL
        SELECT
            s.submission_date
            , s.hacker_id
        FROM submissions s
        INNER JOIN consistent_hackers h
            ON s.hacker_id = h.hacker_id
            AND s.submission_date = h.submission_date + INTERVAL '1 day'
    )

    , consistent_hackers_by_date AS (
        SELECT
            submission_date
            , COUNT(DISTINCT hacker_id) num_of_consistent_hackers
        FROM consistent_hackers
        GROUP BY submission_date
    )

    , submissions_by_hacker AS (
        SELECT
            submission_date
            , hacker_id
            , count(submission_id) num_of_submissions
        FROM submissions
        GROUP BY
            submission_date
            , hacker_id
    )

    , submissions_rank AS (
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

    , final_cte AS (
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
