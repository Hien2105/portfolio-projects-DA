--q1
select
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  sum(totals.visits) as visits,
  sum(totals.pageviews) as pageviews,
  sum(totals.transactions) as transactions,
from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
where _TABLE_SUFFIX between '0101' and '0331'
group by 1
order by 1;

--q2
select
    trafficSource.source as source,
    sum(totals.visits) as total_visits,
    sum(totals.Bounces) as total_no_of_bounces,
    (sum(totals.Bounces)/sum(totals.visits))* 100.00 as bounce_rate
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
group by source
order by total_visits DESC;

--q3
with 
month_data as(
  select
    "Month" as time_type,
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    trafficSource.source as source,
    sum(p.productRevenue)/1000000 as revenue
  from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  where p.productRevenue is not null
  group by 1,2,3
  order by revenue DESC
),

week_data as(
  select
    "Week" as time_type,
    format_date("%Y%W", parse_date("%Y%m%d", date)) as week,
    trafficSource.source as source,
    sum(p.productRevenue)/1000000 as revenue
  from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  where p.productRevenue is not null
  group by 1,2,3
  order by revenue DESC
)

select * from month_data
union all
select * from week_data;
order by time_type


--q4
with 
purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  and product.productRevenue is not null
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  and product.productRevenue is null
  group by month
)

select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
full join non_purchaser_data using(month)
order by pd.month;


--q5
select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    sum(totals.transactions)/count(distinct fullvisitorid) as Avg_total_transactions_per_user
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    ,unnest (hits) hits,
    unnest(product) product
where  totals.transactions>=1
and product.productRevenue is not null
group by month;

--q6
with Raw_data as(
  select
    FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) as month
    ,totals.visits as visits
    ,product.productRevenue as Revenue
  from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*` 
    ,unnest(hits) as hits
    ,unnest(hits.product) as product
  where totals.transactions is not null and product.productRevenue is not null
)

,Avg_per_visit as(
select 
  month
  ,sum(Revenue) as total_revenue
  ,sum(visits) as total_visit
  ,ROUND((sum(Revenue)/1000000)/sum(visits),2) as avg_revenue_by_user_per_visit
from Raw_data
group by month
)

select month, avg_revenue_by_user_per_visit
from Avg_per_visit;

select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    ((sum(product.productRevenue)/sum(totals.visits))/power(10,6)) as avg_revenue_by_user_per_visit
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  ,unnest(hits) hits
  ,unnest(product) product
where product.productRevenue is not null
and totals.transactions>=1
group by month;


--q7
select
    product.v2productname as other_purchased_product,
    sum(product.productQuantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
where fullvisitorid in (select distinct fullvisitorid
                        from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
                        unnest(hits) as hits,
                        unnest(hits.product) as product
                        where product.v2productname = "YouTube Men's Vintage Henley"
                        and product.productRevenue is not null)
and product.v2productname != "YouTube Men's Vintage Henley"
and product.productRevenue is not null
group byother_purchased_product
order by quantity desc;

with buyer_list as(
    select
        distinct fullVisitorId  
    from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    , unnest(hits) as hits
    , unnest(hits.product) as product
    where product.v2ProductName = "YouTube Men's Vintage Henley"
    and totals.transactions>=1
    and product.productRevenue is not null
)

select
  product.v2ProductName as other_purchased_products,
  sum(product.productQuantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, unnest(hits) as hits
, unnest(hits.product) as product
JOIN buyer_list using(fullVisitorId)
where product.v2ProductName != "YouTube Men's Vintage Henley"
 and product.productRevenue is not null
group by other_purchased_products
order by quantity DESC;


--q8
with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CasE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CasE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CasE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
from `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,unnest(hits) as hits
,unnest (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;






