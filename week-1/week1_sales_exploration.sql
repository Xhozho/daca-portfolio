-- Query 1: Find the largest sale.
-- This checks which recorded sale has the highest total price.
-- Finding: The largest recorded sale is €2170.40, with sale_id 2407 and product_id 1031.
-- Business relevance: unusually large transactions may be worth reviewing.

SELECT sale_id, product_id, total_price
FROM sales
ORDER BY total_price DESC
LIMIT 1;


-- Query 2: Find sales with missing customer IDs.
-- This checks for sales where customer_id is missing.
-- Finding: The query returned 10 example sales with a NULL customer_id.
-- These sales cannot be linked to a registered customer from this field.
-- Business relevance: missing customer links can make customer-level analysis incomplete,
-- although some may be legitimate guest purchases and should be investigated before being treated as errors.

SELECT sale_id, customer_id, total_price
FROM sales
WHERE customer_id IS NULL
LIMIT 10;

-- Query 3: Find high-value sales in Tallinn.
-- This checks for sales made in Tallinn with a total price above €100.
-- Finding: The query returned 10 example Tallinn sales above €100.
-- Business relevance: this filter helps isolate higher-value sales in a specific
-- location for closer analysis, but it does not show how many such sales exist in total.

SELECT sale_id, store_location, total_price
FROM sales
WHERE store_location = 'Tallinn'
  AND total_price > 100
LIMIT 10;


-- Query 4: Find the different sales channels.
-- This checks which unique channel values exist in the sales table.
-- Finding: The dataset contains two distinct channel values: online and pood.
-- Business relevance: knowing the available sales channels helps separate and compare
-- sales activity by channel in later analysis.

SELECT DISTINCT channel
FROM sales
ORDER BY channel;


-- Query 5: Compare all sales rows with unique sale IDs.
-- This checks whether sale_id values repeat in the sales table.
-- Finding: The table contains 15,234 rows but only 10,118 unique sale_id values,
--  a difference of 5,116 between the two counts.
-- Business relevance: this shows that some sale_id values repeat and should be
-- investigated before any cleaning or deletion is attempted.

SELECT
  COUNT(*) AS all_rows,
  COUNT(DISTINCT sale_id) AS unique_sale_ids
FROM sales;