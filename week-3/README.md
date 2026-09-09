# Week 3 — SQL JOINs

## Overview

This week focused on combining related data from different tables using SQL JOINs. My role was Role A: Sales + Customers, where I used INNER JOIN to connect the `sales` and `customers` tables and analyse customer spending, city performance, and loyalty-tier performance.

## My contribution — Role A: Sales + Customers

I used INNER JOIN to combine the `sales` and `customers` tables and analyse customer purchasing behaviour.

My main findings were:

- Tiina Pärn from Tartu was the highest-spending customer, with 73 purchases and €27,668.02 in total spend.
- Tallinn generated the highest total spend: €1,006,252.88 from 3,601 purchases across 1,007 customers.
- Among recorded loyalty tiers, Silver generated the highest total spend at €593,470.07.
- 1,024 purchasing customers had no loyalty tier recorded (`NULL`), which is an important data-quality issue.

## Business conclusion

The results suggest that Tallinn is UrbanStyle's most important market by overall customer spend, while high-value customers are distributed across several cities. UrbanStyle could prioritise Tallinn in broad sales and marketing activities while also giving high-spending individual customers targeted retention offers. Before using loyalty tiers for customer segmentation, the missing loyalty-tier values should be investigated because they represent a large group of purchasing customers.


## Files

- [Role A SQL queries](individual/week3_role_a_sales_customers.sql)
- [Top 10 customers result](screenshots/week3_role_a_top_customers.png)
- [Sales by city result](screenshots/week3_role_a_sales_by_city.png)