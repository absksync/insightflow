-- Orders Missing Customer

SELECT COUNT(*) AS missing_customer_orders
FROM orders
WHERE customer_id IS NULL;


-- Reviews Missing Score

SELECT COUNT(*) AS missing_review_scores
FROM reviews
WHERE review_score IS NULL;


-- Orders Missing Delivery Date

SELECT COUNT(*) AS missing_delivery_date
FROM orders
WHERE order_delivered_customer_date IS NULL;


-- Duplicate Customer Unique IDs

SELECT
    customer_unique_id,
    COUNT(*)
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;


-- Data Completeness

SELECT
ROUND(
(
(
COUNT(order_id)
-
COUNT(
CASE
WHEN order_delivered_customer_date IS NULL
THEN 1
END
)
)::numeric
/
COUNT(order_id)
) * 100,
2
) AS completeness_percent
FROM orders;