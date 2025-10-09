-- View: stg_cohort_months
-- Purpose:
--   Assigns each customer to their cohort (first order).
--   Grain = one row per customer_unique_id.
-- Key columns:
--   - customer_unique_id
--   - first_order_ts = min(order_purchase_timestamp)
--   - first_order_month = truncated first order timestamp
-- Why we keep it:
--   Defines the baseline cohort for retention analysis.

WITH cohort_month AS (
  SELECT 
    c.customer_unique_id,
    MIN(order_purchase_timestamp) as first_order_ts,
    DATE_TRUNC(DATE(MIN(order_purchase_timestamp)), MONTH) as first_order_month
  FROM `olist_ecommerce.orders` AS o 
  JOIN `olist_ecommerce.customers` AS c 
    ON o.customer_id = c.customer_id
  GROUP BY c.customer_unique_id

)
SELECT
  customer_unique_id, first_order_ts, first_order_month
FROM cohort_month
ORDER BY cohort_month.first_order_ts