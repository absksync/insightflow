SELECT
ROUND(AVG(review_score),2) AS csat_score
FROM reviews;

SELECT
CASE
WHEN review_score >= 4 THEN 'Promoter'
WHEN review_score = 3 THEN 'Passive'
ELSE 'Detractor'
END AS customer_segment,
COUNT(*) AS total
FROM reviews
GROUP BY customer_segment;
SELECT
COUNT(*) AS delayed_orders
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;

SELECT
COUNT(*) AS delayed_orders
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;

SELECT
ROUND(
(
COUNT(
CASE
WHEN order_delivered_customer_date <= order_estimated_delivery_date
THEN 1
END
)::numeric
/
COUNT(*)
)*100,
2
) AS sla_compliance_percent
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

SELECT
ROUND(
(
COUNT(
CASE
WHEN review_score <= 2
THEN 1
END
)::numeric
/
COUNT(*)
)*100,
2
) AS complaint_rate_percent
FROM reviews;

SELECT
ROUND(
(
COUNT(
DISTINCT CASE
WHEN order_count > 1
THEN customer_unique_id
END
)::numeric
/
COUNT(DISTINCT customer_unique_id)
)*100,
2
) AS repeat_customer_rate
FROM
(
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
) t;
