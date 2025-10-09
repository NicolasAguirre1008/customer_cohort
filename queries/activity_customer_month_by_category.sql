-- View: activity_customer_month_with_customer_city
-- Purpose:
--   Person–month activity table with city segmentation.
--   Grain = one row per customer_unique_id × activity_month × cohort_city.
-- Joins:
--   - int_orders_with_cohort (activity source)
--   - int_cohort_city (for frozen city assignment)
-- Why we keep it:
--   Enables retention analysis segmented by city.

SELECT DISTINCT
  io.customer_unique_id,
  io.first_order_month,
  io.activity_month,
  io.product_category_name,
  DATE_DIFF(io.activity_month, io.first_order_month, MONTH) AS months_since,
  1 AS active_flag
FROM `olist_ecommerce.int_orders_with_cohort_products` AS io 
WHERE io.order_status = 'delivered'