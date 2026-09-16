
-- Week 4: Customer Segmentation and Revenue Analysis
-- Domain: Customer Segmentation
-- Objective: Analyse customer value using GROUP BY, HAVING, CTEs and window functions.
-- Segmentation used in this analysis: VIP > €2,000; Regular > €500; New <= €500.





-- Query 1: Customer segmentation by total spend.
-- Business question: How can UrbanStyle divide customers into spend-based segments?
-- Segmentation rule: VIP > €2,000; Regular > €500; New <= €500.
-- Finding: Tiina Pärn is the highest-spending customer at €27,668.02 and is classified as VIP.
-- The highest-spending customers come from several cities, including Tartu, Pärnu and Tallinn.
-- Business relevance: The segmentation identifies high-value customers who may benefit from targeted retention and VIP marketing.

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        c.city,
        COUNT(s.sale_id) AS order_count,
        ROUND(SUM(s.total_price), 2) AS total_revenue
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
)

SELECT
    name,
    city,
    order_count,
    total_revenue,
    CASE
        WHEN total_revenue > 2000 THEN 'VIP'
        WHEN total_revenue > 500 THEN 'Regular'
        ELSE 'New'
    END AS segment
FROM customer_summary
ORDER BY total_revenue DESC;



-- Query 2: Top 10 repeat customers by total revenue.
-- Business question: Which repeat customers generate the most revenue?
-- Finding: The top 10 customers generated €228,336.79 in combined revenue.
-- Tiina Pärn ranked first with €27,668.02, while Kevin Org had the most orders among the top 10 with 78.
-- Business relevance: High order frequency does not always mean the highest spend, so both revenue and order count matter when identifying valuable customers.

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS name,
    COUNT(s.sale_id) AS order_count,
    ROUND(SUM(s.total_price), 2) AS total_revenue
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(s.sale_id) >= 2
ORDER BY total_revenue DESC
LIMIT 10;



-- Query 3: Customer segment summary.
-- Business question: How many customers are in each spend-based segment, and what is their average revenue?
-- Segmentation rule: VIP > €2,000; Regular > €500; New <= €500.
-- Method: A CTE calculates each customer's total revenue, then groups customers into VIP, Regular and New segments.
-- Finding: Regular is the largest segment with 1,516 customers and an average revenue of €1,048.34.
-- VIP has only 206 customers, but their average revenue is much higher at €3,978.87.
-- New has 829 customers and the lowest average revenue at €257.90.
-- Business relevance: The results show that VIP customers are few but highly valuable, while the large New spend segment may offer an opportunity for conversion into higher-value customers.

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        c.city,
        COUNT(s.sale_id) AS order_count,
        SUM(s.total_price) AS total_revenue
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

segments AS (
    SELECT
        customer_id,
        name,
        city,
        order_count,
        total_revenue,
        CASE
            WHEN total_revenue > 2000 THEN 'VIP'
            WHEN total_revenue > 500 THEN 'Regular'
            ELSE 'New'
        END AS segment
    FROM customer_summary
)

SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM segments
GROUP BY segment
ORDER BY average_revenue DESC;



-- Query 4: VIP customer value by city.
-- Business question: Which cities have the most valuable VIP customer base?
-- Segmentation rule: VIP customers are those with total revenue above €2,000.
-- Method: A CTE calculates each customer's total revenue, then VIP customers are grouped by city.
-- Finding: Tallinn has the largest VIP base with 71 customers and the highest VIP revenue at €281,649.94.
-- Pärnu has fewer VIP customers, 31, but a much higher average VIP spend of €5,814.91.
-- Jõhvi has the highest average VIP spend at €5,964.49, although it has only 5 VIP customers.
-- Business relevance: Tallinn is strongest for broad VIP retention, while cities such as Pärnu and Jõhvi may be valuable for more targeted high-spend customer campaigns.

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.city,
        SUM(s.total_price) AS total_revenue
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.city
)

SELECT
    city,
    COUNT(*) AS vip_customers,
    ROUND(SUM(total_revenue), 2) AS vip_revenue,
    ROUND(AVG(total_revenue), 2) AS average_vip_spend
FROM customer_summary
WHERE total_revenue > 2000
GROUP BY city
ORDER BY vip_revenue DESC;


-- Query 5: Top 3 customers within each city.
-- Business question: Who are the highest-value customers in each local market?
-- Method: RANK() with PARTITION BY city ranks customers by total revenue within each city.
-- Finding: Tiina Pärn leads Tartu (€27,668.02), Priit Rand leads Pärnu (€26,286.10), and Kevin Org leads Tallinn (€23,467.13).
-- Business relevance: Local rankings reveal valuable customers who may not appear in the overall national Top 10.

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        c.city,
        COUNT(s.sale_id) AS order_count,
        ROUND(SUM(s.total_price), 2) AS total_revenue
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

ranked_customers AS (
    SELECT
        name,
        city,
        order_count,
        total_revenue,
        RANK() OVER (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS rank_in_city
    FROM customer_summary
)

SELECT
    name,
    city,
    order_count,
    total_revenue,
    rank_in_city
FROM ranked_customers
WHERE rank_in_city <= 3
ORDER BY city, rank_in_city;



-- Query 6: Revenue contribution by customer segment.
-- Business question: Which customer segment contributes the largest share of total customer revenue?
-- Method: Segment revenue is aggregated and a window function calculates each segment's share of total revenue.
-- Finding: Regular customers generate 60.60% of revenue; VIP customers generate 31.25% despite representing only about 8% of customers.
-- Business relevance: VIP customers form a small but disproportionately valuable segment,
-- while the large New spend segment presents an opportunity to develop more customers into higher-value tiers.
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        c.city,
        COUNT(s.sale_id) AS order_count,
        SUM(s.total_price) AS total_revenue
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
),

segments AS (
    SELECT
        customer_id,
        name,
        city,
        order_count,
        total_revenue,
        CASE
            WHEN total_revenue > 2000 THEN 'VIP'
            WHEN total_revenue > 500 THEN 'Regular'
            ELSE 'New'
        END AS segment
    FROM customer_summary
),

segment_summary AS (
    SELECT
        segment,
        COUNT(*) AS customers,
        SUM(total_revenue) AS segment_revenue,
        AVG(total_revenue) AS average_revenue
    FROM segments
    GROUP BY segment
)

SELECT
    segment,
    customers,
    ROUND(segment_revenue, 2) AS segment_revenue,
    ROUND(average_revenue, 2) AS average_revenue,
    ROUND(
        100.0 * segment_revenue
        / SUM(segment_revenue) OVER (),
        2
    ) AS revenue_share_percent
FROM segment_summary
ORDER BY segment_revenue DESC;

