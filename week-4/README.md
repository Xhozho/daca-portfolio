# Week 4 — SQL Aggregation

## My contribution

My role was Customer Segmentation.

I analysed UrbanStyle customer spending using GROUP BY, HAVING, CTEs, CASE WHEN and window functions. I created spend-based customer segments, identified the highest-value repeat customers, compared VIP value across cities, and ranked the top customers within each local market.

For this analysis, I used the following spend-based segmentation:

- VIP: total revenue above €2,000
- Regular: total revenue above €500
- New: total revenue of €500 or less

## Key findings

Regular customers are the largest segment with 1,516 customers and generate 60.60% of customer revenue.

VIP customers are a much smaller group — 206 customers, about 8% of the customer base — but they generate 31.25% of revenue and have an average revenue of €3,978.87.

The New spend segment contains 829 customers but contributes only 8.15% of revenue.

Tallinn has the largest VIP customer base with 71 VIP customers and €281,649.94 in VIP revenue. Pärnu has fewer VIP customers but a substantially higher average VIP spend.

The customer ranking also showed that the highest-value customer differs by local market. For example, Tiina Pärn leads Tartu, Priit Rand leads Pärnu, and Kevin Org leads Tallinn.

## Business interpretation

The analysis shows that UrbanStyle's VIP customers are a small but disproportionately valuable part of the customer base. Retaining these customers is therefore important, while the larger New spend segment may provide an opportunity to develop more customers into higher-value segments.

City-level analysis also suggests that customer strategy should not rely only on national rankings. Some locally important high-value customers can be identified more clearly when customers are ranked within their own cities.

## SQL techniques used

- GROUP BY
- HAVING
- SUM, COUNT and AVG
- CTEs
- CASE WHEN
- RANK()
- PARTITION BY
- Window functions

## AI use

I used ChatGPT as a support tool to clarify SQL aggregation concepts, troubleshoot queries, and refine the interpretation of results. I independently checked and validated the final queries in Supabase.

## Team work

The team's shared Week 4 analysis combined customer segmentation with the sales, inventory and marketing domains.

PDF Attached