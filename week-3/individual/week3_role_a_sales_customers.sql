
-- 1. Customers with sales
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
LIMIT 20;



-- 2. Top 10 customers by total spend
SELECT
    c.first_name || ' ' || c.last_name AS customer,
    c.city,
    COUNT(DISTINCT s.sale_id) AS purchase_count,
    SUM(s.total_price) AS total_spend
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
ORDER BY total_spend DESC
LIMIT 10;

--3. Sales by city
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_spend
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_spend DESC;

--4. Sales by loyalty tier
SELECT
    c.loyalty_tier,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(s.total_price) AS total_spend
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY total_spend DESC;

-- 5. Advanced: Customers whose total spend is above average

SELECT
    c.first_name || ' ' || c.last_name AS customer,
    SUM(s.total_price) AS total_spend
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING SUM(s.total_price) > (
    SELECT AVG(customer_spend)
    FROM (
        SELECT
            SUM(total_price) AS customer_spend
        FROM sales
        GROUP BY customer_id
    ) AS averages
)
ORDER BY total_spend DESC;


-- 6. Advanced: Count customers whose total spend is above average

SELECT COUNT(*) AS above_average_customers
FROM (
    SELECT
        c.customer_id,
        SUM(s.total_price) AS total_spend
    FROM sales s
    INNER JOIN customers c
        ON s.customer_id = c.customer_id
    GROUP BY c.customer_id
    HAVING SUM(s.total_price) > (
        SELECT AVG(customer_spend)
        FROM (
            SELECT
                SUM(total_price) AS customer_spend
            FROM sales
            GROUP BY customer_id
        ) AS averages
    )
) AS above_average;



-- 7. Advanced: Top 10 customer spending over time
-- Adds first/last purchase dates, average spend per purchase,
-- active time range, and average monthly spend.
SELECT
    c.first_name || ' ' || c.last_name AS customer,
    c.city,
    COUNT(DISTINCT s.sale_id) AS purchase_count,
    MIN(s.sale_date) AS first_purchase,
    MAX(s.sale_date) AS last_purchase,
    SUM(s.total_price) AS total_spend,
    ROUND(AVG(s.total_price), 2) AS avg_spend_per_purchase,
    ROUND(
        GREATEST(
            (MAX(s.sale_date)::date - MIN(s.sale_date)::date)::numeric / 30.44,
            1
        ),
        1
    ) AS active_months,
    ROUND(
        SUM(s.total_price) /
        GREATEST(
            (MAX(s.sale_date)::date - MIN(s.sale_date)::date)::numeric / 30.44,
            1
        ),
        2
    ) AS avg_spend_per_month
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
ORDER BY total_spend DESC
LIMIT 10;