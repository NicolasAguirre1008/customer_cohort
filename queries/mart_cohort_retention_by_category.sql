-- View: mart_cohort_retention_by_category
-- Purpose:
--   Retention matrix segmented by product_category_name.
--   Grain = one row per cohort_month × months_since × category.
-- Metrics:
--   - n_cohort
--   - n_active
--   - retention_pct
-- Why we keep it:
--   Identifies retention patterns by product category (consumables vs long-cycle items).

WITH n_cohort AS (
  SELECT
    first_order_month,
    product_category_name,
    COUNT(DISTINCT(customer_unique_id)) AS n_cohort
  FROM `olist_ecommerce.activity_customer_month_by_category`
  WHERE months_since = 0
  GROUP BY first_order_month, product_category_name
),

n_active AS (
  SELECT
    first_order_month, months_since, product_category_name,
    COUNT(DISTINCT(customer_unique_id)) AS n_active
  FROM `olist_ecommerce.activity_customer_month_by_category`
  WHERE active_flag = 1
    AND months_since >=0
  GROUP BY first_order_month, months_since, product_category_name
)

SELECT
  a.first_order_month,
  a.months_since,
  a.product_category_name,
  c.n_cohort,
  a.n_active,
  SAFE_DIVIDE(a.n_active,c.n_cohort) AS retention_pct
FROM `n_active` AS a 
JOIN `n_cohort` AS c
  ON a.first_order_month = c.first_order_month
  AND a.product_category_name = c.product_category_name
ORDER BY a.first_order_month, a.months_since, a.product_category_name