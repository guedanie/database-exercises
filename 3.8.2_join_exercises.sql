#USE the join_example db tables
USE join_example_db;

SELECT * FROM roles;

SELECT * FROM users;

#All both tables
SELECT * 
FROM roles
JOIN users ON roles.id = users.id;

#Integrate the count function
SELECT roles.name, count(*)
FROM roles
JOIN users ON roles.id = users.id
GROUP BY roles.name;

##Employee DATABASE 
USE employees;

SELECT * FROM dept_manager;

SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM titles;

#Find the current heads of all departments
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Department Manager'
FROM departments
JOIN dept_manager ON departments.dept_no = dept_manager.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no
WHERE to_date > now()
ORDER BY dept_manager.emp_no;

SELECT * FROM dept_emp;

#Find the current female heads of all deparments
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Department Manager'
FROM departments
JOIN dept_manager ON departments.dept_no = dept_manager.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no
WHERE to_date > now() AND gender = 'F'
ORDER BY departments.dept_name; 

#Find the current titles of employees currently working in the customer services department
SELECT titles.title AS Title, count(*) AS Count
FROM titles
JOIN employees ON titles.emp_no = employees.emp_no
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Customer Service' AND dept_emp.to_date = '9999-01-01' AND titles.to_date = '9999-01-01'
GROUP BY titles.title
;

SELECT * FROM salaries;

#Find current salary of current manaager
SELECT departments.dept_name AS 'Department NAME', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Department Manager', salaries.salary
FROM departments
JOIN dept_manager ON departments.dept_no = dept_manager.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.to_date LIKE '9999-01-01' AND dept_manager.to_date = '9999-01-01'
ORDER BY departments.dept_name;

#Find the number of employees in each department
SELECT departments.dept_no, departments.dept_name, count(employees.emp_no)
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_emp.to_date = "9999-01-01"
GROUP BY departments.dept_name
ORDER BY dept_no;

#Which department has the highest average salary?
SELECT departments.dept_name, AVG(salaries.salary) AS average_salary
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN salaries ON employees.emp_no = salaries.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE salaries.to_date = "9999-01-01"
GROUP BY departments.dept_name
ORDER BY average_salary DESC
LIMIT 1
;

#Who is the highest paid employees in the marketing departments?
SELECT employees.first_name, employees.last_name
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Marketing' AND salaries.to_date = '9999-01-01'
ORDER BY salaries.salary DESC 
LIMIT 1
;

#Using the 'Using' function to shorten the join process
SELECT employees.first_name, employees.last_name
FROM employees
JOIN salaries
	USING (emp_no)
JOIN dept_emp
	USING (emp_no)
JOIN departments
	USING(dept_no)
WHERE departments.dept_name = 'Marketing' AND salaries.to_date LIKE '9999%'
ORDER BY salaries.salary DESC
LIMIT 10;

#WHich current department manager has the highest salary?
SELECT employees.first_name, employees.last_name, salaries.salary, departments.dept_name
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
JOIN dept_manager ON employees.emp_no = dept_manager.emp_no
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date = "9999-01-01" AND salaries.to_date = "9999-01-01"
ORDER BY salaries.salary DESC
LIMIT 1;

#BONUS find the names of all current employees, their department name and current managers names
SELECT CONCAT(employees.first_name,' ', employees.last_name) AS full_name, emp_dept.dept_name AS departments, CONCAT(managers.first_name,' ', managers.last_name) AS managers
FROM employees 
JOIN employees_with_departments AS emp_dept ON employees.emp_no = emp_dept.emp_no
JOIN dept_manager ON emp_dept.dept_no = dept_manager.dept_no
LEFT JOIN employees AS managers ON dept_manager.emp_no = managers.emp_no
WHERE dept_manager.to_date LIKE "9999%"
;


#Bonus Find the highest paid employee in each department
SELECT emp.dept_name, max(salary)
FROM employees
JOIN employees_with_departments AS emp ON employees.emp_no = emp.emp_no
JOIN salaries ON employees.emp_no = salaries.emp_no
GROUP BY emp.dept_name
;

SELECT DISTINCT(departments.dept_name), employees.first_name, salaries.salary 
FROM employees
JOIN dept_emp ON employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE salaries.to_date > NOW() AND dept_emp.to_date > NOW()
GROUP BY departments.dept_name
ORDER BY MAX(salaries.salary)
;

SELECT DISTINCT departments.dept_name, first_name
FROM departments
JOIN employees_with_departments USING (dept_no)
WHERE dept_no IN (
	SELECT dept_no
	FROM employees
	WHERE emp_no IN (
		SELECT emp_no
		FROM salaries
		ORDER BY salary
	)
)
;

#Sub query method
SELECT emp.first_name, emp.last_name, dept.dept_name, max_salary.max_salary
FROM salaries
JOIN (
        SELECT MAX(A.salary) AS max_salary, A.dept_no FROM 
                (SELECT dept_emp.emp_no, dept_emp.dept_no, dept_emp.to_date, salaries.salary
                FROM dept_emp
                JOIN salaries USING (emp_no)
                WHERE dept_emp.to_date > NOW()
            ) A
            GROUP BY A.dept_no
            ) max_salary 
            ON salaries.salary = max_salary.max_salary
JOIN employees emp ON salaries.emp_no = emp.emp_no
JOIN departments dept ON max_salary.dept_no = dept.dept_no
WHERE salaries.to_date > NOW()
;