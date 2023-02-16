# 1) How many customers has Foodie-Fi ever had?

SELECT 
    COUNT(DISTINCT (customer_id)) AS 'distinct customers'
FROM
    subscriptions;

# 2) What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT 
    MONTH(start_date),
    COUNT(DISTINCT customer_id) AS 'Monthly Distribution'
FROM
    subscriptions
        JOIN
    plans USING (plan_id)
WHERE
    plan_id = 0
GROUP BY MONTH(start_date);

# 3) What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT 
    plan_id, plan_name, COUNT(*) AS 'Count Of Events'
FROM
    subscriptions
        JOIN
    plans USING (plan_id)
WHERE
    YEAR(start_date) > 2020
GROUP BY plan_id;

# 4) What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT 
    plan_name,
    COUNT(DISTINCT customer_id) AS 'Churned Customers',
    ROUND(100 * COUNT(DISTINCT customer_id) / 
    (SELECT COUNT(DISTINCT customer_id) AS 'Distinct Customers'
FROM subscriptions),1) AS 'Churn Percentage'
FROM subscriptions
JOIN plans USING (plan_id)
WHERE plan_id = 4;



# 5) How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH next_plan_cte AS 
	(SELECT *, 
	LEAD(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_plan 
FROM subscriptions), Churners AS
	(SELECT * 
	FROM next_plan_cte 
	WHERE next_plan = 4
    AND plan_id = 0) 
SELECT COUNT(customer_id) AS 'Churn After Trial Count', 
	   ROUND(100 * COUNT(customer_id) / (SELECT COUNT(DISTINCT customer_id) AS 'Distinct Customers' 
       FROM subscriptions),2) AS 'Churn Percentage' 
FROM Churners;

# 6) What is the number and percentage of customer plans after their initial free trial?

WITH previous_plan_cte AS
  (SELECT *,
          lag(plan_id, 1) over(PARTITION BY customer_id
                               ORDER BY start_date) AS previous_plan
   FROM subscriptions
   JOIN plans USING (plan_id))
SELECT plan_name,
       count(customer_id) customer_count,
       round(100 *count(DISTINCT customer_id) /
               (SELECT count(DISTINCT customer_id) AS 'distinct customers'
                FROM subscriptions), 2) AS 'customer percentage'
FROM previous_plan_cte
WHERE previous_plan=0
GROUP BY plan_name ;

# 7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH customer_count AS (
  SELECT plan_id, plan_name, COUNT(DISTINCT customer_id) as count_customers
  FROM subscriptions
  JOIN plans USING (plan_id)
  WHERE start_date <= '2020-12-31'
  GROUP BY plan_name
)
SELECT plan_id, plan_name, count_customers, ROUND(100*(count_customers/(SELECT SUM(count_customers) FROM customer_count)), 2) as percentage
FROM customer_count
ORDER BY plan_id;

# 8.How many customers have upgraded to an annual plan in 2020?
SELECT plan_id, plan_name, 
       COUNT(DISTINCT customer_id) AS annual_plan_customer_count
FROM subscriptions JOIN plans USING(plan_id)
WHERE plan_id = 3
AND start_date <= '2020-12-31';

#9.	How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
WITH trial_plan_customer_cte AS
  (SELECT *
   FROM subscriptions
   JOIN plans USING (plan_id)
   WHERE plan_id=0),
     annual_plan_customer_cte AS
  (SELECT *
   FROM subscriptions
   JOIN plans USING (plan_id)
   WHERE plan_id=3)
SELECT round(avg(datediff(annual_plan_customer_cte.start_date, trial_plan_customer_cte.start_date)))AS avg_conversion_days
FROM trial_plan_customer_cte
INNER JOIN annual_plan_customer_cte USING (customer_id);

# 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
SELECT
  *
FROM
  (
    SELECT
      plan_name,
      CASE
        WHEN s.start_date - t.start_date < 31 THEN '0-30 days'
        WHEN s.start_date - t.start_date BETWEEN 31
        AND 60 THEN '31-60 days'
        WHEN s.start_date - t.start_date BETWEEN 61
        AND 90 THEN '61-90 days'
        WHEN s.start_date - t.start_date BETWEEN 91
        AND 120 THEN '91-120 days'
        WHEN s.start_date - t.start_date BETWEEN 121
        AND 150 THEN '121-150 days'
        WHEN s.start_date - t.start_date BETWEEN 151
        AND 180 THEN '151-180 days'
        WHEN s.start_date - t.start_date BETWEEN 181
        AND 210 THEN '181-210 days'
        WHEN s.start_date - t.start_date BETWEEN 211
        AND 240 THEN '211-240 days'
        WHEN s.start_date - t.start_date BETWEEN 241
        AND 270 THEN '241-270 days'
        WHEN s.start_date - t.start_date BETWEEN 271
        AND 300 THEN '271-300 days'
        WHEN s.start_date - t.start_date BETWEEN 301
        AND 330 THEN '301-330 days'
        WHEN s.start_date - t.start_date BETWEEN 331
        AND 360 THEN '331-360 days'
        WHEN s.start_date - t.start_date > 360 THEN '360+ days' 
      END AS group_by_days_to_upgrade,
      COUNT(s.start_date - t.start_date) AS number_of_customers,
      ROUND(AVG(s.start_date - t.start_date)) AS average_days_to_upgrade
    FROM
      subscriptions AS s
      JOIN plans AS p ON s.plan_id = p.plan_id
      JOIN (
        SELECT
          customer_id,
          start_date
        FROM
          subscriptions
        WHERE
          plan_id = 0
      ) AS t ON s.customer_id = t.customer_id
    WHERE
      plan_name = 'pro annual'
    GROUP BY
      plan_name,
      group_by_days_to_upgrade
  ) AS count_groups
GROUP BY
  plan_name,
  group_by_days_to_upgrade,
  number_of_customers,
  average_days_to_upgrade
ORDER BY
  CASE
    WHEN group_by_days_to_upgrade = '0-30 days' THEN 1
    WHEN group_by_days_to_upgrade = '31-60 days' THEN 2
    WHEN group_by_days_to_upgrade = '61-90 days' THEN 3
    WHEN group_by_days_to_upgrade = '91-120 days' THEN 4
    WHEN group_by_days_to_upgrade = '121-150 days' THEN 5
    WHEN group_by_days_to_upgrade = '151-180 days' THEN 6
    WHEN group_by_days_to_upgrade = '181-210 days' THEN 7
    WHEN group_by_days_to_upgrade = '211-240 days' THEN 8
    WHEN group_by_days_to_upgrade = '241-270 days' THEN 9
    WHEN group_by_days_to_upgrade = '271-300 days' THEN 10
    WHEN group_by_days_to_upgrade = '301-330 days' THEN 11
    WHEN group_by_days_to_upgrade = '331-360 days' THEN 12
    WHEN group_by_days_to_upgrade = '360+ days' THEN 13
  END; 
# 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH next_plan_cte AS
  (SELECT *,
          lead(plan_id, 1) OVER(PARTITION BY customer_id
                                ORDER BY start_date) AS next_plan
   FROM subscriptions)
SELECT count(*) AS downgrade_count
FROM next_plan_cte
WHERE plan_id=2
  AND next_plan=1
  AND year(start_date);
