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