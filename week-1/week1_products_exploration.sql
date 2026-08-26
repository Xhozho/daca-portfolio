-- Query 1: Count total products.
-- This checks how many rows are in the products table.
-- Finding: The products table contains 362 products.

SELECT COUNT(*) AS product_count
FROM products;




-- Query 2: Find all product categories.
-- This checks which unique categories exist in the products table.
-- Finding: The products table contains 5 distinct categories:
-- aksessuaarid, jalanõusid, laste_riided, meeste_riided and naiste_riided.
-- Business relevance: identifying the available categories helps UrbanStyle
-- understand how its product range is organised.

SELECT DISTINCT category
FROM products
ORDER BY category;

--Expensive-product query
-- Finding: The 10 highest-priced products range from €368.67 to €434.08.
-- The highest-priced product shown is Õhuline sünteetiline sporditossud at €434.08.
-- Business relevance: identifying the highest-priced products helps show the upper
-- end of UrbanStyle's product price range.



-- Query 3: Find the 10 most expensive products.
-- This checks which products have the highest retail prices.
-- Finding: The 10 highest-priced products range from €368.67 to €434.08.
-- The highest-priced product shown is Õhuline sünteetiline sporditossud at €434.08.
-- Business relevance: this shows the upper end of UrbanStyle's product price range
-- and helps identify the products with the highest selling prices.

SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price DESC
LIMIT 10;




-- Query 4: Find the 10 cheapest products.
-- This checks which products have the lowest retail prices.
-- Finding: The 10 lowest-priced products range from €13.53 to €24.54.
-- The cheapest product shown is Vintage villane kangasvöö at €13.53.
-- Business relevance: this shows the lower end of UrbanStyle's product price range
-- and helps compare low-priced products with the most expensive products.

SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price ASC
LIMIT 10;



-- Query 5: Check for missing prices and categories.
-- This checks whether any products are missing a retail price or category.
-- Finding: No products are missing a retail price or category.
-- Business relevance: these two fields appear complete, which makes price and
-- category-based analysis more reliable.

SELECT
  COUNT(*) - COUNT(retail_price) AS missing_prices,
  COUNT(*) - COUNT(category) AS missing_categories
FROM products;