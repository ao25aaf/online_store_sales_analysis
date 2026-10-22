# Online Store Sales Analysis

## The question

Which products, categories and customers bring in the most money?

## The dataset

`bigquery-public-data.thelook_ecommerce`, a fictional online clothing store, available free in BigQuery's sandbox.

Tables used, with row counts on the run date:

| Table | Rows |
|---|---|
| `users` | 100,000 |
| `orders` | 125,090 |
| `order_items` | 181,596 |
| `products` | 29,120 |

Queries were run on **22 October 2026**. The dataset is regenerated periodically, so if you re-run the queries later, the numbers may differ slightly.

**Revenue rule used throughout:** only items whose status is *not* Cancelled or Returned count as revenue.

## How to reproduce

Query outputs are saved as CSV files in the results folder.

1. Open [BigQuery](https://console.cloud.google.com/bigquery) and create a free sandbox project (no credit card needed).
2. Open a new query tab.
3. Copy the queries from `online_store_sales_analysis_queries.sql` and run them one at a time.

## Key findings

1. **Revenue has grown strongly.** Monthly revenue went from about $1,750 in Feb 2019 to about $375,000 in Sep 2026 (Q2). Jan 2019 and Oct 2026 are left out because they are partial months.
2. **One in four orders never earns money.** About 15.1% of orders are cancelled, and 10.0% are returned (Q4).
3. **Outerwear & Coats and Jeans are the top categories.** They bring in about $1.01M and $0.93M, well ahead of third-placed Sweaters at about $0.64M (Q3).
4. **No single customer dominates.** The top 10 customers spent between $1,318 and $1,651 each, so the best customer is only about 25% ahead of the tenth (Q5).
5. **Country barely affects item price.** Among the 11 countries with at least 1,000 items sold, the average item price falls between $58.67 and $60.85 (Q6).

## What I learned

- How to filter out cancelled and returned items so revenue is not overstated, and why the same rule must be used in every query.
- How to join two tables on a shared column (`users` to `order_items`, `products` to `order_items`).
- How to group by month using `DATE_TRUNC`.
- How `HAVING` filters groups: small countries such as "Deutschland" (4 items) gave misleading averages until I set a minimum of 1,000 items.
- How to check results for data quality, such as the same country spelt two ways (`Spain` / `España`, `Germany` / `Deutschland`).

## What I'd look at next

Why are 1 in 4 orders cancelled or returned, and does it happen more in some categories than others?

## Limitations

- The data is synthetic, so the patterns may not reflect a real store.
- Q6 is *average item price*, not average order value.
- Q3, Q5 and Q6 cover all dates, including the partial month of Oct 2026.
- A few country names appear in two spellings and were not merged. The effect is tiny.
- This is exploratory analysis. No experiments were run.
