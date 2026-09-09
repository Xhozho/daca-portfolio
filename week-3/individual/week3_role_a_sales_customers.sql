
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