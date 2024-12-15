# PBI Project 3: AdventureWorks

## 1. Context
- AdventureWorks database supports standard online transaction processing scenarios for a fictitious bicycle manufacturer - Adventure Works Cycles. 
- Scenarios include Manufacturing, Sales, Purchasing, Product Management, Contact Management, and Human Resources.

## 2. Topic: Manufacturing
- The Production Department is responsible for receiving production requests from the company's Planning Department. After the Purchasing Department places orders and imports raw materials into the warehouse, the production process begins.
- According to the plan, once production is completed, products will be stored in various locations to facilitate storage and distribution to customers. The production completion time may not fully align with the plan. During the process of inspecting warehouse entries, there is a possibility that goods may be damaged, and they will be rejected to ensure that only quality-assured products are stored for sale.
### Requirement
- As a data analyst, create an Operation Dashboard for the Production Director to provide a clear and intuitive visual overview that helps them make better decisions and operate more efficiently.  
- Additionally, you can provide your own recommendations, insights, and suggestions.

## 3. Approach
- I used the Design Thinking template for empathy and analysis, then selected the key metrics and dimensions for visualization. 
- I selected the tables related to Manufacturing department (connect PBI and AdventureWorks database on BigQuery)

<details><summary><strong>Design Thinking</strong></summary>
<br>
  
- Northstart metric: Total Production Cost	
- Dimension 1 - Time: StarDate, EndDate, DueDate
- Dimension 2 - Location: Name
- Dimension 3 - Product: Product Category, Sub Category, Name

![image](https://github.com/user-attachments/assets/3f09c7e8-80c1-419e-b4d9-50fd6e4f94d6)

![image](https://github.com/user-attachments/assets/3255531c-6116-41eb-9227-c16a0d6a2809)

![image](https://github.com/user-attachments/assets/bae932b4-cec8-432c-87ee-7446cd73daa5)

</details> 
<details><summary><strong>Data Processing</strong></summary>
<br>
  
1. Connect to database
2. choose table and cleaning data
3. Build schema(snowflex)

![image](https://github.com/user-attachments/assets/2a594bae-dc11-4459-8f57-41bfbb74da4e)

![image](https://github.com/user-attachments/assets/8d30cd7d-d534-48ed-8966-ad1232d18251)

![image](https://github.com/user-attachments/assets/a589a0cf-3968-4ee3-9029-28c2f76674aa)


</details> 

## 4. Visualize Dashboard
After completing the Design Thinking process, I will proceed with visualization. I will create 2 dashboards and 1 recommendations page, which will include: 

- Overview (General Performance overview)
- Production Overview
- Recommendation

 Overview (General Performance overview

 ![image](https://github.com/user-attachments/assets/b64a0ff3-6778-4459-a9de-a70b96f153d7)

 Production Overview

 ![image](https://github.com/user-attachments/assets/7ec218e0-70e6-45fa-940a-f06d66a2ac95)

 Recommendation

 ![image](https://github.com/user-attachments/assets/fa9a7fbc-5df5-48dd-a5fb-a5884f1f815f)



