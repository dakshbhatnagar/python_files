# Second Highest salary
SELECT 
    *
FROM
    (SELECT 
        e.emp_no, 
        e.first_name, 
        e.last_name, 
        s.salary, 
        e.gender,
	Case e.emp_no
		when lead(s.emp_no) over (order by e.emp_no) then 'No' else 'Yes'
	end as j
    FROM
        salaries s
    JOIN employees e ON s.emp_no = e.emp_no
    Group by s.salary
    ORDER BY s.salary DESC) x
where x.j = 'Yes'
Limit 1,1;


# Highest Salaries from Different Departments
SELECT 
    x.dept_no, x.emp_no, MAX(salary) AS Salary
FROM
    (SELECT 
        de.emp_no, de.dept_no, s.salary
    FROM
        dept_emp de
    JOIN salaries s ON de.emp_no = s.emp_no
    ORDER BY s.salary) x
GROUP BY x.dept_no;


#Counting Repeated and New Users
select 
	login_date, Count(newuser) as NewUserCount, Count(repeateduser) as OldUserCount
from 
	(select *,
	CASE WHEN user_name <> LEAD(user_name) over (order by login_id)
		THEN user_name 
		End as newuser,
	case 
		when user_name = LEAD(user_name,2) over (order by login_id)
		then user_name 
		end as repeateduser
	from login_details) x
group by login_date;



select login_id, 
		user_name, 
		login_date, 
(Case 
    when Lag(user_name, 1,'2022-01-02') OVER(ORDER BY user_name ASC) <> user_name and 
    Lag(user_name, 1,'2022-01-02') OVER(ORDER BY user_name ASC) 
		Not in 
(SELECT 
    login_id
FROM
    login_details
WHERE login_Id IN ('101' , '102', '103')) then login_date
    else 'Not a New User'
    end) as FirstLoginDate,
(Case 
    when Lag(user_name, 1,'New') OVER(ORDER BY user_name ASC) <> user_name and 
    Lag(user_name, 1,'New') OVER (ORDER BY user_name ASC) 
		Not in
    (SELECT 
    login_id
FROM
    login_details
WHERE
    login_Id IN ('101' , '102', '103')) then user_name
    else 'Old'
    end) as UserType
from 
	login_details
order by login_id;

# Finding out top 3 salaries from each dept 
SELECT 
	* 
FROM
  (SELECT de.dept_no, 
		de.emp_no, 
        s.salary, 
        DENSE_RANK() OVER (PARTITION BY de.dept_no ORDER BY s.salary DESC) as ranking
	FROM
    dept_emp de
        JOIN
    salaries s ON de.emp_no = s.emp_no
	ORDER BY s.salary DESC) a 
WHERE a.ranking < 4
ORDER BY a.dept_no;

# Finding out odd rows 
select 
	* 
from 
	(SELECT 
		*, rank() over (order by emp_no) as rnk
	FROM
		employees) x 
	where mod(x.rnk,2) != 0;	

# Finding out even rows
select 
	* 
from 
	(SELECT 
		*, rank() over (order by emp_no) as rnk
	FROM
		employees) x 
	where mod(x.rnk,2) = 0;


# Creating a table from another table

CREATE TABLE table1 AS SELECT * FROM
    employees;


# Selecting Distinct records without using distinct
SELECT manager_no
FROM 
    emp_manager
group by manager_no;

# Counting how many managers are managing how many employees
SELECT 
    manager_no, COUNT(emp_no) AS DirectReportee
FROM
    emp_manager
GROUP BY manager_no;


# Finding Max Salary in an organization
SELECT 
    de.emp_no AS EmpID,
    de.dept_no AS DeptNum,
    s.salary AS Salary,
    s.from_date AS HiringDate
FROM
    dept_emp de
        JOIN
    salaries s ON de.emp_no = s.emp_no
WHERE
    salary = (SELECT 
            MAX(salary)
        FROM
            salaries); 
            

# Deleting records of a table
DELETE FROM employees 
WHERE
    emp_no IN (SELECT 
        emp_no
    FROM
        salaries
    
    WHERE
        emp_no = '10001');


# Finding Out which employees are earning more than the avge salary

WITH cte as (SELECT 
    *
FROM
    salaries)
SELECT 
    *
FROM
    cte
WHERE
    salary > (SELECT 
            TRUNCATE(AVG(salary), 2) AS AvgeSalary
        FROM
            salaries);

# fINDING THE MEDIAN SALARY OF AN ORGANIZATION
select truncate(avg(salary),2) as Median
from 
	(select emp_no,
	 	salary,
	 	from_date,
	 	to_date,
	 	ROW_NUMBER() OVER(ORDER BY salary asc) RowNumber 
	 from 
	 salaries) x 
where x.RowNumber = '483656' or x.RowNumber = '483657';

# Finding names that doesn't start or end with a vowel
SELECT DISTINCT
    first_name
FROM
    employees
WHERE
    first_name NOT REGEXP '^[aeiou]'
        AND first_name NOT REGEXP '[aeiou]$'
ORDER BY first_name;

# Display manger names and salary grades
SELECT 
	concat(first_name,' ',last_name) as emp_name, 
CASE em.manager_no
    WHEN 110022 THEN (select concat(first_name,' ',last_name) from employees where emp_no in (110022))
    ELSE (select concat(first_name,' ',last_name) from employees where emp_no in (110039))
END as manager_name, 
	s.salary
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;

# Display manager names and salary grades where salary>3000
SELECT 
	concat(first_name,' ',last_name) as emp_name, 
CASE em.manager_no
    WHEN 110022 THEN (select concat(first_name,' ',last_name) from employees where emp_no in (110022))
    ELSE (select concat(first_name,' ',last_name) from employees where emp_no in (110039))
END as manager_name, 
	s.salary
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
        JOIN
    salaries s ON e.emp_no = s.emp_no
where s.salary > 3000
GROUP BY e.emp_no;

# Display employee names and department name where salary>2000
SELECT 
    CONCAT(first_name, ' ', last_name) AS emp_name, d.dept_name
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    s.salary > 2000
GROUP BY e.emp_no;
# Display employee names and their salary grades
SELECT 
    CONCAT(first_name, ' ', last_name) AS emp_name, s.salary
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;

# Display employee names and their manager names
SELECT 
    CONCAT(first_name, ' ', last_name) AS emp_name,
    CASE em.manager_no
        WHEN
            110022
        THEN
            (SELECT 
                    CONCAT(first_name, ' ', last_name)
                FROM
                    employees
                WHERE
                    emp_no IN (110022))
        ELSE (SELECT 
                CONCAT(first_name, ' ', last_name)
            FROM
                employees
            WHERE
                emp_no IN (110039))
    END AS manager_name
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
GROUP BY e.emp_no;

# Display employee names and their manager names & their hire dates where employee joined company before his manager
select * from (SELECT 
	concat(first_name,' ',last_name) as emp_name, 
CASE em.manager_no
    WHEN 110022 THEN (select concat(first_name,' ',last_name) from employees where emp_no in (110022))
    ELSE (select concat(first_name,' ',last_name) from employees where emp_no in (110039))
END as manager_name, 
CASE em.manager_no
	WHEN '110022' then (select hire_date from employees where emp_no ='110022')
    WHEN '110039' then (select hire_date from employees where emp_no ='110039')
END as manager_hire_date,
	e.hire_date
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
GROUP BY e.emp_no) x
where x.hire_date < x.manager_hire_date;

# Display all the department names with the total salary paid by each dept
SELECT 
    d.dept_name, s.salary
FROM
    dept_emp de
        JOIN
    salaries s ON de.emp_no = s.emp_no
		join
	departments d on de.dept_no = d.dept_no
group by de.dept_no
order by s.salary desc;

#  Display managers who are having 3 or more subordinates
SELECT 
    em.manager_no
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
HAVING SUM(e.emp_no) >= 3;

# Display job and the total salary paid for each category
SELECT 
    t.title, s.salary
FROM
    salaries s
		join
	titles t on s.emp_no = t.emp_no
group by t.title
order by s.salary desc;

# Display names of managers with total no of employees working under them
SELECT 
    concat(first_name,' ', last_name) AS Manager_Name,
    COUNT(DISTINCT (em.emp_no)) AS employeecount
FROM
    emp_manager em
        JOIN
    employees e ON e.emp_no = em.emp_no
GROUP BY em.manager_no;

#  Display managers who are having 3 or more subordinates
SELECT 
    em.manager_no
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
HAVING SUM(e.emp_no) >= 3;

# Display departments which are paying more than 10000 salary per month
SELECT 
    de.dept_no, d.dept_name
FROM
    dept_emp de
        JOIN
    salaries s ON de.emp_no = s.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
Group by de.dept_no
HAVING SUM(s.salary) > 10000;

# Display the departments where the max number of employees are working
SELECT 
    *
FROM
    (SELECT 
        COUNT(emp_no) AS emp_count, dept_no
    FROM
        dept_emp
    GROUP BY dept_no
    ORDER BY COUNT(emp_no) DESC) x
HAVING MAX(x.emp_count);

# Display manager names and their emp no and total salary paid for employees under them
SELECT 
    CASE em.manager_no
        WHEN
            110022
        THEN
            (SELECT 
                    CONCAT(first_name, ' ', last_name)
                FROM
                    employees
                WHERE
                    emp_no IN (110022))
        ELSE (SELECT 
                CONCAT(first_name, ' ', last_name)
            FROM
                employees
            WHERE
                emp_no IN (110039))
    END AS manager_name,
    em.manager_no AS manager_emp_ID,
    SUM(s.salary) AS Total_Emp_Salary
FROM
    emp_manager em
        JOIN
    employees e ON em.emp_no = e.emp_no
        JOIN
    salaries s ON em.emp_no = s.emp_no
WHERE
    em.manager_no IN (SELECT 
            manager_no
        FROM
            emp_manager)
GROUP BY em.manager_no;

# Display each dept name with no of employees working for 
SELECT 
    dept_name, COUNT(de.emp_no) AS TotalEmp
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
GROUP BY d.dept_no;

# Display each job category and no of employees working for it
SELECT 
    t.title, COUNT(t.emp_no) AS TotalEmp
FROM
    titles t
        JOIN
    employees e ON t.emp_no = e.emp_no
GROUP BY t.title;

# Display managers who manage the least no of employees
SELECT 
    manager_no, COUNT(emp_no) AS EmpCount
FROM
    emp_manager
GROUP BY manager_no;

# Display dept where least no of employees work
SELECT 
    d.dept_name, COUNT(de.emp_no) as EmpCount
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
GROUP BY d.dept_name
order by count(de.emp_no) desc 
Limit 1;

# # Display employees who are employees as well as managers
SELECT 
    e.emp_no, e.first_name, e.last_name, e.gender, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager'
group by e.emp_no;

# Display employees who are not managers
SELECT 
    e.emp_no, e.first_name, e.last_name, e.gender, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title <> 'Manager'
group by e.emp_no;

# Display those department details where there are no employees
SELECT 
    d.dept_no, d.dept_name
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
HAVING COUNT(de.emp_no) = 0;

# Find departments that have employees
SELECT 
    d.dept_no, d.dept_name, count(de.emp_no) as EmpCount
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
Group by d.dept_no
HAVING COUNT(de.emp_no) != 0
Order by EmpCount Desc;

# Find number of records from all the tables
SELECT SUM(TABLE_ROWS) as Records
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_SCHEMA = 'employees';
   
# Display employees from sales dept
SELECT 
    emp_no, first_name, last_name, gender, dept_name
FROM
    employees e
        JOIN
    departments d
WHERE
    dept_no = (SELECT 
            dept_no
        FROM
            departments
        WHERE
            dept_name = 'Sales');

# Display employees with Sales or accounting dept
SELECT 
    emp_no, first_name, last_name, gender, dept_name
FROM
    employees e
        JOIN
    departments d
WHERE
    dept_no = (SELECT 
            dept_no
        FROM
            departments
        WHERE
            dept_name = 'Sales' or 'Accounting');

# Display employees whose name starts with ‘J’ and department end with ‘S’
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE 'J%S'
GROUP BY emp_no;

# Display those employees whose manager joined in 1981
SELECT 
    *
FROM
    employees
WHERE
    hire_date between '1981-01-01 12:00:00' and '1981-12-31 23:59:00' order by hire_date desc;
    
# Display those employees whose joining year is same as their manager’s ie 1981
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    e.hire_date,
    em.manager_no,
    t.title,
    t.from_date
FROM
    employees e
        JOIN
    emp_manager em ON e.emp_no = em.emp_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    e.hire_date = t.from_date;
    

# Display those employees whose manager’s dept is sales
SELECT 
    *
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
where dm.dept_no in (select dept_no from dept_manager where dept_no='d007');

