#SUBQUERIES exercises
USE employees;

#Find all the employees with the same hire date as employees 101010 using a sub-query - answer should have 69 rows

SELECT employees.first_name, employees.hire_date, employees.emp_no
FROM employees
WHERE employees.hire_date IN(
	SELECT employees.hire_date
	FROM employees 
	WHERE emp_no = 101010
	)
;

SELECT employees.first_name, employees.hire_date
FROM employees
WHERE emp_no = 101010;

## Find all the titles held by all employees with the frist name Aamod. Results should be 314 total titles, 6 unique titles

SELECT titles.title, COUNT(*)
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM employees 
	WHERE employees.first_name = 'Aamod')
GROUP BY titles.title
;

#How many people in the employees table are no longer working for the company?
SELECT Count(emp_no)
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE to_date < NOW()
) AND emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE to_date < NOW()
)
;

#Find all the current department managers that are female.
SELECT first_name, last_name
FROM employees
WHERE emp_no IN (
    SELECT emp_no
    FROM dept_manager
    WHERE to_date > CURDATE() 
) AND gender = 'F'
;

#Find all the employees that currently have a higher than average salary
SELECT AVG(salary)
FROM salaries
;

#Example query
SELECT title, count(*)
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary BETWEEN 67000 AND 70000
	AND to_date > now()
)
AND to_date > now()
GROUP BY title
;

#Actual query
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE employees.emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary > 65000
	) 
AND salaries.to_date > NOW()
;

#How many current salaries are within 1 standard deviation of the highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?

SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
WHERE employees.emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary > (AVG(salary))
	) 
AND salaries.to_date > NOW()
;

SELECT STDEV(salary) AS salary_sd
FROM salaries