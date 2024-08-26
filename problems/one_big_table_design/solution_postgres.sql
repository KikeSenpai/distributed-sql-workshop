WITH
    sql_sucks_posts AS (
        SELECT
            a.action_id
            , a.post_id
            , a.action_time
            , a.action
            , p.is_deleted
            , p.post_content
        FROM post_actions a
        INNER JOIN posts p
            ON a.post_id = p.post_id
            AND p.is_deleted IS TRUE
            AND p.post_content ILIKE '%SQL sucks%'
        WHERE a.action = 'like'
    )
SELECT
    post_id
    , COUNT(post_id) num_of_likes
FROM sql_sucks_posts
GROUP BY post_id
;
