USE customer_engagement;

WITH table_engagement AS
(
SELECT 
    student_id, date_engaged, MAX(paid) AS paid
FROM
    (SELECT 
        e.student_id,
            e.date_engaged,
            p.date_start,
            p.date_end,
            CASE
                WHEN date_start IS NULL AND date_end IS NULL THEN 0
                WHEN date_engaged BETWEEN date_start AND date_end THEN 1
                WHEN date_engaged NOT BETWEEN date_start AND date_end THEN 0
            END AS paid
    FROM
        student_engagement e
    LEFT JOIN purchases_info p USING (student_id)) a
GROUP BY student_id , date_engaged
ORDER BY student_id , date_engaged),
table_define_the_cohorts AS
(
SELECT 
    *, MIN(date_engaged) as cohort
FROM
    table_engagement
GROUP BY student_id , paid
),
table_engagement_and_cohorts as
(
SELECT 
    e.*,
    c.cohort,
    TIMESTAMPDIFF(MONTH,
        c.cohort,
        e.date_engaged) AS period
FROM
    table_engagement e
        JOIN
    table_define_the_cohorts c ON e.student_id = c.student_id
        AND e.paid = c.paid
)
select * from table_engagement_and_cohorts
;
