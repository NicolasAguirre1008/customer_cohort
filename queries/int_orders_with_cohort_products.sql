-- View: int_orders_with_cohort_products
-- Purpose:
--   Extends int_orders_with_cohort with product granularity.
--   Grain = one row per order_id × product_id.
-- Joins:
--   - order_items (on order_id)
--   - products (on product_id)
-- Key columns:
--   - product_id
--   - product_category_name
-- Why we keep it:
--   Required for retention analysis at product category level.

SELECT
  io.order_id,
  io.customer_unique_id,
  io.order_status,
  io.payment_type,
  io.customer_city,
  io.activity_date,
  io.activity_month,
  io.first_order_month,
  io.first_order_ts,
  io.order_delivered_customer_date,
  oi.product_id,
  pr.product_category_name
FROM `olist_ecommerce.int_orders_with_cohort` AS io 
  JOIN `olist_ecommerce.order_items` AS oi
    ON io.order_id = oi.order_id
  JOIN `olist_ecommerce.products` AS pr
    ON oi.product_id = pr.product_id