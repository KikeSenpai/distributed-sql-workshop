# Problem Statement

Given a table containing a daily export of user login events. 
And another table containing the current users' information.
Design and write the SQL statement(s) to populate a new `users_snapshots` table on a daily basis.
The new table should enable analysts to perform a historical analysis on the data.

The `users` table must have at least the following fields:
- `user_id`: Unique identifier of the user.
- `country`: The 2 letters country code. ISO-3166
- `first_login_ts`: Timestamp of the first time the user logged in.
- `last_login_ts`: Timestamp of the latest time the user logged in.
- `user_segment`: The user segment value. The segments are:
    - `ACTIVE`: The user has logged in at least one time in the last 3 days.
    - `DORMANT`: The user has logged in at least one time in the last 14 days.
    - `INACTIVE`: The user has logged in at least one time in the last 30 days.
    - `NEW`: The user has logged in for the first time that day.

**NOTE**: For the purpose of this exercise we'll assume that today is January 7th 2022.
