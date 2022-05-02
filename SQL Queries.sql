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