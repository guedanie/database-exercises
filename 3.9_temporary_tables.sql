USE employees;

SELECT *
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
;
#Create a temporary table using a query from the employees database

USE curie_942;

CREATE TEMPORARY TABLE employees_with_departments AS 
SELECT emp_no, first_name, last_name, dept_no, dept_name
FROM employees.employees
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING (dept_no)
LIMIT 100
;

SELECT * FROM employees_with_departments;

SHOW TABLES;

# Alter the table to have a new column
ALTER TABLE employees_with_departments ADD full_name VARCHAR(100);

SELECT * FROM employees_with_departments;

#Update the new full_name colunm to contain correct data

UPDATE employees_with_departments
SET full_name = CONCAT(first_name,' ',last_name);

SELECT *
FROM employees_with_departments;

#Remove the first_name and last_name columns

ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

SELECT * FROM employees_with_departments;

#Create a temporary table based on the payment table from the skila database

USE sakila;

USE curie_942;

SELECT *
FROM payment;

CREATE TEMPORARY TABLE payment AS
SELECT *
FROM sakila.payment;

DESCRIBE payment;

SELECT *
FROM payment;
## Transform the amount column such that is is stored as  an integer representing the number of cents of the payment. 

ALTER TABLE payment MODIFY amount DECIMAL(10,2);

UPDATE payment
SET amount = amount * 100;

ALTER TABLE payment MODIFY amount INTEGER(3);

SELECT * 
FROM payment;


## Find out how the average pay in each department compares to the overall average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department to work for? The worst?

USE employees;

SELECT departments.dept_name, (salary - (SELECT(AVG(salary)) FROM salaries) / (SELECT(stddev(salary)) FROM salaries)) AS 'z_score'
FROM departments
JOIN dept_emp USING (dept_no)
JOIN employees USING (emp_no)
JOIN salaries USING (emp_no)
WHERE salaries.to_date > NOW() AND dept_emp.to_dates > NOW()
GROUP BY departments.dept_name
)
;

SELECT salary - (SELECT AVG(salary)FROM salaries) / (SELECT(stddev(salary)) FROM salaries) AS 'z_score'
FROM salaries;


USE curie_942;

SELECT AVG(salary)
FROM salaries
WHERE to_date > NOW();

CREATE TEMPORARY TABLE dept_avg AS 
	SELECT employees.departments.dept_name, AVG(salary) AS avg_salary
	FROM employees.departments
	JOIN employees.dept_emp USING (dept_no)
	JOIN employees.employees USING (emp_no)
	JOIN employees.salaries USING (emp_no)
	WHERE employees.salaries.to_date > NOW() AND employees.dept_emp.to_date > NOW()
	GROUP BY employees.departments.dept_name
;

CREATE TEMPORARY TABLE dept_salary AS 
	SELECT employees.departments.dept_name, salary
	FROM employees.departments
	JOIN employees.dept_emp USING (dept_no)
	JOIN employees.employees USING (emp_no)
	JOIN employees.salaries USING (emp_no)
	WHERE employees.salaries.to_date > NOW() AND employees.dept_emp.to_date > NOW()
;


CREATE TEMPORARY TABLE dept_sd AS 
	SELECT employees.departments.dept_name, stddev(salary) AS sd_salary
	FROM employees.departments
	JOIN employees.dept_emp USING (dept_no)
	JOIN employees.employees USING (emp_no)
	JOIN employees.salaries USING (emp_no)
	WHERE employees.salaries.to_date > NOW() AND employees.dept_emp.to_date > NOW()
	GROUP BY employees.departments.dept_name
;

SELECT dept_salary.dept_name, ((salary - dept_avg.avg_salary) / dept_sd.sd_salary) AS z_score
FROM dept_salary
JOIN dept_avg ON dept_salary.dept_name = dept_avg.dept_name
JOIN dept_sd ON dept_avg.dept_name = dept_sd.dept_name
GROUP BY dept_salary.dept_name
;

SELECT *
FROM dept_avg;

# z score = salary - avg(salary) / stddev(salary)

SELECT AVG(salary)
FROM emp_salary;

SELECT stddev(salary)
FROM emp_salary;

SELECT emplyees.departments.dept_name, z_score
FROM dept_sum
WHERE 
