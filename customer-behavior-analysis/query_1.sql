CREATE VIEW purchase_info AS -- store the start and ending of subscriptions
SELECT  -- student who cancel the subscription will pay in the next sub period
purchase_id,
student_id,
purchase_type,
date_start,
date_refunded,
IF (date_refunded is NULL, date_end, date_refunded) AS date_end
FROM

(Select 
purchase_id,
student_id,
purchase_type,
date_purchased as date_start,
CASE
WHEN purchase_type =  0 THEN    -- monthly
DATE_ADD(MAKEDATE(year(date_purchased),DAY(date_purchased)),
interval MONTH (date_purchased) MONTH)
WHEN purchase_type =  1  THEN  -- quaterly
DATE_ADD(MAKEDATE(year(date_purchased),DAY(date_purchased)),
interval MONTH (date_purchased) +2 MONTH)
WHEN purchase_type = 2 THEN   -- annuly
DATE_ADD(MAKEDATE(year(date_purchased),DAY(date_purchased)),
interval MONTH (date_purchased) +11 MONTH)
END   AS date_end,
date_refunded
FROM 
student_purchases
 ) derived_table


