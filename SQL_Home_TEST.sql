SELECT * 
From employee_attendance;

-- Show total present, absent, and leave counts for each employee using conditional aggregation.

SELECT emp_id,
		emp_name,
        department,
        attendance_date,
        status,
        working_hours,
        salary
FROM employee_attendance;


-- Total Dept

SELECT 
	department,
	COUNT(attendance_date) as Countatdate
From employee_attendance
GROUP BY department;
--
SELECT 
	emp_id,status,
	COUNT(status) as CountodStatus
From employee_attendance
GROUP BY emp_id,status;


-- 
SELECT 
	emp_id,emp_name,status,
	COUNT(status) as CountodStatus
From employee_attendance
WHERE status = 'Present' 
GROUP BY emp_id,emp_name,status;


-- 
SELECT 
	emp_id,
    emp_name,
    SUM(CASE 
			WHEN (status = 'Present') THEN  1
            ELSE 0
            END) as Emp_present,
	SUM(CASE
			WHEN status = 'Absent' THEN 1
            ELSE 0
            END) as Emp_Absent,
	SUM(CASE 
			WHEN (STATUS = 'Leave' ) THEN 1
            ELSE 0
            END) as Emp_Leave
FROM employee_attendance
GROUP BY emp_id, emp_name;


-- For each employee, calculate total working hours and classify them as ‘Excellent’,
-- ‘Average’, or ‘Poor’ based on a CASE condition.

SELECT
	emp_id,emp_name,
    SUM(working_hours) as total_woring_hours,
    AVG(working_hours) as Avg_working_hours,
    CASE
		WHEN SUM(working_hours)> AVG(working_hours) THEN 'Excellent'
        WHEN SUM(working_hours) = AVG(working_hours) THEN 'Average'
        ELSE 'Poor'
        END as Attendance_Rating
FROM employee_attendance
GROUP BY emp_id,emp_name;

-- Display total present days and assign a rank to each employee within their department
-- based on this count.
-- Display total present days
WITH PresentDays AS (
    SELECT 
        emp_id,
        emp_name,
        department,
        COUNT(CASE WHEN status = 'Present' THEN 1 ELSE NULL END) AS total_present_days
    FROM 
        employee_attendance
    GROUP BY 
        emp_id, emp_name, department
)
SELECT 
    emp_id,
    emp_name,
    department,
    total_present_days,
    RANK() OVER (PARTITION BY department ORDER BY total_present_days DESC) AS rank_in_department
FROM 
    PresentDays
ORDER BY 
    department, rank_in_department;
    
    -- 
    
SELECT 
    emp_id,
    emp_name,
    department,
	COUNT(CASE WHEN status = 'Present' THEN 1 ELSE NULL END) AS total_present_days,
	RANK() OVER (PARTITION BY department ORDER BY COUNT(CASE WHEN status = 'Present' THEN 1 ELSE NULL END)  ) AS rank_in_department
FROM 
    employee_attendance
GROUP BY emp_id,
    emp_name,
    department
ORDER BY 
    department,rank_in_department;
-- Find the top 2 employees (per department) who worked the most hours, ranked by
-- total hours.

SELECT 
    emp_id,
    emp_name,
    department,
    SUM(working_hours) as Total_Working_hrs,
    RANK() OVER(PARTITION BY department ORDER BY SUM(working_hours) DESC) as Hrs_Rank
FROM employee_attendance
GROUP BY emp_id,emp_name,department;

-- Generate a report that shows, for each employee, their latest attendance date and total
-- days worked in January.

WITH latest_Att as
(SELECT 
    emp_id,
    emp_name,
    MAX(attendance_date) as Latest_Attendance,
    SUM(CASE
			WHEN status = 'Present' AND Month(attendance_date) = 1 THEN 1
            ELSE 0
		END) as January_Working_days
FROM employee_attendance
GROUP BY emp_id, emp_name)

-- Classify employees into categories based on number of absent days: CASE WHEN > 1
-- THEN ‘Irregular’, etc.


SELECT
	emp_id,
    emp_name,
    SUM(CASE 
				WHEN status = 'Absent' THEN 1
				ELSE 0
                END) as No_of_Absent,
    CASE 
		WHEN SUM(CASE 
				WHEN status = 'Absent' THEN 1
				ELSE 0
                END) > 0 
		THEN 'Irregular'
		ELSE 'Regular'
        END as Catagory
FROM employee_attendance
GROUP BY emp_id, emp_name;
    
-- For each employee and each week, count how many days they were present, using
-- WEEK() and GROUP BY.


SELECT
	emp_id,
    emp_name,
    WEEK(attendance_date),
    SUM(CASE 
			WHEN status = 'Present' THEN 1
            ELSE 0
		END) as No_of_Present
FROM employee_attendance
GROUP BY emp_id,
    emp_name,WEEK(attendance_date);
    
  -- Display the attendance on the first day of every month for each employee along with the working hours.
SELECT 
    emp_id, 
    emp_name, 
    department, 
    attendance_date, 
    working_hours, 
    status
FROM employee_attendance
WHERE Day(attendance_date) = 1
ORDER BY emp_id, attendance_date;
    

 -- Doubt 9. List employees who had same working hours on consecutive days, using date
-- manipulation and ROW_NUMBER.

SELECT
		emp_id,
        emp_name,
        Date(attendance_date) as date_name
        -- ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY Date(attendance_date)) as No_of_days
FROM employee_attendance
GROUP BY emp_id, emp_name;

SELECT
        emp_id,
        emp_name,
        attendance_date,
        working_hours,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY attendance_date) AS row_num
    FROM
        employee_attendance 
        
-- Identify employees who were present on maximum number of Mondays in January.
    
SELECT emp_id, emp_name,
		COUNT(*) as No_of_present
FROM employee_attendance
WHERE status = 'Present' AND MONTH(attendance_date) = 1 AND DAYNAME(attendance_date) = 'MONDAY'
GROUP BY emp_id, emp_name
ORDER BY No_of_present Desc;

-- For every department, show the employee who worked the highest number of hours
-- on the earliest date available in the dataset.


-- Show how many times each employee was absent and rank them based on this count
-- in descending order.

use HadoopClass1;

SELECT
	emp_id,
    emp_name,
   SUM(CASE 
				WHEN status = 'Absent' THEN 1
				ELSE NULL
                END) as no_absent,
    RANK() OVER(PARTITION BY emp_id,emp_name ORDER BY  SUM(CASE 
				WHEN status = 'Absent' THEN 1
				ELSE NULL
                END) DESC ) 
FROM employee_attendance
GROUP BY emp_id,emp_name;


SELECT 
    emp_id,
    emp_name,
    COUNT(*) AS absence_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) 
FROM employee_attendance
WHERE status = 'Absent'
GROUP BY emp_id, emp_name
ORDER BY absence_count DESC;


-- Create a column using CASE that shows "Worked" if status is Present and hours > 7, else “Low Effort”.

SELECT 
		emp_id,emp_name,
        department, working_hours,
        CASE 
			WHEN status = 'Present' AND working_hours > 7 THEN 'Worked'
            ELSE 'Low EFFORT'
		END as Perfomance_Grade
FROM employee_attendance;


-- Find the difference in days between the first and last attendance record for each employee.

SELECT 
		emp_id,emp_name,
        MAX(attendance_date) as latest_Date,
        MIN(attendance_date) as Old_date,
        DATEDIFF(MAX(attendance_date), MIN(attendance_date)) as diff
FROM employee_attendance
GROUP BY emp_id,emp_name;

-- 15 doubt  For each employee, show daily attendance along with their attendance streak rank (incremented for each new streak).
	

-- Display employee details who were present for at least 3 consecutive days (use ROW_NUMBER and date difference).
use SQLTest;

-- Find the earliest attendance date for each department and the employee who marked present on that day.
WITH EarliestAttendance AS (
    SELECT 
		department, 
        MIN(attendance_date) AS first_attendance_date
    FROM employee_attendance
    WHERE status = 'Present'
    GROUP BY department
)

SELECT 
	ea.department, 
    ea.first_attendance_date, 
    e.emp_id, 
    e.emp_name
FROM EarliestAttendance ea
JOIN employee_attendance e
ON ea.department = e.department AND ea.first_attendance_date = e.attendance_date
WHERE e.status = 'Present';

-- 
with Earliest_Attendance AS
(
	SELECT 
		department,
        MIN(attendance_date) as first_attendance_date
	FROM employee_attendance
    where status = 'Present'
    GROUP BY department

)

SELECT
	ea.emp_id,
    ea.emp_name,
    ea.status,
	eaa.department,
    eaa.first_attendance_date
	
  FROM employee_attendance ea
INNER JOIN Earliest_Attendance eaa
    ON ea.department = eaa.department AND ea.attendance_date = eaa.first_attendance_date
    WHERE status = 'Present';


--  Create a report that ranks employees based on average working hours per day within department using DENSE_RANK.


SELECT
	emp_id,
	department,
    avg(working_hours) as working_hours_per_day,
    RANK() OVER(PARTITION BY department ORDER BY avg(working_hours) ) as Avg_Rank
    
FROM employee_attendance
Group by emp_id,department;


-- 
WITH AvgWorkingHours AS (
    SELECT 
        emp_id, 
        emp_name, 
        department, 
        AVG(working_hours) AS avg_working_hours
    FROM employee_attendance
    GROUP BY emp_id, emp_name, department
)

SELECT 
    department,
    emp_id,
    emp_name,
    avg_working_hours,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY avg_working_hours DESC) AS rank_within_department
FROM AvgWorkingHours;


-- 
WITH AVG_WORKING_HOURS AS
(
 SELECT
		emp_id,
        emp_name,
        department,
        AVG(working_hours) as Avg_work_Hrs
	FROM employee_attendance
    GROUP BY emp_id, emp_name,department
)


SELECT 
		emp_id,
        emp_name,
        department,
        Avg_work_Hrs,
        DENSE_RANK() OVER(PARTITION BY department ORDER BY Avg_work_Hrs) as Avg_DenseRank
	FROM AVG_WORKING_HOURS;
    
    -- Generate department-wise monthly average working hours and classify departments as “High Load”, “Normal”, or “Low Load”.
    
    WITH AVG_WORKING_HOURS AS
(
 SELECT
        department,
        MONTH(attendance_date) AS month,
        AVG(working_hours) as Avg_work_Hrs
	FROM employee_attendance
    GROUP BY department, MONTH(attendance_date)
)

    SELECT 
        department,
        month,
        Avg_work_Hrs,
        CASE 
			WHEN Avg_work_Hrs >= 8 THEN 'High Load'
            WHEN Avg_work_Hrs BETWEEN 5 AND 7 THEN 'Normal'
            ELSE 'Low Load'
		END as Avg_catagory
	FROM AVG_WORKING_HOURS;
    -- 
    WITH DepartmentMonthlyAvg AS (
    SELECT 
        department,
        MONTH(attendance_date) AS month,
        YEAR(attendance_date) AS year,
        AVG(working_hours) AS avg_working_hours
    FROM employee_attendance
    GROUP BY department, YEAR(attendance_date), MONTH(attendance_date)
)
SELECT 
    department,
    month,
    year,
    avg_working_hours,
    CASE 
        WHEN avg_working_hours >= 8 THEN 'High Load'
        WHEN avg_working_hours BETWEEN 5 AND 7 THEN 'Normal'
        ELSE 'Low Load'
    END AS workload_category
FROM DepartmentMonthlyAvg
ORDER BY year, month, department;

-- For each employee, show total working hours for the current month and the difference compared to the previous month.

SELECT
	emp_id,
    emp_name,
    SUM(working_hours),
    MONTH(CURDATE()) as current_month
FROM employee_attendance
Group BY emp_id,
    emp_name,MONTH(CURDATE()) ;
    
-- 

WITH MonthlyHours AS (
    SELECT 
        emp_id,
        emp_name,
        YEAR(attendance_date) AS year,
        MONTH(attendance_date) AS month,
        SUM(working_hours) AS total_working_hours
    FROM employee_attendance
    GROUP BY emp_id, emp_name, YEAR(attendance_date), MONTH(attendance_date)
),
CurrentAndPrevious AS (
    SELECT 
        mh1.emp_id,
        mh1.emp_name,
        mh1.total_working_hours AS current_month_hours,
        mh2.total_working_hours AS previous_month_hours,
        (mh1.total_working_hours - COALESCE(mh2.total_working_hours, 0)) AS difference
    FROM MonthlyHours mh1
    LEFT JOIN MonthlyHours mh2 
    ON mh1.emp_id = mh2.emp_id
    AND mh1.year = mh2.year
    AND mh1.month = mh2.month + 1
    WHERE mh1.year = YEAR(CURDATE()) AND mh1.month = MONTH(CURDATE())
)
SELECT 
    emp_id,
    emp_name,
    current_month_hours,
    previous_month_hours,
    difference
FROM CurrentAndPrevious
ORDER BY difference DESC;
-- 
SELECT MONTH(curdate()) -- to get the current Month
SELECT MONTHNAME(curdate()) -- to get the Current Month Name
    