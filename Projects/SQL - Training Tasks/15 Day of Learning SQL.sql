--	'15 Days of Learning SQL'

/*
Julia conducted a 15 days of learning SQL contest.
The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least 1 submission
each day (starting on the first day of the contest), and find the hacker_id and name
of the hacker who made maximum number of submissions each day.
If more than one such hacker has a maximum number of submissions,
print the lowest hacker_id. The query should print this information for each day of the contest,
sorted by the date.
*/

WITH MaxSubEachDay AS (
  SELECT
    submission_date,
    hacker_id,
    RANK() OVER(
      PARTITION by submission_date
      ORDER BY
        SubCount DESC,
        hacker_id
    ) AS Rn
  FROM
    (
      SELECT
        submission_date,
        hacker_id,
        count(1) AS SubCount
      FROM
        submissions
      GROUP BY
        submission_date,
        hacker_id
    ) subQuery
),
DayWiseRank AS (
  SELECT
    submission_date,
    hacker_id,
    DENSE_RANK() OVER(
      ORDER BY
        submission_date
    ) AS dayRn
  FROM
    submissions
),
HackerCntTillDate AS (
  SELECT
    outtr.submission_date,
    outtr.hacker_id,
    CASE
      WHEN outtr.submission_date = '2016-03-01' THEN 1
      ELSE 1 +(
        SELECT
          count(DISTINCT a.submission_date)
        FROM
          submissions a
        WHERE
          a.hacker_id = outtr.hacker_id
          AND a.submission_date < outtr.submission_date
      )
    END AS PrevCnt,
    outtr.dayRn
  FROM
    DayWiseRank outtr
),
HackerSubEachDay AS (
  SELECT
    submission_date,
    count(DISTINCT hacker_id) HackerCnt
  FROM
    HackerCntTillDate
  WHERE
    PrevCnt = dayRn
  GROUP BY
    submission_date
)
SELECT
  HackerSubEachDay.submission_date,
  HackerSubEachDay.HackerCnt,
  MaxSubEachDay.hacker_id,
  Hackers.name
FROM
  HackerSubEachDay
  INNER JOIN MaxSubEachDay ON HackerSubEachDay.submission_date = MaxSubEachDay.submission_date
  INNER JOIN Hackers ON Hackers.hacker_id = MaxSubEachDay.hacker_id
WHERE
  MaxSubEachDay.Rn = 1