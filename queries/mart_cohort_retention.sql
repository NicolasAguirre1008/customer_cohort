-- View: mart_cohort_retention
-- Purpose:
--   Final retention matrix (overall, no segmentation).
--   Grain = one row per cohort_month × months_since.
-- Metrics:
--   - n_cohort = cohort size (month 0)
--   - n_active = active customers in each subsequent month
--   - retention_pct = n_active / n_cohort
-- Why we keep it:
--   Standard cohort retention heatmap view.

-- Takes all customers in their cohort month (month_since=0); Counts distinct customers per first_order_month
-- n_cohort = the size of each cohort; i.e., how many customers started in that month; Denominator for retention %
WITH n_cohort AS (
  SELECT
    first_order_month,
    COUNT(DISTINCT(customer_unique_id)) AS n_cohort
  FROM `olist_ecommerce.activity_customer_month`
  WHERE months_since = 0
  GROUP BY first_order_month
),
-- For each first_order_month x months_since combination, counts distinct customers who were active in that month (active_flag =1)
-- n_active = number of customers from a given cohort who came back in each subsequent month. This is the numerator for retention %
n_active AS (
  SELECT
    first_order_month, months_since,
    COUNT(DISTINCT(customer_unique_id)) AS n_active
  FROM `olist_ecommerce.activity_customer_month`
  WHERE active_flag = 1
    AND months_since >=0
  GROUP BY first_order_month, months_since
)

SELECT
  a.first_order_month,
  a.months_since,
  c.n_cohort,
  a.n_active,
  SAFE_DIVIDE(a.n_active,c.n_cohort) AS retention_pct
FROM `n_active` AS a 
JOIN `n_cohort` AS c
  ON a.first_order_month = c.first_order_month
ORDER BY a.first_order_month, a.months_since