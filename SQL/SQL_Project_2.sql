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
  
                                                      