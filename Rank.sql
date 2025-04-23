use HadoopClass1;

CREATE TABLE employees (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
salary INT,
department VARCHAR(50),
hire_date DATE
);

INSERT INTO employees (name, salary, department, hire_date) VALUES
('Karthik', 60000, 'HR', '2020-01-15'),
('Ajay', 50000, 'Finance', '2021-03-10'),
('Vijay', 55000, 'IT', '2022-06-18'),
('Mohan', 70000, 'IT', '2019-11-02'),
('Pratik', 75000, 'Finance', '2018-08-25'),
('Karthik', 80000, 'HR', '2017-02-17'),
('Meera', 40000, 'HR', '2022-09-05'),
('Veena', 45000, 'Finance', '2023-03-01');

INSERT INTO employees (name, salary, department, hire_date) VALUES
('Karthik', 60000, 'HR', '2020-01-15');
SELECT * FROM employees;

/*1. Previous and Next Employee Salary in HR
For each employee in the HR department, find their salary along with the salary of the
employee hired immediately before and after them, ordered by hire date. Use LEAD and
LAG, and apply GROUP BY to get results for each department.
2. Salary Rank Comparison in IT Department
For each employee in the IT department, find their salary rank and the salary rank of the
next employee in the department. If two employees have the same salary, they should
receive the same rank. Use LEAD, LAG, and CASE WHEN to calculate the rank.
3. Salary Growth or Decline for Employees
For each employee, determine if their salary is greater than, equal to, or less than the salary
of the previous employee based on their hire date. Use LAG and WHEN conditions to
categorize salary growth or decline.
4. Total Salary in Each Department with Salary Difference
Calculate the total salary for each department and also compare each employee's salary with
the salary of the previous employee within the same department. Use LEAD, LAG, and
GROUP BY to compute the totals and differences.
5. Salary Difference Between Consecutive Employees in Finance
For each employee in the Finance department, calculate the difference between their salary
and the salary of the next employee hired. Use LEAD, LAG, and GROUP BY to get results for
each department.
6. Identifying Salary Increases or Decreases in IT
For each employee in the IT department, identify whether their salary has increased or
decreased compared to the previous employee. If their salary increased, mark it as
"Increase", if it decreased, mark it as "Decrease", and if it remained the same, mark it as "No
Change". Use LAG, WHEN, and GROUP BY.
7. Categorize Employees Based on Salary Growth
Categorize employees as "High Growth", "Low Growth", or "No Growth" based on the
comparison of their salary with the previous employee's salary in the HR department. Use
LEAD, LAG, CASE WHEN, and GROUP BY to classify employees.
8. Department-wise Salary Ranking
Rank employees in each department based on their salary and determine if the rank has
changed compared to the previous employee in the same department. Use LEAD, LAG, and
GROUP BY to rank employees within their department and detect any rank changes.
9. Identifying Top Salary and the Next Highest Salary
For each department, find the employee with the highest salary and the employee with the
next highest salary. Use LEAD, LAG, and GROUP BY to find the top salary and next highest
salary for each department.
10. Calculate Salary Trend for Employees in Finance
For each employee in the Finance department, determine if their salary trend has been
increasing or decreasing compared to the previous employee in terms of hire date. Use LAG,
WHEN, and GROUP BY to categorize the trend */



-- ANSWERS
   --  1. Previous and Next Employee Salaries in HR Find each HR employee's salary, 
   -- along with the salary of the employee hired right before and right after them, 
   -- sorted by hire date. Use LEAD and LAG functions.
   
   SELECT * FROM employees;
   
   SELECT 
		id,
        name,
        department,
        hire_date,
        salary,
        LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) as Previous_Emp_Salary,
		LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) as Next_Emp_Salary
FROM employees;
        
   /*
   2. Salary Rank Comparison in IT 
   Find the salary rank of each IT employee and 
   the rank of the next employee based on salary within the IT department. 
   If salaries are equal, employees will share the same rank. 
   Use LEAD, LAG, and CASE WHEN to compute ranks.
   */
   
   
 WITH Salary_Rank_IT AS
(
    SELECT 
        id,
        name,
        department,
        hire_date,
        salary,
        RANK() OVER(PARTITION BY department ORDER BY salary DESC ) as Salary_Rank_IT
    FROM employees
)

SELECT * 
 FROM 
(SELECT 
		id,
        name,
        department,
        hire_date,
        salary,
         Salary_Rank_IT,
        LEAD(Salary_Rank_IT,1) OVER( ORDER BY Salary_Rank_IT DESC ) as Next_Salary_Rank_IT,
        -- COALESCE(LEAD(Salary_Rank_IT,1) OVER( ORDER BY Salary_Rank_IT DESC ), 'N/A'),
        CASE
			WHEN Salary_Rank_IT = 1 THEN 'Top RANK'
            WHEN Salary_Rank_IT > 1 THEN 'Low RANK'
            ELSE 'UNKNOWN'
		END as Compute_Rank
FROM Salary_Rank_IT)t 
WHERE department = 'IT';


-- 
/* 3. Salary Growth or Decline for Employees
For each employee, 
determine if their salary is greater than, equal to, or less than the salary
of the previous employee based on their hire date. 
Use LAG and WHEN conditions to
categorize salary growth or decline. */

WITH SalaryComparisons AS (
    SELECT 
        department,
        name,
        salary,
        LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) AS previous_emp_salary,
        LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) AS next_emp_salary,
        CASE 
            WHEN salary > LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'Growth'
            WHEN salary = LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'Equal'
            WHEN salary < LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'Decline'
            ELSE 'N/A'
        END AS salary_comparison
    FROM 
        employees
)
SELECT 
    department,
    SUM(salary) AS total_salary,
    MAX(salary) - MIN(salary) AS salary_difference,
    name,
    salary,
    previous_emp_salary,
    next_emp_salary,
    salary_comparison
FROM 
    SalaryComparisons
GROUP BY 
    department, name, salary, previous_emp_salary, next_emp_salary, salary_comparison
ORDER BY 
    department;

-- 
/* 4. Total Salary in Each Department with Salary Difference
Calculate the total salary for each department and also compare each employee's salary with
the salary of the previous employee within the same department. Use LEAD, LAG, and
GROUP BY to compute the totals and differences. */


SELECT * FROM employees;


WITH Salary_Comparison AS
(
	SELECT
			id,
            name,
            department,
            salary,
            SUM(salary) OVER(PARTITION BY department) as Total_Salary,
			MAX(salary) OVER(PARTITION BY department) as MAX_Salary,
            MIN(salary) OVER(PARTITION BY department) as MIN_Salary,
            LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) as Previous_Emp_Salary,
            LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) as Next_Emp_Salary,
            CASE	
				WHEN salary > LAG(salary) OVER(PARTITION BY department ORDER BY hire_date)  THEN 'Growing'
                WHEN salary = LAG(salary) OVER(PARTITION BY department ORDER BY hire_date)  THEN 'Equal'
                WHEN salary < LAG(salary) OVER(PARTITION BY department ORDER BY hire_date)  THEN 'Decline'
                ELSE 'Salary_Data_Missing'
			END as Salary_Rating
	FROM employees
    )
    
    SELECT
		department,
        salary,
        Total_Salary,
        ( MAX_Salary - MIN_Salary ) as Sala_Diff,
        Previous_Emp_Salary,
        Next_Emp_Salary
	FROM Salary_Comparison
    Group BY 
		department,
        Total_Salary,
        salary,
        Previous_Emp_Salary,
        Next_Emp_Salary
	ORDER BY 
		department;
        
        -- 
        
        /* 
        
     5.   Salary Difference Between Consecutive Employees in Finance
For each employee in the Finance department,
 calculate the difference between their salary
and the salary of the next employee hired. 
Use LEAD, LAG, and GROUP BY to get results for
each department.
        
        */
        
        SELECT 
				id,
                name,
                department,
                salary,
                LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) as Previous_Emp_Salary,
                (LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) - salary) as Salary_Difference_Previous,
                LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) as Next_Emp_Salary,
                (LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) - salary) as Salary_Difference_Next
        FROM employees
        WHERE department = 'Finance';
        
/*
Identifying Salary Increases or Decreases in IT:
For each employee in the IT department, 
identify whether their salary has increased or
decreased compared to the previous employee. 
If their salary increased, mark it as
"Increase", if it decreased, mark it as "Decrease", and if it remained the same, mark it as "No
Change". Use LAG, WHEN, and GROUP BY. */

        SELECT 
				id,
                name,
                department,
                salary,
                LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) as Previous_Salary,
                CASE
					WHEN salary > LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'Increase'
                    WHEN salary = LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'Equal'
					WHEN salary < LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'Decrease'
				END as salary_catagory
		FROM employees
        WHERE department = 'IT';
        
    --     
       /*
       7. Categorize Employees Based on Salary Growth
Categorize employees as "High Growth", "Low Growth", or "No Growth" based on the
comparison of their salary with the previous employee's salary in the HR department. Use
LEAD, LAG, CASE WHEN, and GROUP BY to classify employees.
8. Department-wise Salary Ranking
*/ 
	
    
    WITH SalaryComparison AS (
    SELECT 
        name,
        salary,
        hire_date,
        LAG(salary) OVER(ORDER BY hire_date) AS previous_salary,
        LEAD(salary) OVER(ORDER BY hire_date) AS next_salary,
        CASE
            WHEN salary > LAG(salary) OVER(ORDER BY hire_date) THEN 'High Growth'
            WHEN salary = LAG(salary) OVER(ORDER BY hire_date) THEN 'No Growth'
            WHEN salary < LAG(salary) OVER(ORDER BY hire_date) THEN 'Low Growth'
            ELSE 'N/A'
        END AS growth_category
    FROM 
        employees
    WHERE 
        department = 'HR'
)
SELECT 
    name,
    salary,
    hire_date,
    previous_salary,
    next_salary,
    growth_category
FROM 
    SalaryComparison
ORDER BY 
    hire_date;

--
/*
8. Department-wise Salary Ranking
Rank employees in each department based on their salary and 
determine if the rank has changed compared to the previous employee in the same department. 
Use LEAD, LAG, and GROUP BY to rank employees within their department and detect any rank changes.
*/

WITH Rank_Emp_Salary AS
(
    SELECT 
				id,
                name,
                department,
                salary,
                 RANK() OVER(PARTITION BY department ORDER BY salary DESC ) as RANK_Emp_Salary
  FROM employees              
                
)
          SELECT
				id,
                name,
                department,
                salary,
                RANK_Emp_Salary,
                LAG(RANK_Emp_Salary) OVER(PARTITION BY department ORDER BY salary DESC ) as Previous_Emp
			FROM Rank_Emp_Salary ;
                
                
   /*
   Identifying Top Salary and the Next Highest Salary
For each department, find the employee with the highest salary and -- Done
 the employee with the next highest salary.  -- 
 Use LEAD, LAG, and GROUP BY to find the top salary and next highest
salary for each department.
   
   */             
                
	WITH high_salary_Rank AS
    (
    SELECT 
				id,
                name,
                department,
                salary,
               RANK() OVER(PARTITION BY department ORDER BY salary DESC ) as Highest_Salary_Rank ,
         LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_highest_salary
  FROM employees              
               )
               
		SELECT 
				id,
                name,
                department,
                salary,
               Highest_Salary_Rank ,
               next_highest_salary
		FROM high_salary_Rank
        WHERE 
    Highest_Salary_Rank IN (1, 2);
    
    
    /* 
    Calculate Salary Trend for Employees in Finance
For each employee in the Finance department, determine if their salary trend has been
increasing or decreasing compared to the previous employee in terms of hire date. Use LAG,
WHEN, and GROUP BY to categorize the trend
*/


WITH FinanceSalaryTrend AS (
    SELECT 
        name,
        salary,
        hire_date,
        LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) AS previous_salary,
        CASE
            WHEN salary > LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) THEN 'Increasing'
            WHEN salary < LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) THEN 'Decreasing'
            WHEN salary = LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) THEN 'Stable'
            ELSE 'No Trend' -- For the first employee
        END AS salary_trend
    FROM 
        employees
    WHERE 
        department = 'Finance'
)
SELECT 
    name,
    salary,
    hire_date,
    previous_salary,
    salary_trend
FROM 
    FinanceSalaryTrend
ORDER BY 
    hire_date;

