# SQL Project 2: Bicycle Manufacturer

## 1. Context
I query on the BigQuery environment and the dataset is based on the AdventureWorks2019 dataset.

![image](https://github.com/user-attachments/assets/6c4dc2f7-2b52-4ce4-87bf-b3d58f78677e)

## 2. Question and output
<details><summary><strong>Query 01: Calc Quantity of items, Sales value & Order quantity by each Subcategory in L12M</strong></summary>
<br>
  
```sql
--q1
select 
    FORMAT_dateTIME("%b %Y", Modifieddate) as period
    ,Subcategory
    ,sum(OrderQty) as qty_item
    ,sum(LineTotal) as total_sales
    ,count(DISTINCT SalesOrderID) as order_cnt
from `adventureworks2019.Sales.Product`as product
left join `adventureworks2019.Sales.SalesOrderDetail` as sale
on product.	ProductID = sale.	ProductID
where date(Modifieddate) >= (select date_SUB(max(date(Modifieddate)), INTERVAL 12 MonTH) 
                            from `adventureworks2019.Sales.SalesOrderDetail`)
group by product.Subcategory, FORMAT_dateTIME("%b %Y", Modifieddate)
order by period DESC,Subcategory;
```
Output

![image](https://github.com/user-attachments/assets/aeccb85d-b3bc-4a98-b38d-06bd83acef61)

</details>
<details><summary><strong>Query 02: Calc % YoY growth rate by SubCategory & release top 3 cat with highest grow rate. Can use metric: quantity_item. Round results to 2 decimal</strong></summary>
<br>
  
```sql
--q2
with 
sale_info as (
  select 
      FORMAT_TIMESTAMP("%Y", a.Modifieddate) as yr
      , c.Name
      , sum(a.OrderQty) as qty_item

  from `adventureworks2019.Sales.SalesOrderDetail` a 
  left join `adventureworks2019.Production.Product` b on a.ProductID = b.ProductID
  left join `adventureworks2019.Production.ProductSubcategory` c on cast(b.ProductSubcategoryID as int) = c.ProductSubcategoryID

  group by 1,2
  order by 2 asc , 1 desc
),

sale_diff as (
  select *
  , lead (qty_item) over (partition by Name order by yr desc) as prv_qty
  , round(qty_item / (lead (qty_item) over (partition by Name order by yr desc)) -1,2) as qty_diff
  from sale_info
  order by 5 desc 
),

rk_qty_diff as (
  select *
      ,dense_rank() over( order by qty_diff desc) dk
  from sale_diff
)

select distinct Name
      , qty_item
      , prv_qty
      , qty_diff
from rk_qty_diff 
where dk <=3
order by dk ;
```
Output

![image](https://github.com/user-attachments/assets/762f2d1b-f9ee-4a78-a27f-f60041050f23)

</details>
<details><summary><strong>Query 03: Ranking Top 3 TeritoryID with biggest Order quantity of every year. If there's TerritoryID with same quantity in a year, do not skip the rank number</strong></summary>
<br>
  
```sql
--q3
with 
sale_info as (
  select 
      FORMAT_TIMESTAMP("%Y", a.Modifieddate) as yr
      , b.TerritoryID
      , sum(OrderQty) as order_cnt 
  from `adventureworks2019.Sales.SalesOrderDetail` a 
  left join `adventureworks2019.Sales.SalesOrderHeader` b 
    on a.SalesOrderID = b.SalesOrderID
  group by 1,2
),

sale_rank as (
  select *
      , dense_rank() over (partition by yr order by order_cnt desc) as rk 
  from sale_info 
)

select yr
    , TerritoryID
    , order_cnt
    , rk
from sale_rank 
where rk in (1,2,3)   
;
```
Output

![image](https://github.com/user-attachments/assets/1092b220-dc9a-452e-994f-b6a50e0492a6)

</details>
<details><summary><strong>Query 04: Calc Total Discount Cost belongs to Seasonal Discount for each SubCategory</strong></summary>
<br>
  
```sql
--q4
select 
    FORMAT_TIMESTAMP("%Y", Modifieddate)
    , Name
    , sum(disc_cost) as total_cost
from (
      select distinct a.Modifieddate
      , c.Name
      , d.DiscountPct, d.Type
      , a.OrderQty * d.DiscountPct * UnitPrice as disc_cost 
      from `adventureworks2019.Sales.SalesOrderDetail` a
      left join `adventureworks2019.Production.Product` b on a.ProductID = b.ProductID
      left join `adventureworks2019.Production.ProductSubcategory` c on cast(b.ProductSubcategoryID as int) = c.ProductSubcategoryID
      left join `adventureworks2019.Sales.SpecialOffer` d on a.SpecialOfferID = d.SpecialOfferID
      where lower(d.Type) like '%seasonal discount%' 
)
group by 1,2;
```
Output

![image](https://github.com/user-attachments/assets/a5fa9fb9-e633-4388-8c8e-7befcb88eb98)

</details>
<details><summary><strong>Query 05: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis)</strong></summary>
<br>

```sql
--q5
with 
info as (
  select  
      extract(month from Modifieddate) as month_no
      , extract(year from Modifieddate) as year_no
      , CustomerID
      , count(Distinct SalesOrderID) as order_cnt
  from `adventureworks2019.Sales.SalesOrderHeader`
  where FORMAT_TIMESTAMP("%Y", Modifieddate) = '2014'
  and Status = 5
  group by 1,2,3
  order by 3,1 
),

row_num as (
  select *
      , row_number() over (partition by CustomerID order by month_no) as row_numb
  from info 
), 

first_order as (  
  select *
  from row_num
  where row_numb = 1
), 

month_gap as (
  select 
      a.CustomerID
      , b.month_no as month_join
      , a.month_no as month_order
      , a.order_cnt
      , concat('M - ',a.month_no - b.month_no) as month_diff
  from info a 
  left join first_order b 
  on a.CustomerID = b.CustomerID
  order by 1,3
)

select month_join
      , month_diff 
      , count(distinct CustomerID) as customer_cnt
from month_gap
group by 1,2
order by 1,2;
```
Output

![image](https://github.com/user-attachments/assets/a79b5b3b-4e8b-408d-af77-206f2a1ed67b)

</details>
<details><summary><strong>Query 06: Trend of Stock level & MoM diff % by all product in 2011. If %gr rate is null then 0. Round to 1 decimal</strong></summary>
<br>

```sql
--q6
with 
raw_data as (
  select
      extract(month from a.Modifieddate) as mth 
      , extract(year from a.Modifieddate) as yr 
      , b.Name
      , sum(StockedQty) as stock_qty

  from `adventureworks2019.Production.WorkOrder` a
  left join `adventureworks2019.Production.Product` b on a.ProductID = b.ProductID
  where FORMAT_TIMESTAMP("%Y", a.Modifieddate) = '2011'
  group by 1,2,3
  order by 1 desc 
)

select  Name
      , mth, yr 
      , stock_qty
      , stock_prv    
      , round(coalesce((stock_qty /stock_prv -1)*100 ,0) ,1) as diff   
from (                                                                 
      select *
      , lead (stock_qty) over (partition by Name order by mth desc) as stock_prv
      from raw_data
      )
order by 1 asc, 2 desc;
```
Output

![image](https://github.com/user-attachments/assets/17477ede-6760-44a7-bb2b-6507314ed25b)

</details>
<details><summary><strong>Query 07: Calc Ratio of Stock / Sales in 2011 by product name, by month Order results by month desc, ratio desc. Round Ratio to 1 decimal mom yoy</strong></summary>
<br>

```sql
--q7
with 
sale_info as (
  select 
      extract(month from a.Modifieddate) as mth 
     , extract(year from a.Modifieddate) as yr 
     , a.ProductId
     , b.Name
     , sum(a.OrderQty) as sales
  from `adventureworks2019.Sales.SalesOrderDetail` a 
  left join `adventureworks2019.Production.Product` b 
    on a.ProductID = b.ProductID
  where FORMAT_TIMESTAMP("%Y", a.Modifieddate) = '2011'
  group by 1,2,3,4
), 

stock_info as (
  select
      extract(month from Modifieddate) as mth 
      , extract(year from Modifieddate) as yr 
      , ProductId
      , sum(StockedQty) as stock_cnt
  from 'adventureworks2019.Production.WorkOrder'
  where FORMAT_TIMESTAMP("%Y", Modifieddate) = '2011'
  group by 1,2,3
)

select
      a.*
    , b.stock_cnt as stock  
    , round(coalesce(b.stock_cnt,0) / sales,2) as ratio
from sale_info a 
full join stock_info b 
  on a.ProductId = b.ProductId
and a.mth = b.mth 
and a.yr = b.yr
order by 1 desc, 7 desc;
```
Output

![image](https://github.com/user-attachments/assets/40ee7110-8020-4c6a-b2d6-874ffea02008)

</details>
<details><summary><strong>Query 08: No of order and value at Pending status in 2014</strong></summary>
<br>

```sql
--q8 
select 
    extract (year from Modifieddate) as yr
    , Status
    , count(distinct PurchaseOrderID) as order_Cnt 
    , sum(TotalDue) as value
from `adventureworks2019.Purchasing.PurchaseOrderHeader`
where Status = 1
and extract(year from Modifieddate) = 2014
group by 1,2
;
```
Output

![image](https://github.com/user-attachments/assets/7f99272e-1c2c-4f71-abd2-c8fe717a30e2)

</details>


