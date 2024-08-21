WITH
    today_user_actions AS (
        SELECT
            user_id
            , country
            , MIN(event_ts) first_login_ts
            , MAX(event_ts) last_login_ts
        FROM user_actions
        WHERE
            TO_TIMESTAMP(event_ts)::DATE = '2022-01-07'
            AND action = 'login_success'
        GROUP BY
            user_id
            , country
    )

    , today_users AS (
        SELECT
            COALESCE(u.user_id, a.user_id) AS user_id
            , COALESCE(u.country, a.country) AS country
            , COALESCE(u.first_login_ts, a.first_login_ts) AS first_login_ts
            , COALESCE(a.last_login_ts, u.last_login_ts) AS last_login_ts
        FROM today_user_actions a
        FULL OUTER JOIN users u
            ON u.user_id = a.user_id
            AND u.partition_date = '2022-01-07'::DATE - INTERVAL '1 day'
    )

    , user_segment AS (
        SELECT
            *
            , CASE
                  WHEN TO_TIMESTAMP(first_login_ts)::DATE = '2022-01-07'::DATE THEN 'NEW'
                  WHEN TO_TIMESTAMP(last_login_ts)::DATE >= '2022-01-07'::DATE - INTERVAL '3 days' THEN 'ACTIVE'
                  WHEN TO_TIMESTAMP(last_login_ts)::DATE >= '2022-01-07'::DATE - INTERVAL '14 days' THEN 'DORMANT'
                  WHEN TO_TIMESTAMP(last_login_ts)::DATE >= '2022-01-07'::DATE - INTERVAL '30 days' THEN 'INACTIVE'
                  ELSE 'NOT DEFINED'
              END AS user_segment
            , '2022-01-07'::DATE AS partition_date
        FROM today_users
    )

SELECT *
FROM user_segment
;
