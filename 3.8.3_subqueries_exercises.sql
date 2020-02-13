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
GROUP BY titles
;

#Actual query
SELECT employees.first_name, employees.last_name, employee_salary.salary
FROM employees
LEFT JOIN salaries AS employee_salary ON employees.emp_no = employee_salary.emp_no
WHERE employees.emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE employee_salary.salary > (SELECT(AVG(salary)) FROM salaries)
	) 
AND employee_salary.to_date > NOW()
;


#How many current salaries are within 1 standard deviation of the highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?

SELECT STDDEV(salary) AS salary_sd
FROM salaries;

#BONUS find all the department names that currently have female managers
SELECT dept_name
FROM departments
WHERE dept_no IN (
	SELECT dept_no
	FROM dept_manager
	WHERE emp_no IN (
		SELECT emp_no
		FROM employees
		WHERE gender = 'F'
		) AND to_date > NOW()
	)
;

#FInd the first and last name of the employee with the higehst salary

#Using subquery method
SELECT first_name, last_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary = (SELECT(MAX(salary)) FROM salaries) AND to_date > NOW()
	)
;

#COrrect output using JOIN
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries USING(emp_no)
WHERE to_date > NOW()
ORDER BY salary DESC
LIMIT 1
;


#FInd the department name that the employee wit hthe higehst salary works in

#Using Join method
SELECT dept_name
FROM departments
JOIN dept_emp USING (dept_no)
JOIN employees USING (emp_no)
JOIN salaries USING (emp_no)
WHERE dept_emp.to_date > NOW() AND salaries.to_date > NOW()
ORDER BY salary DESC
LIMIT 1
;

#Using subquery method
SELECT dept_name
FROM employees_with_departments
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary = (SELECT(MAX(salary)) FROM salaries) AND to_date > NOW()
	);

#Using subquery method and not using the employees_with_departments table	
SELECT dept_name
FROM departments
WHERE dept_no IN (
	SELECT dept_no
	FROM dept_emp
	WHERE emp_no IN (
		SELECT emp_no
		FROM salaries
		WHERE salary = (SELECT(MAX(salary)) FROM salaries) AND to_date > NOW()
		)
	);