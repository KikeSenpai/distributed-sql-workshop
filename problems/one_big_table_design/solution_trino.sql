WITH
    posts AS (
        SELECT
            post_id
            , is_deleted
            , post_content
        FROM posts
    )

    , actions_1 AS (
        SELECT *
        FROM post_actions
        WHERE cast(action_time AS DATE) = cast('2024-08-24' AS DATE)
    )

    , actions_agg AS (
        SELECT
            p.post_id
            , p.is_deleted
            , p.post_content
            , array_agg(
                CASE
                    WHEN a.action IS NOT NULL AND a.action_time IS NOT NULL
                        THEN cast(row(a.action, a.action_time) AS ROW(type VARCHAR, event_time TIMESTAMP))
                END) actions
        FROM posts p
        LEFT JOIN actions_1 a
            ON p.post_id = a.post_id
        GROUP BY
            p.post_id
            , p.is_deleted
            , p.post_content
    )

    , actions_2 AS (
        SELECT
            post_id
            , array_agg(cast(row("action", action_time) AS ROW (type VARCHAR, event_time TIMESTAMP))) actions
        FROM post_actions
        WHERE cast(action_time AS DATE) = cast('2024-08-25' AS DATE)
        GROUP BY post_id
    )

    , posts_obt_ini AS (
        SELECT
            post_id
            , is_deleted
            , post_content
            , CASE
                WHEN actions[1] IS NULL THEN ARRAY[]
                ELSE actions
            END actions
        FROM actions_agg
    )

    , posts_obt AS (
        SELECT
            p.post_id
            , p.is_deleted
            , p.post_content
            , concat(p.actions, coalesce(a.actions, array[])) all_actions
        FROM posts_obt_ini p
        LEFT JOIN actions_2 a
            ON p.post_id = a.post_id
    )

    , like_count AS (
        SELECT
            *
            , reduce(
                all_actions,
                0,
                (s, x) -> CASE WHEN x.type = 'like' THEN s + 1 ELSE s END,
                s -> s
              ) like_count
        FROM posts_obt
        WHERE post_content LIKE '%SQL sucks%'
    )

SELECT *
FROM like_count
;
