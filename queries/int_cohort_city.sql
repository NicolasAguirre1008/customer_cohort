-- View: int_cohort_city
-- Purpose:
--   Assigns a fixed city (“cohort_city”) to each customer at acquisition.
--   Grain = one row per customer_unique_id × first_order_month.
-- Method:
--   - Filters to orders in the cohort month.
--   - Uses ROW_NUMBER() to pick deterministic first delivered order.
-- Key columns:
--   - customer_unique_id
--   - first_order_month
--   - cohort_city
-- Why we keep it:
--   Freezes city at acquisition; prevents customer moves from inflating retention.


SELECT
  customer_unique_id,
  first_order_month,
  ANY_VALUE(customer_city) AS cohort_city
FROM `olist_ecommerce.int_orders_with_cohort`
WHERE order_status = 'delivered'
  AND activity_month = first_order_month   -- cohort month rows only
GROUP BY customer_unique_id, first_order_month;