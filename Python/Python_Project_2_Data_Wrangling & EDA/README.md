# Python Project 2: Data wrangling & EDA 
Given dataset
Suppose you are a DA in an e-wallet company, and you need to analyze the following datasets:
<br>
- payment_report.csv (monthly payment volume of products)
- product.csv (product information)
- transactions.csv (transactions information)

## Part I: EDA
Do EDA task:
- Df payment_enriched (Merge payment_report.csv with product.csv)
- Df transactions

Import file
```python
import pandas as pd
payment_report = pd.read_csv('C:\\Users\\ADMIN\\Desktop\\Python\\Project_2\\payment_report.csv')
product = pd.read_csv('C:\\Users\\ADMIN\\Desktop\\Python\\Project_2\\product.csv')
transactions = pd.read_csv('C:\\Users\\ADMIN\\Desktop\\Python\\Project_2\\transactions.csv')
```
<details> <summary><strong>Df payment_enriched</strong></summary>
  
```python
# Df payment_enriched (Merge payment_report.csv with product.csv)
payment_enriched = payment_report.merge(product, on='product_id')
#change column type 
payment_enriched['report_month'] = pd.to_datetime(payment_enriched['report_month'])
payment_enriched['payment_group'] = payment_enriched['payment_group'].astype('string')
payment_enriched['category'] = payment_enriched['category'].astype('string')
payment_enriched['team_own'] = payment_enriched['team_own'].astype('string')
#check dup
print("duplicate count: " + str(payment_enriched.duplicated().sum()))
#check null
print("Null count:")
print(payment_enriched.isnull().sum())
print(payment_enriched.info())
print(payment_enriched.describe())

# EDA summary
#1 Change report_month, payment_group, category, team_own type to match the column values
#2 Check duplicate
#3 Check Null 
```
output
```
duplicate count: 0
Null count:
report_month     0
payment_group    0
product_id       0
source_id        0
volume           0
category         0
team_own         0
dtype: int64
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 897 entries, 0 to 896
Data columns (total 7 columns):
 #   Column         Non-Null Count  Dtype         
---  ------         --------------  -----         
 0   report_month   897 non-null    datetime64[ns]
 1   payment_group  897 non-null    string        
 2   product_id     897 non-null    int64         
 3   source_id      897 non-null    int64         
 4   volume         897 non-null    int64         
 5   category       897 non-null    string        
 6   team_own       897 non-null    string        
dtypes: datetime64[ns](1), int64(3), string(3)
memory usage: 49.2 KB
None
                     report_month    product_id  source_id        volume
count                         897    897.000000      897.0  8.970000e+02
mean   2023-02-19 07:45:33.110368   1139.573021       45.0  1.338153e+08
min           2023-01-01 00:00:00     12.000000       45.0  1.000000e+04
25%           2023-02-01 00:00:00    634.000000       45.0  1.258000e+06
50%           2023-03-01 00:00:00   1023.000000       45.0  7.469786e+06
75%           2023-04-01 00:00:00   1578.000000       45.0  4.770741e+07
max           2023-04-01 00:00:00  15067.000000       45.0  4.926051e+09
std                           NaN   1161.547355        0.0  4.614672e+08
```
</details> 
<details> <summary><strong>Df transactions</strong></summary>
  
```python
#Df transactions
#change column type and abs id column to prevent - value 
transactions['sender_id'] = transactions['sender_id'].fillna(0).astype(int)
transactions['receiver_id'] = transactions['receiver_id'].fillna(0).astype(int)
transactions['receiver_id'] = transactions['receiver_id'].abs()
transactions['transStatus'] = transactions['transStatus'].abs()
#check dup and remove dup
print("duplicate count: " + str(transactions.duplicated().sum()))
transaction_remove_dup = transactions.drop_duplicates(subset = ['transaction_id'])
print("duplicate count after remove: " + str(transaction_remove_dup.duplicated().sum()))
#check null
print("Null count:")
print(transactions.isnull().sum())
print(transactions.info())
print(transactions.describe())

# EDA summary
#1 Change sender_id, receiver_id type to match the column values 
#1.1 fill Na value of sender_id, receiver_id
#1.2 abs value to prevent - value
#2 Check duplicate => remove dup
#3 Check Null 
```
output
```
duplicate count: 28
duplicate count after remove: 0
Null count:
transaction_id          0
merchant_id             0
volume                  0
transType               0
transStatus             0
sender_id               0
receiver_id             0
extra_info        1317907
timeStamp               0
dtype: int64
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 1324002 entries, 0 to 1324001
Data columns (total 9 columns):
 #   Column          Non-Null Count    Dtype 
---  ------          --------------    ----- 
 0   transaction_id  1324002 non-null  int64 
 1   merchant_id     1324002 non-null  int64 
 2   volume          1324002 non-null  int64 
 3   transType       1324002 non-null  int64 
 4   transStatus     1324002 non-null  int64 
 5   sender_id       1324002 non-null  int64 
 6   receiver_id     1324002 non-null  int64 
 7   extra_info      6095 non-null     object
 8   timeStamp       1324002 non-null  int64 
dtypes: int64(8), object(1)
memory usage: 90.9+ MB
None
       transaction_id   merchant_id        volume     transType   transStatus  \
count    1.324002e+06  1.324002e+06  1.324002e+06  1.324002e+06  1.324002e+06   
mean     3.002233e+09  2.460318e+03  2.388059e+05  6.979222e+00  1.393262e+01   
std      1.042606e+07  3.304277e+03  9.681009e+05  7.459714e+00  5.533720e+01   
min      3.000000e+09  5.000000e+00  1.000000e+00  2.000000e+00  1.000000e+00   
25%      3.001121e+09  3.050000e+02  1.000000e+04  2.000000e+00  1.000000e+00   
50%      3.002200e+09  2.250000e+03  3.000000e+04  2.000000e+00  1.000000e+00   
75%      3.003255e+09  2.270000e+03  1.000000e+05  8.000000e+00  1.000000e+00   
max      6.000066e+09  1.625250e+05  7.869148e+07  3.000000e+01  1.333000e+03   

          sender_id   receiver_id     timeStamp  
count  1.324002e+06  1.324002e+06  1.324002e+06  
mean   9.956267e+07  1.825384e+08  1.683130e+12  
std    6.120830e+08  8.717789e+08  1.707815e+08  
min    0.000000e+00  0.000000e+00  1.682874e+12  
25%    1.004013e+07  4.060000e+04  1.682994e+12  
50%    1.057186e+07  3.529736e+06  1.683097e+12  
75%    2.100163e+07  2.451345e+07  1.683269e+12  
max    6.993439e+09  2.100000e+10  1.683479e+12
```
</details><br>

## Part II: Data Wrangling
<details> <summary><strong>1. Top 3 product_ids with the highest volume.</strong></summary>

```python
top_3_product_id = pd.DataFrame(payment_report.groupby('product_id')['volume'].sum().sort_values(ascending=False).head(3))
print(top_3_product_id)
```
output
```
volume
product_id             
1976        61797583647
429         14667676567
372         13713658515
```
</details>
<details> <summary><strong>2. Given that 1 product_id is only owed by 1 team, are there any abnormal products against this rule?</strong></summary>

```python
check = pd.DataFrame(product.groupby('product_id')['team_own'].count().sort_index())
print(check)

#There is no abnormal products
```
output
```
team_own
product_id          
9                  1
10                 1
11                 1
12                 1
14                 1
...              ...
2408               1
2419               1
2587               1
10039              1
15067              1

[492 rows x 1 columns]
```
</details>
<details> <summary><strong>3. Find the team has had the lowest performance (lowest volume) since Q2.2023. Find the category that contributes the least to that team.</strong></summary>

```python
payment_report_team = payment_report.merge(product, on='product_id')
#filter time
payment_report_team['report_month'] = pd.to_datetime(payment_report_team['report_month'])
Q2_payment = payment_report_team[payment_report_team['report_month'] >= '04-2023']
#lowest performance team
lowest_performance = pd.DataFrame(Q2_payment.groupby(['team_own'])['volume'].sum().sort_values().head(1))
lowest_performance_filtered = Q2_payment[Q2_payment['team_own'] == 'APS']
#category that contributes the least to that team
lowest_category = pd.DataFrame(lowest_performance_filtered.groupby(['category'])['volume'].sum().sort_values().head(1))
print(lowest_performance)
print(lowest_category)
```
output
```
team_own    volume     
APS       51141753
            volume
category          
PXXXXXE   25232438
```
</details>
<details> <summary><strong>4. Find the contribution of source_ids of refund transactions (payment_group = ‘refund’), what is the source_id with the highest contribution?</strong></summary>

```python
payment_report_refund = payment_report[payment_report['payment_group'] == 'refund']
payment_report_refund = pd.DataFrame(payment_report_refund.groupby('source_id')['volume'].sum().sort_values(ascending=False).head(1))
print(payment_report_refund)
```
output
```
source_id	  volume
38	      36527454759
```
</details>
<details> <summary><strong>5. Using transactions.csv. Define type of transactions (‘transaction_type’) for each row, given:</strong></summary>
- transType = 2 & merchant_id = 1205: Bank Transfer Transaction
- transType = 2 & merchant_id = 2260: Withdraw Money Transaction
- transType = 2 & merchant_id = 2270: Top Up Money Transaction
- transType = 2 & others merchant_id: Payment Transaction
- transType = 8, merchant_id = 2250: Transfer Money Transaction
- transType = 8 & others merchant_id: Split Bill Transaction
- Remained cases are invalid transactions
  
```python
transaction_remove_dup.loc[:, 'transaction_type'] = 'Invalid Transaction'
transaction_remove_dup.loc[transaction_remove_dup['transType'] == 2, 'transaction_type'] = 'Payment Transaction'
transaction_remove_dup.loc[(transaction_remove_dup['transType'] == 2) & (transaction_remove_dup['merchant_id'] == 1205), 'transaction_type'] = 'Bank Transfer Transaction'
transaction_remove_dup.loc[(transaction_remove_dup['transType'] == 2) & (transaction_remove_dup['merchant_id'] == 2260), 'transaction_type'] = 'Withdraw Money Transaction'
transaction_remove_dup.loc[(transaction_remove_dup['transType'] == 2) & (transaction_remove_dup['merchant_id'] == 2270), 'transaction_type'] = 'Top Up Money Transaction'
transaction_remove_dup.loc[transaction_remove_dup['transType'] == 8, 'transaction_type'] = 'Split Bill Transaction'
transaction_remove_dup.loc[(transaction_remove_dup['transType'] == 8) & (transaction_remove_dup['merchant_id'] == 2250), 'transaction_type'] = 'Transfer Money Transaction'
print(transaction_remove_dup[['transaction_id','transType','merchant_id', 'transaction_type']])
```
output
```
transaction_id  transType  merchant_id            transaction_type
0            3002692434         24            5         Invalid Transaction
1            3002692437          2          305         Payment Transaction
2            3001960110         22         7255         Invalid Transaction
3            3002680710          2         2270    Top Up Money Transaction
4            3002680713          2         2275         Payment Transaction
...                 ...        ...          ...                         ...
1323997      3003723030          2          305         Payment Transaction
1323998      3003723033          2         2270    Top Up Money Transaction
1323999      3003723036          2         2270    Top Up Money Transaction
1324000      3003723039         22            5         Invalid Transaction
1324001      3003602967          8         2250  Transfer Money Transaction

[1323974 rows x 4 columns]
```
</details>
<details> <summary><strong>6. Of each transaction type (excluding invalid transactions): find the number of transactions, volume, senders and receivers.</strong></summary>

```python
transaction_remove_dup_filtered = transaction_remove_dup[transaction_remove_dup['transaction_type'] != 'Invalid Transaction']
transaction_remove_dup_filtered = transaction_remove_dup_filtered.groupby('transaction_type')[['transaction_id', 'volume', 'sender_id', 'receiver_id']].agg({'transaction_id':'count','volume':'sum','sender_id':'nunique','receiver_id':'nunique'})
print(transaction_remove_dup_filtered)
```
output
```
                            transaction_id        volume  sender_id  \
transaction_type                                                      
Bank Transfer Transaction            37879   50605806190      23156   
Payment Transaction                 398665   71850608441     139583   
Split Bill Transaction                1376       4901464       1323   
Top Up Money Transaction            290498  108605618829     110409   
Transfer Money Transaction          341173   37032880492      39021   
Withdraw Money Transaction           33725   23418181420      24814   
                            receiver_id  
transaction_type                         
Bank Transfer Transaction          9272  
Payment Transaction              113297  
Split Bill Transaction              572  
Top Up Money Transaction         110409  
Transfer Money Transaction        34585  
Withdraw Money Transaction        24814
```
</details>
