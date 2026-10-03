/* =========================================================
   EXECUTIVE DASHBOARD
   ========================================================= */

/* Total Revenue */

SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;


/* Total Orders */

SELECT
    COUNT(*) AS total_orders
FROM orders;


/* Total Customers */

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;


/* Average Customer Satisfaction */

SELECT
    ROUND(AVG(review_score), 2) AS avg_csat_score
FROM reviews;


/* Repeat Customer Rate */

SELECT
    ROUND(
        (
            COUNT(
                DISTINCT CASE
                    WHEN order_count > 1
                    THEN customer_unique_id
                END
            )::NUMERIC
            /
            COUNT(DISTINCT customer_unique_id)
        ) * 100,
        2
    ) AS repeat_customer_rate
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t;


/* Revenue Trend */

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;


/* =========================================================
   CUSTOMER EXPERIENCE DASHBOARD
   ========================================================= */


/* CSAT Distribution */

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;


/* Promoters vs Passives vs Detractors */

SELECT
    CASE
        WHEN review_score >= 4 THEN 'Promoter'
        WHEN review_score = 3 THEN 'Passive'
        ELSE 'Detractor'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM reviews
GROUP BY customer_segment;


/* Complaint Rate */

SELECT
    ROUND(
        (
            COUNT(
                CASE
                    WHEN review_score <= 2
                    THEN 1
                END
            )::NUMERIC
            /
            COUNT(*)
        ) * 100,
        2
    ) AS complaint_rate_percent
FROM reviews;


/* Delivery Delay Analysis */

SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;


/* Review Score vs Delivery Time */

SELECT
    r.review_score,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date
                    -
                    o.order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days

FROM reviews r

JOIN orders o
    ON r.order_id = o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY r.review_score

ORDER BY r.review_score;


/* =========================================================
   OPERATIONS DASHBOARD
   ========================================================= */


/* Average Delivery Time */

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    -
                    order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


/* SLA Compliance */

SELECT
    ROUND(
        (
            COUNT(
                CASE
                    WHEN order_delivered_customer_date <= order_estimated_delivery_date
                    THEN 1
                END
            )::NUMERIC
            /
            COUNT(*)
        ) * 100,
        2
    ) AS sla_compliance_percent
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


/* Top Sellers */

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 20;


/* Orders by Status */

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


/* Top Categories */

SELECT
    category,
    total_revenue
FROM vw_product_category_revenue
ORDER BY total_revenue DESC
LIMIT 20;


/* =========================================================
   DATA QUALITY DASHBOARD
   ========================================================= */


/* Missing Delivery Dates */

SELECT
    COUNT(*) AS missing_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NULL;


/* Missing Review Scores */

SELECT
    COUNT(*) AS missing_review_scores
FROM reviews
WHERE review_score IS NULL;


/* Duplicate Customer Unique IDs */

SELECT
    customer_unique_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;


/* Data Completeness */

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
            )::NUMERIC
            /
            COUNT(order_id)
        ) * 100,
        2
    ) AS completeness_percent
FROM orders;