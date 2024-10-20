select
student_id,
date_engaged,
MAX(paid) as paid
FROM
(select
e.student_id,
e.date_engaged,
p.date_start,
p.date_end,
CASE
WHEN date_start is NULL AND date_end is NUll THEN 0
WHEN date_engaged BETWEEN date_start AND date_end THEN 1
WHEN date_engaged NOT BETWEEN date_start AND date_end THEN 0
end as paid
FROM student_engagement e    -- it keeps all rows in student_engagement
LEFT JOIN
purchase_info p 
USING (student_id) ) a_tbl
-- WHERE student_id = 262643 AND date_engaged = '2022-03-31'
GROUP BY student_id, date_engaged