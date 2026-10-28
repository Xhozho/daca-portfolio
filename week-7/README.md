# Week 7: Python and pandas — RFM Customer Segmentation

## Overview

Week 7 introduced Python and pandas for customer-level analysis using UrbanStyle.ltd's sales data.

The team worked on an RFM analysis to help answer three business questions:

- Who are UrbanStyle's most valuable customers?
- Which customers may be at risk of leaving?
- Where should the business focus first?

RFM uses **Recency**, **Frequency**, and **Monetary value** to group customers based on their purchasing behaviour.

## My Role

**Role A — Data Loading**

My responsibility was to prepare the data for the rest of the RFM pipeline.

I:

- connected Python to the UrbanStyle Supabase database
- loaded the full `sales` and `customers` tables into pandas
- used pagination to make sure all rows were retrieved
- inspected the DataFrames and their columns
- merged the two tables using `customer_id`
- checked that the merged result had a sensible row count
- confirmed that the fields required by the next stages were present

## Data

The datasets loaded were:

- **Sales:** 10,118 rows × 12 columns
- **Customers:** 3,150 rows × 9 columns

I merged them using a pandas left join:

```python
df = pd.merge(
    sales_df,
    customers_df,
    on="customer_id",
    how="left"
)
```

The resulting DataFrame contained:

**10,118 rows × 20 columns**

The row count staying at 10,118 after the merge was an important validation check. It showed that the sales records had been preserved without the merge unexpectedly multiplying or removing rows.

I also confirmed that the merged DataFrame contained the fields needed for later stages:

- `customer_id`
- `sale_date`
- `total_price`
- `email`

At this stage, `sale_date` was still stored as text. Converting dates and handling other data-quality issues belonged to the cleaning stage of the pipeline.

## What I Learned

This week helped me understand that Python and pandas use many of the same data-analysis ideas I already knew from SQL.

For example:

| SQL | pandas |
| --- | --- |
| `JOIN` | `merge()` |
| `GROUP BY` | `groupby()` |
| `ORDER BY` | `sort_values()` |
| `SUM()` | `.sum()` |
| `COUNT(DISTINCT)` | `.nunique()` |

I also learned that successfully running code is not enough. The result still needs to be checked.

During the data-loading stage, I used row counts, column names and DataFrame shapes to make sure the data I was working with was complete and sensible.

I also learned how **pagination** works when retrieving larger datasets from an API: instead of assuming one request returns everything, the data can be requested in smaller batches and combined.

## Challenges

One of the main challenges was establishing the correct Supabase connection.

I initially connected to the wrong project, and later found that Row Level Security was preventing the publishable-key connection from returning rows. This helped me understand the difference between a connection succeeding technically and the application actually having permission to access the data.

Another useful lesson came from an attempted CSV export that contained only 100 rows even though the real sales table contained 10,118. Checking the DataFrame shape prevented me from accidentally continuing the analysis with an incomplete dataset.

## AI Use

I used ChatGPT to help explain unfamiliar Python and pandas concepts, interpret error messages, and understand pagination and Supabase connection issues.

I ran the code myself and checked the outputs using DataFrame shapes, column names and sample rows rather than accepting AI-generated suggestions without validation.

## Team Pipeline

My Data Loading stage provided the merged DataFrame used by the rest of the team:

**Data Loading → Data Cleaning → RFM Analysis → Visualisation → Business Recommendation**

The later stages cleaned the data, calculated Recency, Frequency and Monetary values, created customer segments, and translated the results into recommendations for UrbanStyle.

## Files

- [My Role A notebook](individual/week7_rfm_A.ipynb)
- [Team RFM notebook](team/week7_rfm_complete.ipynb)

## Key Takeaway

My main lesson from Week 7 was that **checking the result is just as important as writing the code**.

Before an analysis can produce reliable customer segments or business recommendations, the underlying data needs to be complete, correctly structured and validated.