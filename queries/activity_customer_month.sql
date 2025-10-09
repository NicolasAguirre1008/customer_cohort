-- View: activity_customer_month
-- Purpose:
--   Person–month activity table for retention analysis.
--   Grain = one row per customer_unique_id × activity_month.
-- Derivations:
--   - months_since = difference between activity_month and first_order_month
--   - active_flag = 1 (customer active in that month)
-- Why we keep it:
--   Foundation for overall cohort retention mart.

SELECT DISTINCT
  io.customer_unique_id,
  io.first_order_month,
  io,activity_month,
  io.payment_type,
  DATE_DIFF(io.activity_month, io.first_order_month, MONTH) AS months_since,
  1 AS active_flag,
  cc.cohort_city
FROM`olist_ecommerce.int_orders_with_cohort` AS io
JOIN `olist_ecommerce.int_cohort_city` AS cc 
  ON io.customer_unique_id = cc.customer_unique_id
  AND io.first_order_month = cc.first_order_month
WHERE io.order_status = 'delivered'