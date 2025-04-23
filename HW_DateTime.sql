show databases;

use HadoopClass1;

CREATE TABLE employee_attendance (
emp_id INT,
emp_name VARCHAR(50),
login_time DATETIME,
logout_time DATETIME
);

INSERT INTO employee_attendance VALUES
(1, 'Al', '2025-04-01 08:30:00', '2025-04-01 17:30:00'),
(2, 'B', '2025-04-02 09:00:00', '2025-04-02 18:15:00'),
(3, 'C', '2025-03-31 10:15:00', '2025-03-31 19:00:00'),
(4, 'D', '2025-04-03 07:45:00', '2025-04-03 16:30:00'),
(5, 'E', '2025-04-05 09:10:00', '2025-04-05 17:00:00'),
(6, 'F', '2025-04-06 10:00:00', '2025-04-06 18:00:00'),
(7, 'G', '2025-04-07 08:50:00', '2025-04-07 17:50:00'),
(8, 'H', '2025-04-08 08:45:00', '2025-04-08 17:45:00'),
(9, 'I', '2025-03-25 09:30:00', '2025-03-25 18:00:00'),
(10, 'J', '2025-03-28 08:15:00', '2025-03-28 17:10:00'),
(11, 'K', '2025-04-01 07:50:00', '2025-04-01 15:00:00'),
(12, 'L', '2025-04-02 10:30:00', '2025-04-02 19:30:00');

/* 
1.Retrieve current date, time, and timestamp using NOW(), CURDATE(), and
CURRENT_TIMESTAMP().
2. Show the formatted login date in dd-mm-yyyy format.
3. Display the last day of the month for each login_time.
4. Convert '15-04-2025' (string) to a DATE object and display it
5. Show login_time + 50 days for each employee.
6. Show login_time - 50 days for each employee.
7. Extract the year, month, and day from login_time.
8. Extract the quarter, week number, and weekday of login_time.
9. Extract hour, minute, and second from login_time.

 */

SELECT * 
FROM employee_attendance;

-- 1.Retrieve current date, time, and timestamp using NOW(), CURDATE(), and CURRENT_TIMESTAMP().

SELECT NOW(); -- Returns 2025-04-11 11:34:22

SELECT CURDATE(); -- 2025-04-11

SELECT CURRENT_TIMESTAMP(); -- Returns String Value as '2025-04-11 11:35:20'

-- 2. Show the formatted login date in dd-mm-yyyy.

SELECT emp_id,
        emp_name,
        login_time, 
        DATE_FORMAT(login_time,'%d-%m-%Y') 
	FROM  employee_attendance;

-- 3. Display the last day of the month for each login_time.

select emp_id,
        emp_name,
        login_time, 
        Last_day(login_time) 
	FROM  employee_attendance;

-- 4. Convert '15-04-2025' (string) to a DATE object and display it

select emp_id,
        emp_name,
        login_time, str_to_date('15-04-2025','%d-%m-%Y') 
FROM  employee_attendance;

SELECT STR_TO_DATE('10-12-2023', '%d-%m-%Y'); -- for example

-- 5. Show login_time + 50 days for each employee.
SELECT 
		emp_id,
        emp_name,
        login_time, 
        DATE_ADD(login_time,interval 50 day) as add_fifty_days
FROM employee_attendance;

-- 6. Show login_time - 50 days for each employee.

SELECT
	emp_id,
    emp_name,
    login_time,
    DATE_SUB(login_time, interval 50 day) as sub_fiffty_days
FROM employee_attendance;

-- 7. Extract the year, month, and day from login_time.
SELECT
	emp_id,
    emp_name,
    login_time,
	YEAR(login_time) AS Year,
    Month(login_time) AS Month,
    Day(login_time) AS Day,
    HOUR(login_time) AS Hour,
    MINUTE(login_time) AS Minute,
    SECOND(login_time) AS Second
FROM employee_attendance;

-- 8. Extract the quarter, week number, and weekday of login_time.
SELECT
	emp_id,
    emp_name,
    login_time,
	QUARTER(login_time) AS Quarter,       
    WEEK(login_time) AS WeekNumber,       
    DAYNAME(login_time) AS Weekday       
FROM employee_attendance;


-- 9. Extract hour, minute, and second from login_time.

SELECT
	emp_id,
    emp_name,
    login_time,
    HOUR(login_time) AS Hour,
    MINUTE(login_time) AS Minute,
    SECOND(login_time) AS Second
FROM employee_attendance;

-- 10. Display the month name and day name of login_time.

SELECT
	emp_id,
    emp_name,
    login_time,
   DAYNAME(login_time) AS DayName,
    MONTHNAME(login_time) AS MonthName
FROM employee_attendance;

/*
🔸 Date Difference Calculations
11. Calculate the number of days between login and logout for each employee.
12. Find the number of hours worked per employee.
13. Find minutes worked and seconds worked per employee using TIMESTAMPDIFF.
14. Show employees who worked less than 8 hours.
15. Show employees who worked more than 9 hours.

🔸 Filters by Date Ranges
16. Get records where employees logged in within last 7 days.
17. Fetch records where login date is between '2025-04-01' and '2025-04-07'.
18. Display records where employees logged in on a Monday.
19. List records where login occurred on a Saturday or Sunday (weekend).
20. Display all records where login date is in the current month. */



-- 11. Calculate the number of days between login and logout for each employee.

SELECT 
	emp_id,
    emp_name,
    login_time,
    logout_time,
    DATEDIFF(login_time,logout_time) as date_diff,
	TIMEDIFF(logout_time,login_time) as total_hrs
FROM employee_attendance;

-- 12. Find the number of hours worked per employee.
SELECT 
	emp_id,
    emp_name,
    login_time,
    logout_time,
	TIMEDIFF(logout_time,login_time) as total_hrs_Worked
FROM employee_attendance;

-- 13. Find minutes worked and seconds worked per employee using TIMESTAMPDIFF.

SELECT 
	emp_id,
    emp_name,
    login_time,
    logout_time,
    TIMESTAMPDIFF(Hour,login_time,logout_time) as total_Hrs_Worked,
	TIMESTAMPDIFF(Minute,login_time,logout_time) as total_minutes_Worked,
	TIMESTAMPDIFF(Second,login_time,logout_time) as total_Seconds_Worked
FROM employee_attendance;


-- 14. Show employees who worked less than 8 hours.
-- TIMEDIFF(Starttime,End TIME) has 2 Parameter Return as Timestamp
-- TIMESTAMPDIFF(HOURS,Starttime,End TIME) has 3 Parameter  Return as Int

SELECT 
	emp_id,
    emp_name,
    login_time,
    logout_time,
	TIMESTAMPDIFF(Hour,logout_time,login_time) as total_hrs_Worked
FROM employee_attendance
WHERE TIMESTAMPDIFF(Hour,login_time,logout_time) < 8;

-- 15. Show employees who worked more than 9 hours.


SELECT 
	emp_id,
    emp_name,
    login_time,
    logout_time,
	TIMESTAMPDIFF(Hour,logout_time,login_time) as total_hrs_Worked
FROM employee_attendance
WHERE TIMESTAMPDIFF(Hour,login_time,logout_time) > 9;


-- 16. Get records where employees logged in within last 7 days.


SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
    DATE_SUB(NOW(), INTERVAL 7 DAY), -- sub 7 days from today
    DATE_ADD(NOW(), INTERVAL 7 DAY) -- add 7 days from today
FROM employee_attendance
where login_time >= NOW() - INTERVAL 7 DAY;
-- both working for the Where filter.
SELECT
	NOW() - INTERVAL 7 DAY as a,
    DATE_SUB(NOW(), INTERVAL 7 DAY) as b
FROM employee_attendance;

-- 17. Fetch records where login date is between '2025-04-01' and '2025-04-07'.
SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
	DATE(login_time)as DATE_d
FROM employee_attendance
WHERE DATE(login_time) BETWEEN '2025-04-01' AND '2025-04-07'
ORDER BY DATE_d;

-- 18. Display records where employees logged in on a Monday.
SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
	DAYNAME(login_time)as Day_NAME
FROM employee_attendance
WHERE DAYNAME(login_time) = 'Monday';


-- 19. List records where login occurred on a Saturday or Sunday (weekend).
SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
	DAYNAME(login_time)as Day_NAME
FROM employee_attendance
WHERE WEEKDAY(login_time) in (5,6);


-- 20. Display all records where login date is in the current month. */

SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
    CURDATE(),
	DATE(login_time)as Day_NAME
FROM employee_attendance
WHERE MONTH(login_time) = MONTH(CURDATE())
		AND YEAR(login_time) = YEAR(CURDATE());
        
SELECT
	DATE(login_time)
  FROM employee_attendance  
  
  
  -- 
  /*
  🔸 Weekday & Working Day Logic
21. Find all employees who logged in on a weekend.
22. Show employee names who logged in on a weekday (Mon–Fri).
23. Display records where WEEKDAY(login_time) = 0 (Monday).
24. Get records for employees who logged in during the first week of April 2025.
25. Show all records where login time is in March 2025.
🔸 Derived Fields & Comparisons
26. Create a derived column showing total hours worked labeled as worked_hours
27. Show a new column is_weekend with values 'Yes' or 'No' based on login_time.
28. Add a new column work_duration_category as 'Short' if < 8 hours, 'Full' otherwise.
29. Find employees who logged out after 6 PM.
30. List employees who logged in before 8 AM.

🔸 Aggregation & Grouping
31. Count how many employees logged in per day.
32. Count how many employees logged in on weekends vs weekdays.
33. Group by DAYNAME(login_time) and count logins.
34. Group by MONTH(login_time) and find average hours worked.
35. Find max and min login time per day.

🔸 Edge Scenarios & Bonus Logic
36. Show employees who logged in and logged out on different calendar days.
37. List employees whose login and logout occurred during the same hour.
38. Show employees who worked exactly 9 hours.
39. List employees whose login was in the first 5 days of any month.
40. Display employee names sorted by longest working duration in descending order.
*/


-- 21. Find all employees who logged in on a weekend.
SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
    DAYNAME(login_time)
FROM employee_attendance
WHERE WEEKDAY(login_time) in (5,6);


-- 22. Show employee names who logged in on a weekday (Mon–Fri).

SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
    DAYNAME(login_time)
FROM employee_attendance
WHERE WEEKDAY(login_time) in (0,4);

-- 23. Display records where WEEKDAY(login_time) = 0 (Monday).


SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
    DAYNAME(login_time)
FROM employee_attendance
WHERE WEEKDAY(login_time) = 0;

-- 24. Get records for employees who logged in during the first week of April 2025.
SELECT
	emp_id,
    emp_name,
    login_time,
    logout_time,
    DAYNAME(login_time)
FROM employee_attendance
WHERE WEEKDAY(login_time) = 0;

-- 25. Show all records where login time is in March 2025.

SELECT 
    emp_id,
    emp_name,
    login_time
FROM employee_attendance
WHERE login_time BETWEEN '2025-04-01' AND '2025-04-07';

-- 26. Create a derived column showing total hours worked labeled as worked_hours

SELECT 
    emp_id,
    emp_name,
    login_time,
    TIMESTAMPDIFF(HOUR,login_time,logout_time) as worked_hours
FROM employee_attendance

-- 27. Show a new column is_weekend with values 'Yes' or 'No' based on login_time.

SELECT 
    emp_id,
    emp_name,
    login_time
    CASE 
        WHEN WEEKDAY(login_time) IN (5, 6) THEN 'Yes'
        ELSE 'No'
    END AS is_weekend
FROM employee_attendance

SELECT 
    emp_id,
    emp_name,
    login_time,
    IF(WEEKDAY(login_time) IN (5, 6), 'Yes', 'No') AS is_weekend
FROM employee_attendance;

-- 28. Add a new column work_duration_category as 'Short' if < 8 hours, 'Full' otherwise.
SELECT 
    emp_id,
    emp_name,
    login_time,
    TIMESTAMPDIFF(HOUR,login_time,logout_time) as Toal_hrs,
    IF(TIMESTAMPDIFF(HOUR,login_time,logout_time) < 8, 'Short', 'FULL') AS work_duration_category
FROM employee_attendance;

-- 29. Find employees who logged out after 6 PM.
SELECT 
    emp_id,
    emp_name,
    login_time,
    TIMESTAMPDIFF(HOUR,login_time,logout_time) as Toal_hrs,
    IF(TIMESTAMPDIFF(HOUR,login_time,logout_time) < 8, 'Short', 'FULL') AS work_duration_category
FROM employee_attendance;
-- 30. List employees who logged in before 8 AM.
SELECT 
    emp_id,
    emp_name,
    logout_time,
    HOUR(logout_time)
FROM employee_attendance
WHERE HOUR(logout_time) > 18;


-- 31. Count how many employees logged in per day.
	
SELECT 
    DATE(login_time) as Login_date,
    Count(login_time) as No_emp
FROM employee_attendance
GROUP BY DATE(login_time);
	
-- 32. Count how many employees logged in on weekends vs weekdays.
SELECT
    CASE
        WHEN WEEKDAY(login_time) IN (5, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    COUNT(emp_id) AS LoginCount
FROM employee_attendance
GROUP BY DayType;

SELECT 
     CASE
        WHEN WEEKDAY(login_time) IN (5, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType
FROM employee_attendance
GROUP BY DayType;


-- 33. Group by DAYNAME(login_time) and count logins.
use HadoopClass1;
SELECT * FROM employee_attendance;

SELECT 
		DAYNAME(login_time) as Day_Name,
        Count(login_time) as No_of_Logins
FROM employee_attendance
GROUP BY Day_Name;


-- 34. Group by MONTH(login_time) and find average hours worked.
SELECT 
		MONTH(login_time) as Month_no,
        Count(login_time) as No_of_Logins
FROM employee_attendance
GROUP BY Month_no;

-- 35. Find max and min login time per day.
SELECT 
		DAY(login_time) as Day_no,
		MAX(login_time) as MAX_Log,
        MIN(login_time) as Min_log
FROM employee_attendance
GROUP BY Day_no;

