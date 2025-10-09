-- View: mart_cohort_retention_by_city
-- Purpose:
--   Retention matrix segmented by cohort_city.
--   Grain = one row per cohort_month × months_since × cohort_city.
-- Metrics:
--   - n_cohort
--   - n_active
--   - retention_pct
-- Why we keep it:
--   Identifies geographic differences in customer retention.


--mart_cohort_retention_by_city
WITH n_cohort AS (
  SELECT
    first_order_month,
    cohort_city,
    COUNT(DISTINCT(customer_unique_id)) AS n_cohort
  FROM `olist_ecommerce.activity_customer_month_with_customer_city`
  WHERE months_since = 0
  GROUP BY first_order_month, cohort_city
),

n_active AS (
  SELECT
    first_order_month,
    months_since,
    cohort_city,
    COUNT(DISTINCT(customer_unique_id)) AS n_active
  FROM `olist_ecommerce.activity_customer_month_with_customer_city`
  WHERE active_flag = 1 
    AND months_since >= 0
  GROUP BY first_order_month, months_since, cohort_city
)

SELECT
  a.first_order_month,
  a.months_since,
  a.cohort_city,
  a.n_active,
  c.n_cohort,
  SAFE_DIVIDE(a.n_active, c.n_cohort) AS retention_pct
FROM `n_active` AS a 
JOIN `n_cohort` AS c
  ON a.first_order_month = c.first_order_month
  AND a.cohort_city = c.cohort_city
ORDER BY a.first_order_month, a.months_since, a.cohort_city