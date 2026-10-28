# Week 8 — Python APIs & Data Automation

**Programme:** Data Analyst Career Accelerator (DACA)  
**Case Study:** UrbanStyle.ltd  
**My Role:** Role B — Data Processing  
**Tools:** Python, pandas, Supabase API, VS Code

## Overview

In Week 8, our focus shifted from running individual Python analyses to building an automated data pipeline.

The challenge was to make UrbanStyle's data analysis more efficient by connecting data fetching, cleaning, transformation, visualisation and exporting into one workflow.

Our team divided the work into four modules. I was responsible for **Role B — Data Processing**, which meant preparing the raw data for analysis and turning it into useful business metrics.

I worked on `transform.py`, using pandas to clean and merge datasets, calculate weekly sales summaries and generate KPIs for the next stage of the pipeline.

## My Contribution — Data Processing

I developed and tested four Python functions:

| Function | Purpose |
|---|---|
| `clean_data()` | Removes duplicates, checks missing values and converts data types |
| `merge_datasets()` | Combines sales and customer information using `customer_id` |
| `calculate_weekly_aggregates()` | Calculates weekly revenue, order counts and average order values |
| `calculate_kpis()` | Calculates total revenue, unique customers and overall average order value |

### Data Cleaning and Validation

I used pandas to check the quality of the sales data before processing it.

The cleaning function removes duplicate rows, converts dates and prices into the correct data types, and checks for missing values. Records with invalid dates or prices are excluded from the calculations.

I also added error handling for empty datasets and missing required columns, along with logging messages to help identify potential problems.

### Weekly Sales Aggregation

Using `groupby()` and `agg()`, I grouped transactions into weekly periods and calculated revenue, order counts and average order values.

This created a structured DataFrame that could be passed to Role C for visualisation.

### KPI Calculations

I created a function that returns three key business metrics: total revenue, unique customers and average order value.

The results are returned as a dictionary so they can be reused by other parts of the pipeline.

### Merging Datasets

I used `pd.merge()` to combine sales and customer records through `customer_id`.

I chose a left join to preserve sales records even when matching customer information was unavailable.

I also validated the merge by checking that it did not increase or decrease the number of sales rows.

## Results and Data Quality Findings

My processing module successfully handled the UrbanStyle sales dataset.

| Metric | Result |
|---|---:|
| Sales records loaded | 10,118 |
| Sales records after cleaning | 10,118 |
| Sales records after merging | 10,118 |
| Unique invoices | 10,118 |
| Weekly periods | 132 |
| Calculated revenue | €2,909,177.98 |
| Unique customers with IDs | 2,551 |
| Average order value | €287.53 |

The row counts remained consistent throughout cleaning and merging, providing an important check that records had not been unintentionally lost or duplicated.

The data-quality checks also identified **988 missing customer IDs, 3,462 missing store locations and 195 negative-price records**.

I did not automatically replace these missing values with zero or remove the negative transactions. Instead, I retained the records where appropriate and flagged potential issues for further investigation.

The reported revenue and average order value include the negative-price records. Their business meaning, such as whether they represent returns or other adjustments, still needs verification.

## Challenges and Problem-Solving

### Supabase Access

One challenge occurred when the API returned a successful HTTP response but no sales data.

After investigating, we identified Row Level Security (RLS) as the cause. Once the data-access issue was resolved, the functions could retrieve and process the expected records.

This taught me that an API request can succeed technically without returning the data I expected.

### Importing Python Modules

I also encountered a `NameError` when testing whether `transform.py` could be imported independently.

The problem came from test statements being placed outside the `if __name__ == "__main__":` block.

After correcting the indentation, the module could be imported without automatically running the test code.

This helped me understand the difference between running a Python file directly and importing its functions into another script.

## Testing

I tested my processing functions using the data fetched through Role A's Supabase module.

To run the individual processing module:

```bash
python transform.py
```

The script successfully completed cleaning, merging, weekly aggregation and KPI calculations.

I also checked whether the module could be imported independently:

```bash
python -c "import transform; print('IMPORT SUCCESS')"
```

**Result:** `IMPORT SUCCESS`

This confirmed that my functions could be imported for use in the team's main pipeline.

## Team Integration

Our team combined the individual modules into an automated ETL pipeline.

| Role | Contribution |
|---|---|
| A — API Query | Fetch data from Supabase |
| B — Data Processing (My Role) | Clean, merge and transform data; calculate KPIs |
| C — Visualisation + Saving | Generate Plotly charts and export CSV/HTML files |
| D — Automation | Connect the modules, run the pipeline and log execution |

The team's demo reported successful end-to-end execution, including data retrieval, transformation, validation, visualisation and exporting.

In Daria's reported test, the pipeline completed in approximately **0.70 seconds**.

The main benefit of this approach is repeatability. The team can run the same workflow again without manually repeating each processing step.

For more details, see the [Week 8 Team Pipeline Demo](week8_pipeline_demo.md).

## What I Learned

Week 8 helped me connect the Python skills from the previous week to a larger automated workflow.

I became more comfortable working with reusable functions, handling missing values, calculating aggregations and making separate Python files work together.

The most useful lesson was understanding why validation matters. A script running without an error does not automatically mean its results are correct.

I also learned how important it is for different team members to agree on the structure of their inputs and outputs so that their modules can work together.

## AI Use

I used ChatGPT to help draft and explain Python functions, add code comments and troubleshoot errors. I ran the code myself in VS Code, inspected the outputs and checked that the processing and import tests worked as expected.

## Project Files

| File | Description |
|---|---|
| `transform.py` | My individual Role B processing module |
| `data_fetcher.py` | Role A's module, used during integration testing |
| `week8_pipeline_demo.md` | Team pipeline overview and demonstration results |
| `README.md` | Documentation of my contribution and learning |

---

*DACA — UrbanStyle.ltd Case Study | Week 8 — Python APIs & Data Automation*