
# Walmart Sales Data Analysis - Project Answer

## 1. **Database and Table Creation**

### Step 1: Create the Database

First, create a database named `walmartSales` to store the sales data.

**SQL Query:**
```sql
CREATE DATABASE IF NOT EXISTS walmartSales;
```

### Step 2: Use the Database

Switch to the newly created `walmartSales` database.

**SQL Query:**
```sql
USE walmartSales;
```

### Step 3: Create the `sales` Table

Create the `sales` table to store Walmart sales data with the following structure:

**SQL Query:**
```sql
CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
```

### Step 4: Insert Data into the `sales` Table

Insert the sales data into the `sales` table. You can do this by either running `INSERT INTO`
  statements or using a bulk import from a WalmartSalesData.csv.CSV file.
-- note : I have attach this file on my repository please chechk --
---

## 2. **Analysis List**

### **1. Product Analysis**
Conduct analysis on the data to understand the different product lines, identifying which product
  lines perform best and which need improvement.

- **Number of Unique Product Lines:**
  
  **SQL Query:**
  ```sql
  SELECT COUNT(DISTINCT product_line) AS unique_product_lines FROM sales;
  ```

- **Best Performing Product Line by Revenue:**
  
  **SQL Query:**
  ```sql
  SELECT product_line, SUM(total) AS total_revenue
  FROM sales
  GROUP BY product_line
  ORDER BY total_revenue DESC
  LIMIT 1;
  ```

- **Product Lines that Need Improvement (Below Average Sales):**
  
  **SQL Query:**
  ```sql
  SELECT product_line, SUM(total) AS total_sales,
  CASE 
      WHEN SUM(total) > (SELECT AVG(total) FROM sales) THEN 'Good'
      ELSE 'Bad'
  END AS performance
  FROM sales
  GROUP BY product_line;
  ```

### **2. Sales Analysis**
Analyze sales trends to measure the effectiveness of sales strategies and determine necessary modifications
  to increase sales.

- **Total Revenue by Month:**
  
  **SQL Query:**
  ```sql
  SELECT MONTHNAME(date) AS month, SUM(total) AS total_revenue
  FROM sales
  GROUP BY month
  ORDER BY total_revenue DESC;
  ```

- **Month with Largest COGS (Cost of Goods Sold):**
  
  **SQL Query:**
  ```sql
  SELECT MONTHNAME(date) AS month, SUM(cogs) AS total_cogs
  FROM sales
  GROUP BY month
  ORDER BY total_cogs DESC
  LIMIT 1;
  ```

- **City with Largest Revenue:**
  
  **SQL Query:**
  ```sql
  SELECT city, SUM(total) AS total_revenue
  FROM sales
  GROUP BY city
  ORDER BY total_revenue DESC
  LIMIT 1;
  ```

### **3. Customer Analysis**
Uncover customer segments, purchase trends, and the profitability of each customer segment.

- **Number of Unique Customer Types:**
  
  **SQL Query:**
  ```sql
  SELECT COUNT(DISTINCT customer_type) AS unique_customer_types FROM sales;
  ```

- **Most Common Customer Type:**
  
  **SQL Query:**
  ```sql
  SELECT customer_type, COUNT(*) AS customer_count
  FROM sales
  GROUP BY customer_type
  ORDER BY customer_count DESC
  LIMIT 1;
  ```

- **Customer Type that Buys the Most:**
  
  **SQL Query:**
  ```sql
  SELECT customer_type, SUM(total) AS total_spent
  FROM sales
  GROUP BY customer_type
  ORDER BY total_spent DESC
  LIMIT 1;
  ```

- **Gender Distribution per Branch:**
  
  **SQL Query:**
  ```sql
  SELECT branch, gender, COUNT(*) AS gender_count
  FROM sales
  GROUP BY branch, gender;
  ```

---

## 3. **Approach Used**

### **1. Data Wrangling**
- **Database Creation:** Created the `walmartSales` database.
- **Table Creation:** Created the `sales` table with a comprehensive structure to store sales data.
- **Null Value Handling:** As the table fields are set with `NOT NULL`, no null values are present.

### **2. Feature Engineering**
- Added a new column `time_of_day` to identify sales patterns during Morning, Afternoon, and Evening.
  
  **SQL Query:**
  ```sql
  ALTER TABLE sales
  ADD COLUMN time_of_day VARCHAR(10) GENERATED ALWAYS AS (
    CASE 
        WHEN HOUR(time) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
  ) STORED;
  ```

- Added a new column `day_name` to track the day of the week for each transaction.
  
  **SQL Query:**
  ```sql
  ALTER TABLE sales
  ADD COLUMN day_name VARCHAR(10) GENERATED ALWAYS AS (
    DAYNAME(date)
  ) STORED;
  ```

- Added a new column `month_name` to track the month for each transaction.
  
  **SQL Query:**
  ```sql
  ALTER TABLE sales
  ADD COLUMN month_name VARCHAR(10) GENERATED ALWAYS AS (
    MONTHNAME(date)
  ) STORED;
  ```

### **3. Exploratory Data Analysis (EDA)**
Conducted EDA to answer the business questions related to product performance, sales trends, and customer behavior.

---

## 4. **Revenue and Profit Calculations**

- **COGS Calculation:**
  
  **Formula:** `COGS = unit_price * quantity`

- **VAT Calculation:**
  
  **Formula:** `VAT = 5% * COGS`

- **Total (Gross Sales) Calculation:**
  
  **Formula:** `total = VAT + COGS`

- **Gross Profit (Gross Income) Calculation:**
  
  **Formula:** `gross_income = total - COGS`

- **Gross Margin Percentage:**
  
  **Formula:** `gross_margin_pct = (gross_income / total) * 100`

