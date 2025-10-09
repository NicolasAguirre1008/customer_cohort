flowchart TD

subgraph STG[Staging Layer]
  stg_orders[stg_orders<br/>Orders + Customers + Payment]
  stg_cohort[stg_cohort_months<br/>First order per customer]
end

subgraph INT[Intermediate Layer]
  int_orders[int_orders_with_cohort<br/>Orders + Cohort info]
  int_city[int_cohort_city<br/>Cohort city (frozen at Month 0)]
  int_products[int_orders_with_cohort_products<br/>Orders + Product categories]
end

subgraph ACT[Activity Layer]
  act_overall[activity_customer_month<br/>Person–Month]
  act_city[activity_customer_month_with_customer_city<br/>Person–Month–City]
  act_cat[activity_customer_month_by_category<br/>Person–Month–Category]
end

subgraph MART[Mart Layer]
  mart_overall[mart_cohort_retention<br/>Overall retention]
  mart_city[mart_cohort_retention_by_city<br/>Retention by city]
  mart_cat[mart_cohort_retention_by_category<br/>Retention by category]
end

%% Connections
stg_orders --> int_orders
stg_cohort --> int_orders

int_orders --> int_city
int_orders --> int_products
int_orders --> act_overall

int_city --> act_city
int_products --> act_cat

act_overall --> mart_overall
act_city --> mart_city
act_cat --> mart_cat
