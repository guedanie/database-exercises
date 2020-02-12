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
SELECT dept_emp.dept_no, COUNT(*)
FROM employees
WHERE 

