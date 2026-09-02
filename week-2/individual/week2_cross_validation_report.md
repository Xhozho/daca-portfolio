# Week 2 — Cross-Validation and Quality Control

## Role
Data Quality Analyst — Role D

## Findings

| Check | Result | Interpretation |
|---|---:|---|
| Orphan customer references | 0 | Every non-NULL customer_id used in sales exists in the customers table. |
| Orphan product references | 0 | Every non-NULL product_id used in sales exists in the products table. |
| Dormant customers | 592 | These customers have no recorded purchase in the sales table. |
| Unsold products | 12 | These products have no recorded sale in the sales table. |
| Price inconsistencies | 664 | These sales differ by more than €1 from retail_price × quantity. |

## Business interpretation

The cross-table reference checks found no orphan customer or product references, so the main links between sales, customers and products are structurally consistent.

However, 592 customers have no recorded purchases and 12 products have no recorded sales. These are not automatically data errors and may reflect inactive customers or products that have not yet sold.

The advanced price-consistency check found 664 sales where the recorded total differs by more than €1 from the current product retail price multiplied by quantity. These differences may be caused by returns, discounts, historical prices or other business rules, so they should be investigated before being treated as errors.

## Recommendation

No corrective action is needed for orphan customer or product references because none were found.

The 592 dormant customers and 12 unsold products should be reviewed as business-activity questions rather than automatically cleaned.

The 664 price differences should be investigated with the business team to determine whether they are legitimate transactions or true data-quality issues.