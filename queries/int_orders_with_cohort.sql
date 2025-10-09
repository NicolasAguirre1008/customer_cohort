-- View: int_orders_with_cohort
-- Purpose:
--   Combines stg_orders with stg_cohort_months.
--   Grain = one row per order_id.
-- Key columns:
--   - order_id
--   - customer_unique_id
--   - order_status
--   - activity_date, activity_month
--   - first_order_ts, first_order_month
-- Why we keep it:
--   Provides cohort context at order level (each order “knows” its cohort).

SELECT
  so.customer_unique_id,
  so.order_status,
  so.payment_type,
  so.customer_city,
  so.activity_date,
  so.activity_month,
  sc.first_order_month,
  sc.first_order_ts,
  so.order_id,
  so.order_delivered_customer_date 
FROM `olist_ecommerce.stg_orders` AS so
JOIN `olist_ecommerce.stg_cohort_months` AS sc 
  ON so.customer_unique_id = sc.customer_unique_id 