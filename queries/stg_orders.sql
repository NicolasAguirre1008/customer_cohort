-- View: stg_orders
-- Purpose:
--   Cleaned order-level dataset, enriched with customer + payment details.
--   Grain = one row per order_id.
-- Key columns:
--   - order_id
--   - customer_unique_id
--   - customer_city
--   - order_status
--   - order_purchase_timestamp → activity_date + activity_month
--   - payment_type (from payment_one view)
-- Why we keep it:
--   Standardized order table is the backbone for all joins downstream.

SELECT 
  -- Keys
  o.order_id,
  c.customer_unique_id,
  o.customer_id,

  -- Order attributes
  o.order_status,
  p1.payment_type,
  c.customer_city,

  -- Important timestamps
  o.order_approved_at,
  o.order_delivered_customer_date,
  DATE(o.order_purchase_timestamp) AS activity_date,
  DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS activity_month
FROM `olist_ecommerce.orders` AS o
JOIN `olist_ecommerce.customers` AS c ON o.customer_id = c.customer_id
JOIN `olist_ecommerce.payment_one` AS p1 ON o.order_id = p1.order_id