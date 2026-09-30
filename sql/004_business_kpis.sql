-- Total Revenue

SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;