-- Week 2 - Cross-Validation and Quality Control
-- Role D: Data Quality Analyst

-- 1. Orphan customer references
-- Finding: 0
SELECT COUNT(*) AS orphan_customer
FROM sales
WHERE customer_id IS NOT NULL
  AND customer_id NOT IN (
      SELECT customer_id
      FROM customers
      WHERE customer_id IS NOT NULL
  );

-- 2. Orphan product references
-- Finding: 0
SELECT COUNT(*) AS orphan_product
FROM sales
WHERE product_id IS NOT NULL
  AND product_id NOT IN (
      SELECT product_id
      FROM products
      WHERE product_id IS NOT NULL
  );

-- 3. Dormant customers
-- Finding: 592
SELECT COUNT(*) AS dormant_customers
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales
    WHERE customer_id IS NOT NULL
);

-- 4. Unsold products
-- Finding: 12
SELECT COUNT(*) AS unsold_products
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM sales
    WHERE product_id IS NOT NULL
);

-- 5. Advanced: price-consistency check
-- Finding: 664 sales differ by more than €1
-- This does not automatically mean error:
-- possible causes include returns, discounts, historical prices,
-- or other business rules that need confirmation.
SELECT COUNT(*) AS price_inconsistencies
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE ABS(
    s.total_price - (p.retail_price * s.quantity)
) > 1;