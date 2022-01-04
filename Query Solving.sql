USE db;

# 2nd Highest salary
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