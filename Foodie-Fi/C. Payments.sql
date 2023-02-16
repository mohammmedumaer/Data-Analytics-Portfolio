DROP TABLE payments;

CREATE  TABLE payments
SELECT 
  customer_id,
  plan_id,
  plan_name,
  DATE(payment_date) as payment_date,
  amount,
  RANK() OVER(
    PARTITION BY customer_id
    ORDER BY
      payment_date
  ) AS payment_order
FROM
  (
    SELECT
      customer_id,
      s.plan_id,
      plan_name,
      DATE_ADD(start_date, INTERVAL n.n MONTH) as payment_date,
      CAST(price AS decimal(5,2))  AS amount
    FROM
      subscriptions AS s
      JOIN plans AS p ON s.plan_id = p.plan_id
      JOIN (
        SELECT 0 as n UNION ALL
        SELECT 1 as n UNION ALL
        SELECT 2 as n UNION ALL
        SELECT 3 as n UNION ALL
        SELECT 4 as n UNION ALL
        SELECT 5 as n UNION ALL
        SELECT 6 as n UNION ALL
        SELECT 7 as n UNION ALL
        SELECT 8 as n UNION ALL
        SELECT 9 as n UNION ALL
        SELECT 10 as n UNION ALL
        SELECT 11 as n UNION ALL
        SELECT 12 as n
      ) as n
      ON n.n <= 12
    WHERE
      s.plan_id != 0
      AND start_date < '2021-01-01'
      GROUP BY 
      customer_id,
      s.plan_id,
      plan_name,
      start_date,
      price
  ) AS t
ORDER BY
  customer_id;

SELECT * FROM payments;

