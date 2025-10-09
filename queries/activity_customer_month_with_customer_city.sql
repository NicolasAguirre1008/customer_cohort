-- View: activity_customer_month_by_category
-- Purpose:
--   Person–month activity table with product category segmentation.
--   Grain = one row per customer_unique_id × activity_month × product_category_name.
-- Joins:
--   - int_orders_with_cohort_products (order × product level)
-- Why we keep it:
--   Enables retention analysis segmented by product category.

WITH person_month AS (
  SELECT DISTINCT
    customer_unique_id, first_order_month, activity_month
  FROM `olist_ecommerce.int_orders_with_cohort`
  WHERE order_status = 'delivered'
)
SELECT
  pm.customer_unique_id,
  pm.first_order_month,
  pm.activity_month,
  DATE_DIFF(pm.activity_month, pm.first_order_month, MONTH) AS months_since,
  1 AS active_flag,
  cc.cohort_city
FROM person_month AS pm
JOIN `olist_ecommerce.int_cohort_city` AS cc 
  on pm.customer_unique_id = cc.customer_unique_id
  AND pm.first_order_month = cc.first_order_month