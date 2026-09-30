-- Total Revenue

SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;

-- Orders by Status

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    payment_type,
    COUNT(*) AS total_payments,
    ROUND(SUM(payment_value),2) AS revenue
FROM payments
GROUP BY payment_type
ORDER BY revenue DESC;

SELECT
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM reviews;

SELECT
    customer_state,
    COUNT(*) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC
LIMIT 10;

SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;

SELECT
    review_score,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY review_score
ORDER BY review_score;

