# Week 2 — SQL Data Cleaning

## Overview

This week focused on data cleaning and data-quality checks using SQL. The work included identifying duplicates, NULL values, inconsistent formats and checking relationships between tables.

## My contribution — Role D: Cross-Validation and Quality Control

I checked whether the `sales` table referenced valid customers and products.

My findings were:

- 0 orphan customer references
- 0 orphan product references
- 592 customers with no recorded purchase
- 12 products with no recorded sale
- 664 sales where `total_price` differed by more than €1 from `retail_price × quantity` in the optional price-consistency check

The orphan checks suggest that the customer and product references in the sales data are structurally consistent. The dormant customers, unsold products and price differences require business interpretation before they should be treated as data-quality errors.

## Individual files

- `individual/week2_cross_validation.sql`
- `individual/week2_cross_validation_report.md`

## Team shared work

Team Week 2 report link: **ADD LINK HERE**