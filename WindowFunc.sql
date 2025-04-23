use HadoopClass1;
CREATE TABLE employee_salary (
emp_id INT,
emp_name VARCHAR(50),
department VARCHAR(50),
salary DECIMAL(10, 2),
join_date DATE
);


INSERT INTO employee_salary (emp_id, emp_name, department, salary, join_date) VALUES
(1, "Karthik", "Finance", 80000.00, "2023-01-15"),
(2, "Prathik", "Finance", 75000.00, "2022-07-20"),
(3, "Vinay", "IT", 90000.00, "2023-03-10"),
(4, "Veer", "IT", 85000.00, "2022-12-01"),
(5, "Veena", "HR", 70000.00, "2023-05-18"),
(6, "Mohan", "HR", 72000.00, "2022-11-30"),
(7, "Meera", "Finance", 80000.00, "2023-06-05"),
(8, "Prany", "IT", 88000.00, "2023-04-12"),
(9, "Keerthana", "HR", 75000.00, "2023-02-25");

-- HomeWork Question. 1 -- 
select * from employee_salary;
-- Rank employees within each department based on their salary in descending order.
SELECT *,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) as Salary_RANK
FROM employee_salary;

-- Question 2 :   Generate a dense rank for the same.

SELECT *,
DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) as Salary_RANK
FROM employee_salary;

-- Question 3 :   Assign a row number to each employee within their department.

SELECT *,
ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY department) as Emp_RowNo
FROM employee_salary;

-- Question 4 :  Find the salary difference between the current and previous employee in the department using LAG:

SELECT emp_id,emp_name,department,
salary as Current_Salary,
(lAG(salary,1) over(ORDER BY emp_id) - salary) as Salary_Difference
FROM employee_salary;

-- Question 5:   Predict the next salary for each employee within the department using LEAD.

SELECT emp_id,emp_name,department,
salary as Current_Salary,
(lEAD(salary,1) over(PARTITION BY department ORDER BY emp_id) - salary) as Next_salary
FROM employee_salary;


-- -
CREATE TABLE student_scores (
student_id INT,
student_name VARCHAR(50),
subject VARCHAR(50),
score INT,
exam_date DATE
);
INSERT INTO student_scores (student_id, student_name, subject, score, exam_date) VALUES
(1, "Karthik", "Math", 85, "2023-08-12"),
(2, "Prathik", "Math", 92, "2023-08-12"),
(3, "Vinay", "Science", 78, "2023-08-15"),
(4, "Veer", "Science", 89, "2023-08-15"),
(5, "Veena", "English", 95, "2023-08-10"),
(6, "Mohan", "English", 88, "2023-08-10"),
(7, "Meera", "Math", 91, "2023-08-12"),
(8, "Prany", "Science", 90, "2023-08-15"),
(9, "Keerthana", "English", 85, "2023-08-10");

-- Home Work Questions: ---

Select * from student_scores;

-- 1. Rank students by their score in each subject.

SELECT * ,
RANK() OVER(PARTITION BY subject ORDER BY Score DESC) as Student_RANK
FROM student_scores;

-- 2. Assign a dense rank to handle ties.

SELECT * ,
DENSE_RANK() OVER(PARTITION BY subject ORDER BY Score DESC) as Student_Dense_RANK
FROM student_scores;

-- 3. Generate a row number based on exam date within each subject.
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY subject ORDER BY exam_date) as Student_ROWnumber
FROM student_scores;

-- 4. Find the difference between the current and previous score in each subject using LAG.

SELECT *,
score as Current_score,
(LAG(score,1) OVER()) as Previous_score,
score - LAG(score,1) OVER(PARTITION BY subject ORDER BY score)  as Score_difference
FROM student_scores;

-- 5. Predict the next score for each student within the same subject using LEAD.
SELECT *,
score as Current_score,
(LEAD(score,1) OVER(PARTITION BY subject ORDER BY score)) as Next_score
FROM student_scores;

-- 3. Sales Representative Performance
-- 

CREATE TABLE sales_performance (
rep_id INT,
rep_name VARCHAR(50),
region VARCHAR(50),
sales_amount DECIMAL(10, 2),
sales_date DATE
);


INSERT INTO sales_performance (rep_id, rep_name, region, sales_amount, sales_date) VALUES
(1, "Karthik", "North", 15000.00, "2024-01-01"),
(2, "Prathik", "North", 18000.00, "2024-01-05"),
(3, "Vinay", "South", 20000.00, "2024-01-03"),
(4, "Veer", "South", 22000.00, "2024-01-07"),
(5, "Veena", "East", 17000.00, "2024-01-02"),
(6, "Mohan", "East", 16000.00, "2024-01-04"),
(7, "Meera", "North", 17500.00, "2024-01-06"),
(8, "Prany", "South", 21000.00, "2024-01-08"),
(9, "Keerthana", "East", 16500.00, "2024-01-09");

SELECT *
FROM sales_performance;

-- 1. Rank sales representatives by sales amount in each region.
SELECT *,
RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) as Sales_Rank
FROM sales_performance;

-- 2. Use DENSE_RANK to handle ties.

SELECT *,
DENSE_RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) as Sales_DENSE_Rank
FROM sales_performance;

-- 3. Generate a row number ordered by sales date within each region.

SELECT *,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales_date) as Sales_RowNumber
FROM sales_performance;

-- 4. Find the difference between the current and previous sales amount for each representative using LAG.
SELECT *,
sales_amount as Current_Sales_Amt,
LAG(sales_amount,1) OVER() as previous_sale,
(sales_amount - LAG(sales_amount,1) OVER() ) as SaleAmt_Diff
FROM sales_performance;

-- 5. Predict the next sales amount using LEAD for each representative.

SELECT *,
sales_amount as Current_Sales_Amt,
LEAD(sales_amount,1) OVER() as next_sale
FROM sales_performance;


-- 4. Product Price Change Analysis
-- 
CREATE TABLE product_prices (
product_id INT,
product_name VARCHAR(50),
price DECIMAL(10, 2),
update_date DATE
);

INSERT INTO product_prices (product_id, product_name, price, update_date) VALUES
(1, "Laptop", 800.00, "2023-11-01"),
(2, "Mobile", 600.00, "2023-11-03"),
(3, "Tablet", 400.00, "2023-11-02"),
(4, "Headphones", 150.00, "2023-11-05"),
(5, "Camera", 1000.00, "2023-11-04"),
(6, "Speaker", 200.00, "2023-11-06"),
(7, "Smartwatch", 300.00, "2023-11-07"),
(8, "Keyboard", 50.00, "2023-11-08"),
(9, "Mouse", 30.00, "2023-11-09");

SELECT * 
FROM product_prices;

-- 1. Rank products by their price, highest first.

SELECT * ,
RANK() OVER(ORDER BY price DESC) as Price_Rank
FROM product_prices;

-- 2. Generate a dense rank to manage ties.
SELECT * ,
DENSE_RANK() OVER(ORDER BY price DESC) as Price_DENSERank
FROM product_prices;

-- 3. Assign a row number based on update date.

SELECT * ,
ROW_NUMBER() OVER(ORDER BY update_date) as Row_date
FROM product_prices;


-- 4. Use LAG to calculate the difference between current and previous prices.

SELECT *,
price as Current_Price,
LAG(price,1) OVER() as Previous_Price,
( LAG(price,1) OVER()- price) as Price_Diff
FROM product_prices;

-- 5. Use LEAD to predict the next price.

SELECT *,
price as Current_Price,
LEAD(price,1) OVER() as NEXT_Price
FROM product_prices;


-- 5. Employee Promotion Analysis

-- 
CREATE TABLE employee_promotion (
emp_id INT,
emp_name VARCHAR(50),
department VARCHAR(50),
promotion_date DATE,
new_designation VARCHAR(50)
);

INSERT INTO employee_promotion (emp_id, emp_name, department, promotion_date,
new_designation) VALUES
(1, "Karthik", "Finance", "2024-01-15", "Manager"),
(2, "Prathik", "Finance", "2023-12-01", "Senior Analyst"),
(3, "Vinay", "IT", "2024-02-20", "Tech Lead"),
(4, "Veer", "IT", "2023-11-10", "Senior Developer"),
(5, "Veena", "HR", "2024-03-05", "HR Lead"),
(6, "Mohan", "HR", "2023-10-25", "HR Manager"),
(7, "Meera", "Finance", "2024-01-10", "Lead Analyst"),
(8, "Prany", "IT", "2024-02-05", "System Architect"),
(9, "Keerthana", "HR", "2024-03-15", "Senior HR");

SELECT *
FROM employee_promotion;

-- 1. Rank employees based on their latest promotion date in each department.
SELECT *,
RANK() OVER(PARTITION BY department ORDER BY promotion_date DESC )  as Rank_Promotion
FROM employee_promotion;

-- 2. Generate a dense rank to handle cases with the same promotion date.

SELECT *,
DENSE_RANK() OVER(PARTITION BY department ORDER BY promotion_date DESC )  as DenseRank_Promotion
FROM employee_promotion;

-- 3. Assign a row number to each employee ordered by promotion date.

SELECT *,
ROW_NUMBER() OVER( ORDER BY promotion_date DESC )  as RowNum_Promotion
FROM employee_promotion;

-- 4. Find the time gap between the current and previous promotion within the department using LAG.

SELECT *,
	promotion_date as current_promo,
	LAG(promotion_date,1) OVER() as previous_promo,
	DATEDIFF(promotion_date, LAG(promotion_date,1) OVER()) as time_gap_promotion
FROM employee_promotion;


-- 5. Use LEAD to check the next promotion date for employees in each department.
SELECT *,
	promotion_date as current_promo,
	LEAD(promotion_date,1) OVER(PARTITION BY department ORDER BY promotion_date DESC ) as Next_promo
FROM employee_promotion;

-- 6. Sales Revenue Analysis

CREATE TABLE sales_revenue (
sale_id INT,
salesman_name VARCHAR(50),
region VARCHAR(50),
revenue DECIMAL(10, 2),
sale_date DATE
);



INSERT INTO sales_revenue (sale_id, salesman_name, region, revenue, sale_date) VALUES
(1, "Karthik", "West", 12000.50, "2024-04-01"),
(2, "Prathik", "East", 14000.75, "2024-03-20"),
(3, "Vinay", "North", 13000.30, "2024-04-05"),
(4, "Veer", "West", 11000.00, "2024-03-28"),
(5, "Veena", "East", 16000.50, "2024-04-03"),
(6, "Mohan", "North", 12500.00, "2024-03-22"),
(7, "Meera", "West", 15000.00, "2024-04-06"),
(8, "Prany", "East", 15500.25, "2024-04-07"),
(9, "Keerthana", "North", 13500.75, "2024-04-02");

SELECT * 
FROM sales_revenue;

-- 1. Rank sales representatives within each region by revenue.

SELECT * ,
RANK() OVER(PARTITION BY region ORDER BY revenue DESC) as Sales_Rank
FROM sales_revenue;

-- 2. Generate a dense rank to manage ties.

SELECT * ,
DENSE_RANK() OVER(PARTITION BY region ORDER BY revenue DESC) as Sales_DENSERank
FROM sales_revenue;


-- 3. Assign a row number based on sale date within each region.

SELECT * ,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY sale_date DESC) as Sales_ROWNumber
FROM sales_revenue;

-- 4. Calculate the difference between current and previous revenue within the region using LAG.
SELECT * ,
revenue as CurrentRevenue,
LAG(revenue,1) OVER(PARTITION BY region) as Pre_Sales,
revenue - LAG(revenue,1) OVER(PARTITION BY region) as Sales_Diff
FROM sales_revenue;

-- 5. Predict the next revenue for each representative using LEAD.

SELECT * ,
LEAD(revenue,1) OVER(ORDER BY sale_id) as Sales_ROWNumber
FROM sales_revenue;

-- 7. Product Sales Comparison

CREATE TABLE product_sales (
product_id INT,
product_name VARCHAR(50),
sales_qty INT,
sales_month VARCHAR(20)
);


INSERT INTO product_sales (product_id, product_name, sales_qty, sales_month) VALUES
(1, "Laptop", 300, "January"),
(2, "Mobile", 500, "January"),
(3, "Tablet", 200, "February"),
(4, "Headphones", 400, "February"),
(5, "Camera", 350, "March"),
(6, "Speaker", 250, "March"),
(7, "Smartwatch", 150, "April"),
(8, "Keyboard", 100, "April"),
(9, "Mouse", 80, "April");

SELECT *
FROM product_sales;

-- 1. Rank products by sales quantity within each month.
SELECT *,
RANK() OVER(PARTITION BY sales_month ORDER BY sales_qty DESC) as Product_RANK
FROM product_sales;

-- 2. Generate a dense rank to handle identical sales quantities.
SELECT *,
DENSE_RANK() OVER(PARTITION BY sales_month ORDER BY sales_qty DESC) as Product_DENSERANK
FROM product_sales;


-- 3. Assign a row number to each product based on sales quantity.
SELECT *,
ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY sales_qty DESC) as Product_ROWNUm
FROM product_sales;


-- 4. Use LAG to find the difference between current and previous month sales for each product.
SELECT *,
	sales_month as Current_Month,
	LAG(sales_month,1) OVER() as Previous_month,
	sales_month - LAG(sales_month,1) OVER() as Sale_Diff
FROM product_sales;

-- 5. Use LEAD to predict the next month's sales for each product.

SELECT *,
	sales_month as Current_Month,
	LEAD(sales_month,1) OVER() as Next_month
FROM product_sales;



-- 8. Customer Transaction History

CREATE TABLE customer_transactions (
cust_id INT,
cust_name VARCHAR(50),
transaction_amount DECIMAL(10, 2),
transaction_date DATE
);



INSERT INTO customer_transactions (cust_id, cust_name, transaction_amount, transaction_date)
VALUES
(1, "Karthik", 500.00, "2024-05-01"),
(2, "Prathik", 300.00, "2024-05-03"),
(3, "Vinay", 800.00, "2024-05-04"),
(4, "Veer", 450.00, "2024-05-02"),
(5, "Veena", 600.00, "2024-05-05"),
(6, "Mohan", 700.00, "2024-05-06"),
(7, "Meera", 650.00, "2024-05-07"),
(8, "Prany", 550.00, "2024-05-08"),
(9, "Keerthana", 750.00, "2024-05-09");

SELECT *
FROM customer_transactions;



-- 1. Rank customers based on the transaction amount.
SELECT *,
RANK() OVER(ORDER BY transaction_amount DESC) As RANk_Cus
FROM customer_transactions;


-- 2. Use DENSE_RANK to handle ties.

SELECT *,
DENSE_RANK() OVER(ORDER BY transaction_amount DESC) as DENRank_Cus
FROM customer_transactions;

-- 3. Generate a row number ordered by transaction date.
SELECT *,
ROW_NUMBER() OVER(ORDER BY transaction_date DESC) as RowNum_Cus
FROM customer_transactions;


-- 4. Find the difference between current and previous transaction amounts using LAG.

SELECT *,
	transaction_amount as Current_Amt,
	LAG(transaction_amount,1) OVER(ORDER BY transaction_date DESC) as Previous_Amt,
	( LAG(transaction_amount,1) OVER() - transaction_amount ) as Amt_Diff
FROM customer_transactions;

-- 5. Use LEAD to predict the next transaction amount.

SELECT *,
	transaction_amount as Current_Amt,
	LEAD(transaction_amount,1) OVER(ORDER BY transaction_date DESC) as Previous_Amt
FROM customer_transactions;

-- 9. Project Completion Status

CREATE TABLE project_status (
project_id INT,
project_name VARCHAR(50),
status VARCHAR(20),
completion_percentage DECIMAL(5, 2),
update_date DATE
);


INSERT INTO project_status (project_id, project_name, status, completion_percentage,
update_date) VALUES
(1, "Data Pipeline", "Ongoing", 40.00, "2024-06-01"),
(2, "Web App", "Completed", 100.00, "2024-05-28"),
(3, "Analytics Dashboard", "Ongoing", 60.00, "2024-06-05"),
(4, "Migration Tool", "Ongoing", 75.00, "2024-06-02"),
(5, "ETL Process", "Completed", 100.00, "2024-05-30"),
(6, "Mobile App", "Ongoing", 50.00, "2024-06-03"),
(7, "Reporting Tool", "Ongoing", 30.00, "2024-06-06");


SELECT *
FROM project_status;






