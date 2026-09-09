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
- [Above-average customers analysis](screenshots/week3_role_a_above_average_customers.png)
- [Top customers time-range analysis](screenshots/week3_role_a_top_customers_time_analysis.png)

## Advanced analysis

I also used a subquery to identify customers whose total spend was above the average customer spend.

- 762 active customers were above the average spend level.
- This represents about 29.9% of the 2,551 active customers.
- This suggests that a relatively small group of customers contributes a disproportionately large share of revenue.

UrbanStyle could consider targeted retention or VIP-style offers for this higher-value customer segment.

### Customer spending over time

To give the Top 10 customer totals more context, I also analysed the period between each customer's first and last purchase.

Tiina Pärn spent €27,668.02 across 73 purchases over approximately 23.9 months, averaging €379.01 per purchase and €1,156.89 per month across that period. This confirms that she is a high-value UrbanStyle customer, but the sales data does not provide enough information to conclude anything about her personal wealth.

Ago Kull had a lower total spend than Tiina but the highest average monthly spend among the Top 10, at approximately €1,194.14 per month. This shows why the time period matters when comparing customer value.