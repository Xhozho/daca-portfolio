
import pandas as pd
import logging

# Logging helps us track what happens during each transformation.
logger = logging.getLogger(__name__)


# FUNCTION 1: CLEAN DATA
def clean_data(df):
    """Remove duplicates, handle missing values and convert data types."""

    # An empty DataFrame may mean Role A's API request failed.
    if df.empty:
        raise ValueError("Sales data is empty. Check Role A's API output.")

    # We need these columns for our analysis.
    required = {"customer_id", "sale_date", "total_price"}
    missing = required - set(df.columns)

    if missing:
        raise ValueError(f"Missing columns: {missing}")

    # Remove duplicate rows without changing the original DataFrame.
    df_clean = df.drop_duplicates().copy()

    # Convert dates from strings into datetime values.
    # Invalid dates become NaT (missing datetime).
    df_clean["sale_date"] = pd.to_datetime(
        df_clean["sale_date"], errors="coerce"
    )

    # Make sure prices are numeric so we can calculate revenue.
    df_clean["total_price"] = pd.to_numeric(
        df_clean["total_price"], errors="coerce"
    )

    # Count missing values so we know what needs attention.
    logger.info("Missing values:\n%s", df_clean.isna().sum())

    # Remove rows missing dates or prices because these are
    # essential for calculating accurate weekly revenue.
    before = len(df_clean)
    df_clean = df_clean.dropna(
        subset=["sale_date", "total_price"]
    ).copy()

    removed = before - len(df_clean)

    if removed:
        logger.warning("%s rows removed due to missing/invalid data", removed)

    if df_clean.empty:
        raise ValueError("No valid sales rows remain after cleaning.")

    # Negative prices may represent refunds; flag them for review.
    if (df_clean["total_price"] < 0).any():
        logger.warning("Negative prices found. Check refund handling.")

    logger.info("Cleaning complete: %s rows", len(df_clean))
    return df_clean


# FUNCTION 2: WEEKLY AGGREGATES
def calculate_weekly_aggregates(df):
    """Calculate weekly revenue, order count and average order value."""

    if df.empty:
        raise ValueError("Cannot aggregate empty sales data.")

    # This function expects the cleaned datetime column.
    if not pd.api.types.is_datetime64_any_dtype(df["sale_date"]):
        raise TypeError("Run clean_data() before calculating weekly sales.")

    df = df.copy()

    # Group dates into weeks beginning on Monday.
    df["week"] = df["sale_date"].dt.to_period("W").dt.start_time

    # Like SQL GROUP BY, combine transactions by week.
    weekly = df.groupby("week").agg(
        revenue=("total_price", "sum"),
        orders=("total_price", "size"),
        average_order_value=("total_price", "mean")
    ).reset_index()

    # Round monetary amounts to two decimal places.
    weekly[["revenue", "average_order_value"]] = weekly[
        ["revenue", "average_order_value"]
    ].round(2)

    logger.info("Weekly aggregation complete: %s weeks", len(weekly))
    return weekly


# FUNCTION 3: CALCULATE KPIs
def calculate_kpis(df):
    """Calculate the main business performance indicators."""

    if df.empty:
        raise ValueError("Cannot calculate KPIs from empty data.")

    # A dictionary stores each KPI under a descriptive name.
    kpis = {
        "total_revenue": round(df["total_price"].sum(), 2),

        # nunique() counts distinct customers, not transactions.
        "unique_customers": df["customer_id"].nunique(),

        # mean() calculates average order value.
        "average_order_value": round(df["total_price"].mean(), 2)
    }

    logger.info("KPIs calculated successfully")
    return kpis


# FUNCTION 4: MERGE DATASETS
def merge_datasets(df_sales, df_customers):
    """Combine sales and customers using customer_id."""

    if df_sales.empty or df_customers.empty:
        raise ValueError("Sales or customer data is empty.")

    # Both DataFrames must have customer_id for the JOIN.
    if "customer_id" not in df_sales.columns:
        raise ValueError("Sales data is missing customer_id")

    if "customer_id" not in df_customers.columns:
        raise ValueError("Customer data is missing customer_id")

    # A customer should occur only once in the customer table.
    # Otherwise, merging could multiply sales rows incorrectly.
    if df_customers["customer_id"].dropna().duplicated().any():
        raise ValueError("Duplicate customer IDs found in customer data.")

    # A LEFT JOIN keeps all sales, even without customer details.
    merged = pd.merge(
        df_sales,
        df_customers.dropna(subset=["customer_id"]),
        on="customer_id",
        how="left",
        validate="many_to_one"
    )

    # The merge should not increase or decrease the sales row count.
    if len(merged) != len(df_sales):
        raise ValueError("Merge changed the sales row count!")

    logger.info("Merge complete: %s rows", len(merged))
    return merged



# TEST: Only runs when we execute transform.py directly.
# It will NOT run when another teammate imports our functions.
if __name__ == "__main__":
    from data_fetcher import fetch_sales, fetch_customers

    # Display INFO, WARNING and ERROR messages.
    logging.basicConfig(
        level=logging.INFO,
        format="%(levelname)s: %(message)s"
    )

    # Role A: Fetch data from Supabase.
    sales = fetch_sales()
    customers = fetch_customers()

    # Role B: Clean, merge and analyse the data.
    clean_sales = clean_data(sales)
    merged = merge_datasets(clean_sales, customers)
    weekly = calculate_weekly_aggregates(merged)
    kpis = calculate_kpis(merged)

    # Display weekly results for validation.
    print("\nWEEKLY SALES:")
    print(weekly.head())

    # Display overall business KPIs.
    print("\nKPIs:")
    print(kpis)

    # Validate record counts before and after processing.
    print("\nROW COUNTS:")
    print("Raw sales:", len(sales))
    print("Clean sales:", len(clean_sales))
    print("Merged:", len(merged))

    # Check whether invoices are unique.
    print("Unique invoices:", sales["invoice_id"].nunique())

    # Flag negative prices that may represent returns or refunds.
    print("Negative prices:", (sales["total_price"] < 0).sum())
