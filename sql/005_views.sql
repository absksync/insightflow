CREATE VIEW vw_revenue_by_category AS
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    ROUND(SUM(oi.price), 2) AS revenue,

    COUNT(*) AS total_items_sold

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY category;

CREATE VIEW vw_customer_satisfaction AS
SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_reviews

FROM reviews

GROUP BY review_score;

CREATE VIEW vw_payment_analysis AS
SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS avg_payment_value

FROM payments

GROUP BY payment_type;

CREATE VIEW vw_delivery_performance AS
SELECT
    order_id,

    order_status,

    ROUND(
        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_purchase_timestamp
            )
        ) / 86400,
        2
    ) AS delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;

CREATE VIEW vw_revenue_by_state AS
SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_state;

CREATE VIEW vw_monthly_revenue AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

CREATE VIEW vw_review_delivery_correlation AS
SELECT
    r.review_score,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date
                    - o.order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days,

    COUNT(*) AS total_reviews

FROM reviews r

JOIN orders o
    ON r.order_id = o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY r.review_score

ORDER BY r.review_score;

CREATE VIEW vw_seller_performance AS
SELECT
    seller_id,

    ROUND(SUM(price), 2) AS revenue,

    COUNT(*) AS items_sold,

    ROUND(AVG(price), 2) AS avg_item_price

FROM order_items

GROUP BY seller_id;

