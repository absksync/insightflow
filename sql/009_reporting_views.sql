CREATE OR REPLACE VIEW vw_customer_experience_summary AS
SELECT
    r.review_id,
    r.order_id,
    r.review_score,

    CASE
        WHEN r.review_score >= 4 THEN 'Promoter'
        WHEN r.review_score = 3 THEN 'Passive'
        ELSE 'Detractor'
    END AS customer_segment,

    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN 'Not Delivered'
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status

FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id;


CREATE OR REPLACE VIEW vw_seller_performance AS
SELECT
    oi.seller_id,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    ROUND(SUM(oi.price), 2) AS total_revenue,

    ROUND(AVG(r.review_score), 2) AS avg_review_score,

    ROUND(AVG(oi.freight_value), 2) AS avg_freight_value

FROM order_items oi

LEFT JOIN reviews r
    ON oi.order_id = r.order_id

GROUP BY oi.seller_id;


CREATE OR REPLACE VIEW vw_customer_retention AS
SELECT
    c.customer_unique_id,

    COUNT(o.order_id) AS total_orders,

    CASE
        WHEN COUNT(o.order_id) > 1 THEN 'Repeat'
        ELSE 'One-Time'
    END AS customer_type

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id;


CREATE OR REPLACE VIEW vw_delivery_operations AS
SELECT
    order_id,

    customer_id,

    order_purchase_timestamp,

    order_delivered_customer_date,

    order_estimated_delivery_date,

    ROUND(
        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_purchase_timestamp
            )
        ) / 86400.0,
        2
    ) AS delivery_days,

    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 'Within SLA'
        ELSE 'SLA Breach'
    END AS sla_status

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;


CREATE OR REPLACE VIEW vw_product_category_revenue AS
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    COUNT(*) AS total_items_sold,

    ROUND(SUM(oi.price), 2) AS total_revenue,

    ROUND(AVG(oi.price), 2) AS avg_item_price

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    );


CREATE OR REPLACE VIEW vw_customer_state_summary AS
SELECT
    customer_state,

    COUNT(DISTINCT customer_id) AS total_customers

FROM customers

GROUP BY customer_state;