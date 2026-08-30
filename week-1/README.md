
# Week 1 — SQL Fundamentals

## Overview

This week I used read-only SQL queries to investigate the UrbanStyle.ltd sales data. The aim was to identify useful patterns and possible data-quality issues without changing or deleting any data.

## My contribution

I investigated the sales table using SELECT, WHERE, ORDER BY, LIMIT, DISTINCT and COUNT. I focused on large sales, missing customer IDs, location-based sales, sales channels and repeated sale IDs.

## Key findings

- The largest recorded sale was €2170.40, with sale_id 2407 and product_id 1031.
- Some sales have a NULL customer_id. These cannot be linked to a registered customer from this field, although some may be legitimate guest purchases.
- The data contains Tallinn sales above €100.
- Two sales channel values were found: online and pood.
- The sales table contains 15,234 rows and 10,118 unique sale_id values. This shows that some sale_id values repeat, but the cause still needs investigation.

## SQL file

The five exploration queries are saved in:

`week1_sales_exploration.sql`

## Evidence

Screenshots of the query results are stored in the `screenshots` folder.

## Team shared work

[UrbanStyle Week 1 Team Report](https://github.com/reiolootsmann/urbanstyle-g2.git)