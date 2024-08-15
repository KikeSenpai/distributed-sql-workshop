WITH
    unique_hackers AS (
        SELECT
            cast(submission_date AS DATE) AS submission_date
            , array_agg(DISTINCT hacker_id) AS unique_hackers
        FROM submissions
        GROUP BY submission_date
    )

    , cumulative_hackers AS (
        SELECT
            submission_date
            , array_agg(unique_hackers) OVER (ORDER BY submission_date) AS cumulative_hackers
        FROM unique_hackers
    )

    , consistent_hackers AS (
        SELECT
            submission_date
            , cardinality(reduce(
                cumulative_hackers
                , element_at(cumulative_hackers, 1)
                , (s, x) -> array_intersect(s, x)
                , s -> s
            )) num_of_consistent_hackers
        FROM cumulative_hackers
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
            , row_number() OVER (
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
        FROM consistent_hackers h
        LEFT JOIN submissions_rank s
            ON s.submission_date = h.submission_date
            AND rnk = 1
    )

SELECT *
FROM final_cte
;
