WITH
    today_user_actions AS (
        SELECT
            user_id
            , country
            , min(event_ts) first_login_ts
            , max(event_ts) last_login_ts
        FROM user_actions
        WHERE
            cast(from_unixtime(event_ts) AS DATE) = cast('2022-01-07' AS DATE)
            AND action = 'login_success'
        GROUP BY
            user_id
            , country
    )

    , today_users AS (
        SELECT
            coalesce(u.user_id, a.user_id) user_id
            , coalesce(u.country, a.country) country
            , coalesce(u.first_login_ts, a.first_login_ts) first_login_ts
            , coalesce(a.last_login_ts, u.last_login_ts) last_login_ts
        FROM today_user_actions a
        FULL OUTER JOIN users u
            ON u.user_id = a.user_id
            AND u.partition_date = date_add('day', -1, cast('2022-01-07' AS DATE))
    )

    , user_segment AS (
        SELECT
            *
            , CASE
                  WHEN cast(from_unixtime(first_login_ts) AS DATE) = cast('2022-01-07' AS DATE) THEN 'NEW'
                  WHEN cast(from_unixtime(last_login_ts) AS DATE) >= date_add('day', -3, cast('2022-01-07' AS DATE)) THEN 'ACTIVE'
                  WHEN cast(from_unixtime(last_login_ts) AS DATE) >= date_add('day', -14, cast('2022-01-07' AS DATE)) THEN 'DORMANT'
                  WHEN cast(from_unixtime(last_login_ts) AS DATE) >= date_add('day', -30, cast('2022-01-07' AS DATE)) THEN 'INACTIVE'
                  ELSE 'NOT DEFINED'
              END AS user_segment
            , cast('2022-01-07' AS DATE) AS partition_date
        FROM today_users
    )

SELECT *
FROM user_segment
;
