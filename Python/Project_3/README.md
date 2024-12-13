# Python Project 3: RFM Analysis
Context:
<br>
- SuperStore is a global retail company, which means it has a vast number of customers.During the Christmas and New Year seasons, the Marketing Department plans to launch marketing campaigns to express gratitude to loyal customers who have supported the company over the years. 
- They also aim to target potential customers who might become loyal ones. However, the Marketing Department has not yet segmented this year's customers due to the large dataset, making it impossible to handle manually as in previous years. Therefore, they have asked the Data Analytics Department to assist in solving a segmentation problem to classify customers into groups, enabling the deployment of tailored marketing programs for each group. The Marketing Director has proposed using the RFM model. 
- Previously, when the company was smaller, the team could perform segmentation using Excel. However, given the current large volume of data, they hope the Data Team can develop a workflow for segmentation using Python programming.

Proposed Approach:
<br>
<details><summary><strong>Import file</strong></summary>

```python
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
#Read file and have a quick scan of data
ecommerce_retail_data = pd.read_excel('C:\\Users\\ADMIN\\Desktop\\Python\\Project_3\\Final_project_RFM\\ecommerce_retail.xlsx')
ecommerce_retail_segment = pd.read_excel('C:\\Users\\ADMIN\\Desktop\\Python\\Project_3\\Final_project_RFM\\ecommerce_retail.xlsx', sheet_name='Segmentation')
print(ecommerce_retail_data.head())
print(' ')
print(ecommerce_retail_segment.head())
```
 output
 ```
 InvoiceNo StockCode                          Description  Quantity         InvoiceDate  UnitPrice  CustomerID         Country
 0    536365    85123A   WHITE HANGING HEART T-LIGHT HOLDER         6 2010-12-01 08:26:00       2.55     17850.0  United Kingdom
 1    536365     71053                  WHITE METAL LANTERN         6 2010-12-01 08:26:00       3.39     17850.0  United Kingdom
 2    536365    84406B       CREAM CUPID HEARTS COAT HANGER         8 2010-12-01 08:26:00       2.75     17850.0  United Kingdom
 3    536365    84029G  KNITTED UNION FLAG HOT WATER BOTTLE         6 2010-12-01 08:26:00       3.39     17850.0  United Kingdom
 4    536365    84029E       RED WOOLLY HOTTIE WHITE HEART.         6 2010-12-01 08:26:00       3.39     17850.0  United Kingdom
   
                Segment                                          RFM Score
   0           Champions                  555, 554, 544, 545, 454, 455, 445
   1               Loyal             543, 444, 435, 355, 354, 345, 344, 335
   2  Potential Loyalist  553, 551, 552, 541, 542, 533, 532, 531, 452, 4...
   3       New Customers                  512, 511, 422, 421, 412, 411, 311
   4           Promising  525, 524, 523, 522, 521, 515, 514, 513, 425,42...
   ```
</details><br>
<details><summary><strong>1. Prepare the dataset suitable for the RFM model.</strong></summary>
 
   ```python
   # Check Duplicate
   print("duplicate count: " + str(ecommerce_retail_data.duplicated(subset=["InvoiceNo", "StockCode","InvoiceDate","CustomerID"]).sum()))
   # Remove Duplicate
   ecommerce_retail_data = ecommerce_retail_data.drop_duplicates(subset=["InvoiceNo", "StockCode","InvoiceDate","CustomerID"])
   print("duplicate count after remove: " + str(ecommerce_retail_data.duplicated(subset=["InvoiceNo", "StockCode","InvoiceDate","CustomerID"]).sum()))
   
   # Check NA
   print('Na count')
   print(ecommerce_retail_data.isna().sum())
   ecommerce_retail_data= ecommerce_retail_data.dropna(subset='CustomerID')
   # Remove NA
   print('Na count after remove')
   print(ecommerce_retail_data.isna().sum())
   
   # Change ecommerce_retail_data Data Type
   print('ecommerce_retail_data data type')
   ecommerce_retail_data['CustomerID'] = ecommerce_retail_data['CustomerID'].astype('string')
   ecommerce_retail_data['InvoiceNo'] = ecommerce_retail_data['InvoiceNo'].astype('string')
   ecommerce_retail_data['StockCode'] = ecommerce_retail_data['StockCode'].astype('string')
   ecommerce_retail_data['Description'] = ecommerce_retail_data['Description'].astype('string')
   ecommerce_retail_data['Country'] = ecommerce_retail_data['Country'].astype('string')
   print(ecommerce_retail_data.dtypes)
   
   # Change ecommerce_retail_segment Data Type
   print('ecommerce_retail_segment data type')
   ecommerce_retail_segment['RFM Score'] = ecommerce_retail_segment['RFM Score'].astype('string')
   print(ecommerce_retail_segment.dtypes)
   
   # Remove outlier using IQR for ecommerce_retail_data
   ecommerce_retail_data= ecommerce_retail_data[ecommerce_retail_data['Quantity'] > 0]
   # Quantity IQR 
   seventy_fifth = ecommerce_retail_data['Quantity'].quantile(0.75)
   twenty_fifth = ecommerce_retail_data['Quantity'].quantile(0.25)
   Quantity_iqr = seventy_fifth - twenty_fifth
   Quantity_upper = seventy_fifth + (1.5 * Quantity_iqr)
   Quantity_lower = twenty_fifth - (1.5 * Quantity_iqr)
   
   # UnitPrice IQR 
   seventy_fifth = ecommerce_retail_data['UnitPrice'].quantile(0.75)
   twenty_fifth = ecommerce_retail_data['UnitPrice'].quantile(0.25)
   UnitPrice_iqr = seventy_fifth - twenty_fifth
   UnitPrice_upper = seventy_fifth + (1.5 * UnitPrice_iqr)
   UnitPrice_lower = twenty_fifth - (1.5 * UnitPrice_iqr)
   
   # Use IQR to filter Quantity, UnitPrice outlier
   ecommerce_retail_data = ecommerce_retail_data[(ecommerce_retail_data['UnitPrice']>UnitPrice_lower) & (ecommerce_retail_data['UnitPrice']<UnitPrice_upper) & (ecommerce_retail_data['Quantity']>Quantity_lower) & (ecommerce_retail_data['Quantity']<Quantity_upper)]
   
   print(ecommerce_retail_data.describe())
   ```
   output
   ```
   duplicate count: 10677
duplicate count after remove: 0

   Na count
   InvoiceNo           0
   StockCode           0
   Description      1454
   Quantity            0
   InvoiceDate         0
   UnitPrice           0
   CustomerID     134546
   Country             0
   dtype: int64

   Na count after remove
   InvoiceNo      0
   StockCode      0
   Description    0
   Quantity       0
   InvoiceDate    0
   UnitPrice      0
   CustomerID     0
   Country        0
   dtype: int64

   ecommerce_retail_data data type
   InvoiceNo      string[python]
   StockCode      string[python]
   Description    string[python]
   Quantity                int64
   InvoiceDate    datetime64[ns]
   UnitPrice             float64
   CustomerID     string[python]
   Country        string[python]
   dtype: object

ecommerce_retail_segment data type
   Segment              object
   RFM Score    string[python]
   dtype: object

                  Quantity                    InvoiceDate      UnitPrice
   count  327982.000000                         327982  327982.000000
   mean        7.612979  2011-07-12 03:57:18.824752384       2.190757
   min         1.000000            2010-12-01 08:26:00       0.000000
   25%         2.000000            2011-04-08 08:20:00       1.250000
   50%         6.000000            2011-08-02 14:04:00       1.650000
   75%        12.000000            2011-10-21 13:24:00       2.950000
   max        26.000000            2011-12-09 12:50:00       7.460000
   std         6.792468                            NaN       1.533964
   ```
</details><br>
<details><summary><strong>2. Define and calculate the R, F, and M scores for each customer.</strong></summary>
 <br>
   Note: The reference date for the R score is December 31, 2011.
      
   ```python
   #Caculate cusotmer spend
   ecommerce_retail_data['Spend'] = ecommerce_retail_data['Quantity'] * ecommerce_retail_data['UnitPrice']
   
   #Caculate R, F, M
   RFM = ecommerce_retail_data.groupby('CustomerID').agg( Recency =('InvoiceDate', lambda x: (pd.to_datetime('2011-12-31') - x.max()).days) \
                                                         ,Frequency =('CustomerID', lambda x: x.count()) \
                                                         ,Monetary =('Spend', lambda x: x.sum())
                                                          ).reset_index()
   ```
   output
   ```
   CustomerID  Recency  Frequency  Monetary  
   3039    16626.0       21        129   2337.14                                  
   136     12518.0       21        114   1750.09                              
   60      12423.0       21        111   1535.61                                  
   3829    17754.0       21         76    970.88                               
   143     12526.0       21         63   1074.46                        
   ...         ...      ...        ...       ...               
   2208    15447.0      351          8    129.67                           
   1963    15107.0      351          8    104.10                         
   248     12652.0      352         44    732.28                               
   1373    14270.0      352         22    341.65                              
   1314    14185.0      352          1     12.75                          
   
   [3536 rows x 4 columns]
   ```
</details><br>
<details><summary><strong>3. Develop a scoring method with a scale of 1 to 5.</strong></summary>
 <br>
Suggestion: Use the quintile method in statistics.
   
```python
#caculate R, F, M IQR
seventy_fifth = RFM['Recency'].quantile(0.75)
twenty_fifth = RFM['Recency'].quantile(0.25)
Recency_iqr = seventy_fifth - twenty_fifth
Recency_upper = seventy_fifth + (1.5 * Recency_iqr)
Recency_lower = twenty_fifth - (1.5 * Recency_iqr)

seventy_fifth = RFM['Frequency'].quantile(0.75)
twenty_fifth = RFM['Frequency'].quantile(0.25)
Frequency_iqr = seventy_fifth - twenty_fifth
Frequency_upper = seventy_fifth + (1.5 * Frequency_iqr)
Frequency_lower = twenty_fifth - (1.5 * Frequency_iqr)

seventy_fifth = RFM['Monetary'].quantile(0.75)
twenty_fifth = RFM['Monetary'].quantile(0.25)
Monetary_iqr = seventy_fifth - twenty_fifth
Monetary_upper = seventy_fifth + (1.5 * Monetary_iqr)
Monetary_lower = twenty_fifth - (1.5 * Monetary_iqr)

#Use IQR to filter R, F, M outlier  
RFM_remove_outliner = RFM[
                           (RFM['Recency'] > Recency_lower) & (RFM['Recency'] < Recency_upper) &
                           (RFM['Frequency'] > Frequency_lower) & (RFM['Frequency'] < Frequency_upper) &
                           (RFM['Monetary'] > Monetary_lower)& (RFM['Monetary'] < Monetary_upper)
                                ]
#Sort R, F, M
RFM_remove_outliner = RFM_remove_outliner.sort_values(['Recency','Frequency','Monetary'], ascending=(True, False, False))
#USe qcut to Score R,F,M
RFM_remove_outliner['Recency_Score'] = 6 - (pd.qcut(RFM_remove_outliner['Recency'], 5,labels=False) + 1)
RFM_remove_outliner['Frequency_Score'] = pd.qcut(RFM_remove_outliner['Frequency'], 5,labels=False) + 1
RFM_remove_outliner['Monetary_Score'] = pd.qcut(RFM_remove_outliner['Monetary'], 5,labels=False) + 1

#Megre R,F,M into RFM_Score column
RFM_remove_outliner['RFM_Score'] = RFM_remove_outliner['Recency_Score'].astype(str) + RFM_remove_outliner['Frequency_Score'].astype(str) + RFM_remove_outliner['Monetary_Score'].astype(str)
RFM_remove_outliner['RFM_Score'] = RFM_remove_outliner['RFM_Score'].astype(int)
pd.set_option('display.max_columns', None) 
pd.set_option('display.width', 1000)
print(RFM_remove_outliner)
```
output
```
CustomerID  Recency  Frequency  Monetary  Recency_Score  Frequency_Score  Monetary_Score  RFM_Score
3039    16626.0       21        129   2337.14              5                5               5        555
136     12518.0       21        114   1750.09              5                5               5        555
60      12423.0       21        111   1535.61              5                5               5        555
3829    17754.0       21         76    970.88              5                5               5        555
143     12526.0       21         63   1074.46              5                4               5        545
...         ...      ...        ...       ...            ...              ...             ...        ...
2208    15447.0      351          8    129.67              1                1               1        111
1963    15107.0      351          8    104.10              1                1               1        111
248     12652.0      352         44    732.28              1                4               4        144
1373    14270.0      352         22    341.65              1                2               3        123
1314    14185.0      352          1     12.75              1                1               1        111

[3536 rows x 8 columns]
```
</details><br>
<details><summary><strong>4. Use the classification table to group customers into segments.</strong></summary>

```python
#Split the RFM Score column in ecommerce_retail_segment
ecommerce_retail_segment['RFM Score'] = ecommerce_retail_segment['RFM Score'].astype(str).str.split(',')
ecommerce_retail_segment = ecommerce_retail_segment.explode('RFM Score').reset_index(drop=True)
ecommerce_retail_segment['RFM Score'] = ecommerce_retail_segment['RFM Score'].astype(int)

print(ecommerce_retail_segment)

#Merge RFM_remove_outliner and ecommerce_retail_segment to get customer Segment 
Customer_Segment = RFM_remove_outliner.merge(ecommerce_retail_segment, left_on = 'RFM_Score', right_on='RFM Score', how= 'inner')   
Customer_Segment = Customer_Segment.drop(columns='RFM Score')     
Customer_Segment = Customer_Segment.drop_duplicates('CustomerID')
print(Customer_Segment)
```
output
```
Segment  RFM Score
0         Champions        555
1         Champions        554
2         Champions        544
3         Champions        545
4         Champions        454
..              ...        ...
120  Lost customers        112
121  Lost customers        121
122  Lost customers        131
123  Lost customers        141
124  Lost customers        151

[125 rows x 2 columns]
     CustomerID  Recency  Frequency  Monetary  Recency_Score  Frequency_Score  Monetary_Score  RFM_Score                Segment
0       16626.0       21        129   2337.14              5                5               5        555              Champions
1       12518.0       21        114   1750.09              5                5               5        555              Champions
2       12423.0       21        111   1535.61              5                5               5        555              Champions
3       17754.0       21         76    970.88              5                5               5        555              Champions
4       12526.0       21         63   1074.46              5                4               5        545              Champions
...         ...      ...        ...       ...            ...              ...             ...        ...                    ...
3531    15447.0      351          8    129.67              1                1               1        111         Lost customers
3532    15107.0      351          8    104.10              1                1               1        111         Lost customers
3533    12652.0      352         44    732.28              1                4               4        144       Cannot Lose Them
3534    14270.0      352         22    341.65              1                2               3        123  Hibernating customers
3535    14185.0      352          1     12.75              1                1               1        111         Lost customers

[3536 rows x 9 columns]
```
</details><br>
<details><summary><strong>5. Visualize the number of segments across different data dimensions.</strong></summary>
 
```python
#Create Segment_list for sorting 
segment_list = [
'Champions'
,'Loyal'
,'Potential Loyalist'
,'New Customers'
,'Promising'
,'Need Attention'
,'About To Sleep'
,'At Risk'
,'Cannot Lose Them'
,'Hibernating customers'
,'Lost customers'
]

#Caculate min, mean, max of each segment
Customer_Segment_describe = Customer_Segment[['Segment','Recency','Frequency','Monetary']].groupby('Segment') \
                                                                                          .agg(['min', 'mean', 'max']).reset_index()
Customer_Segment_describe['Segment'] = pd.Categorical(Customer_Segment_describe['Segment'], categories=segment_list, ordered=True)
Customer_Segment_describe = Customer_Segment_describe.sort_values('Segment')
pd.set_option('display.max_columns', None) 
pd.set_option('display.width', 1000)
print(Customer_Segment_describe)

#Count customer by segment
Groupby_segment = Customer_Segment.groupby('Segment')['Segment'].count().reset_index(name= 'Segment_count')
Groupby_segment['Segment'] = pd.Categorical(Groupby_segment['Segment'], categories=segment_list,ordered=True)
Groupby_segment = Groupby_segment.sort_values('Segment')
Groupby_segment['Percent_by_segment'] = ((Groupby_segment['Segment_count']/Groupby_segment['Segment_count'].sum())*100).round(2)
print(Groupby_segment)
```
output
```
Segment Recency                  Frequency                 Monetary                       
                              min        mean  max       min       mean  max      min         mean       max
3               Champions      21   36.101724   60        41  93.839655  190   520.93  1324.029793  2473.040
6                   Loyal      23   67.459547   96        23  73.631068  188   308.58  1128.360812  2451.600
9      Potential Loyalist      22   54.027714   96        12  45.496536  183    20.92   341.838591   516.880
8           New Customers      22   51.854037   96         1   8.161491   22     0.00   136.531770   297.600
10              Promising      22   39.571429   96         3  15.008929   22    78.20   385.903661  1357.740
7          Need Attention      21   56.386957   96        13  36.391304   71   299.40   635.515435  2439.260
0          About To Sleep      61  108.080645  198         2  16.870968   64    33.17   157.577992   471.300
1                 At Risk      98  178.658879  351        12  55.497664  183   156.27   753.385187  2358.590
2        Cannot Lose Them     101  250.936508  352         3  64.841270  170   314.10   865.426365  2300.811
4   Hibernating customers      61  174.205212  352         1  16.521173   40     4.25   244.604707   517.660
5          Lost customers     200  273.601246  352         1   8.180685   49     2.90   108.667383   288.620

Segment  Segment_count  Percent_by_segment
3               Champions            580               16.40
6                   Loyal            309                8.74
9      Potential Loyalist            433               12.25
8           New Customers            322                9.11
10              Promising            112                3.17
7          Need Attention            230                6.50
0          About To Sleep            124                3.51
1                 At Risk            428               12.10
2        Cannot Lose Them             63                1.78
4   Hibernating customers            614               17.36
5          Lost customers            321                9.08
```
```python
#Create bar plot
sns.catplot(data=Groupby_segment, y='Segment', x='Segment_count', kind= 'bar',errorbar=None, order = segment_list)
plt.title('Customer Segment bar chart')
plt.show()

#Create Treemap
import squarify
import matplotlib.colors as mcolors

sizes = Groupby_segment['Segment_count']
labels = Groupby_segment['Segment'].astype(str) + ' (' + Groupby_segment['Segment_count'].astype(str) + ')'

cmap = plt.cm.coolwarm
norm = mcolors.Normalize(vmin=min(sizes), vmax=max(sizes)) 
colors = [cmap(norm(value)) for value in sizes]

plt.figure(figsize=(14, 9))
squarify.plot(sizes=sizes, label=labels, alpha=0.5, color=colors)
plt.axis('off')
plt.title('Customer Segment Tree map')
plt.show()
```
output

![image](https://github.com/user-attachments/assets/e6a983d9-2991-41f6-b8ba-97b00a1d9bc3)
![image](https://github.com/user-attachments/assets/8a18eb71-8159-49f1-9e05-6b28195dd715)

</details><br>
<details><summary><strong>6. Analyze the company’s current situation and provide recommendations to the Marketing team.</strong></summary>
<br>
Customer Segments Overview:
 
- Champions: 16.40% of customers
- At Risk: 12.10% of customers
- Hibernating: 17.36% of customers
 
Key Insights:

- Despite having valuable 'Champions' customers, the high customer loss rate suggests a need for focused strategies targeting 'At Risk' customers.
- The significant 'Hibernating' segment indicates a high churn rate, calling for a review of customer care and retention strategies.
- Actionable Campaign Strategies:
- Customer Appreciation: Focus on 'Champions', 'Loyal', and 'Potential Loyalist' customers.
- Customer Acquisition: Prioritize 'New Customers' and 'Promising' segments for potential growth.

Further Recommendations:

- Other customer segments not mentioned should also be approached with tailored campaigns and care strategies to mitigate churn.

 </details><br>
<details><summary><strong>7. Suggest to the Marketing and Sales teams which of the three metrics (R, F, or M) they should focus on the most, given the retail business model of Superstore.</strong></summary>
 <br>
In Superstore's retail model, the metrics to prioritize the most are Recency (R) and Frequency (F), based on the following points:

- Recency (R): The average recency for 'Champions' is 36 days, and for 'Loyal' customers, it is 67 days, indicating they return within 1-2 months. This shows that customers who make purchases more recently are more likely to be engaged and valuable.
  
- Frequency (F): 'Champions' make 93 purchases, and 'Loyal' customers make around 73 purchases within 1-2 months. High frequency of purchases suggests strong engagement and loyalty.

Since customers with low Recency (recently active) and high Frequency (frequent purchases) contribute significantly to the company's value, focusing on these two metrics for segmentation will help identify and retain the most valuable customers.


