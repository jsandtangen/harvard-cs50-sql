-- In 8.sql, write a query that counts the number of episodes released in the last 6 years, from 2018 to 2023, inclusive.

SELECT COUNT(*) AS episode_count FROM episodes WHERE air_date >= '2018-01-01' AND air_date <= '2023-12-31';