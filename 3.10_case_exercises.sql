USE employees;

## Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.

SELECT DISTINCT emp_no, dept_no, hire_date, dept_emp.to_date, 
	CASE 
		WHEN dept_emp.to_date AND salaries.to_date LIKE '9999-01-01' THEN 1
		ELSE 0
		END AS 'is_current_employee'
FROM employees
JOIN dept_emp USING (emp_no)
JOIN salaries USING (emp_no)
;

SELECT DISTINCT  
	CASE 
		WHEN dept_emp.to_date AND salaries.to_date LIKE '9999-01-01' THEN 1
		ELSE 0
		END AS 'is_current_employee', count(*)
FROM employees
JOIN dept_emp USING (emp_no)
JOIN salaries USING (emp_no)
GROUP BY is_current_employee
;

SELECT *
FROM dept_emp
WHERE to_date LIKE '9999%'
;

#Write a query that returns all employee names, and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.


SELECT CONCAT(first_name,' ', last_name) AS full_name, 
	CASE 
		WHEN last_name REGEXP '^[A-H]' THEN 'A-H'
		WHEN last_name REGEXP '^[I-Q]' THEN 'I-Q'
		ELSE 'R-Z'
	END AS 'alpha_group'
FROM employees
;

#Gives a count for each group
SELECT  
	CASE 
		WHEN last_name REGEXP '^[A-H]' THEN 'A-H'
		WHEN last_name REGEXP '^[I-Q]' THEN 'I-Q'
		ELSE 'R-Z'
	END AS 'alpha_group', count(*) AS n_emp
FROM employees
GROUP BY alpha_group
;

SELECT *
FROM employees
WHERE last_name REGEXP '^[A-B]'
;

#How many employees were born in each decade?

SELECT CASE 
	WHEN YEAR(birth_date) BETWEEN 1940 AND 1949 THEN '1940s'
	WHEN YEAR(birth_date) BETWEEN 1950 AND 1959 THEN '1950s'
	WHEN YEAR(birth_date) BETWEEN 1960 AND 1969 THEN '1960s'
	WHEN YEAR(birth_date) BETWEEN 1970 AND 1979 THEN '1970s'
	WHEN YEAR(birth_date) BETWEEN 1980 AND 1989 THEN '1980s'
	WHEN YEAR(birth_date) BETWEEN 1990 AND 1999 THEN '1990s'
	ELSE '2000s'
END AS 'decade_born', Count(*) AS n_born
FROM employees
GROUP BY decade_born
;

SELECT count(*)
FROM employees
WHERE YEAR(birth_date) BETWEEN 1980 AND 1999
;

SELECT YEAR(birth_date)
FROM employees
;

# Bonus What is the average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?

SELECT DISTINCT CASE
	 WHEN dept_name IN ('research', 'development') THEN 'R&D'
            WHEN dept_name IN ('sales', 'marketing') THEN 'Sales & Marketing' 
            WHEN dept_name IN ('Production', 'Quality Management') THEN 'Prod & QM'
            WHEN dept_name IN ('Finance', 'Human Resources') THEN 'Finance & HR'
            ELSE dept_name
            END AS dept_group, 
     AVG(salary)
FROM departments
JOIN dept_emp USING (dept_no)
JOIN salaries USING (emp_no)
WHERE salaries.to_date > NOW() AND dept_emp.to_date > NOW()
GROUP BY dept_group;


#To compare - regular average by deparment
SELECT dept_name, AVG(salary)
FROM departments
JOIN dept_emp USING (dept_no)
JOIN salaries USING (emp_no)
WHERE dept_emp.to_date > NOW() AND salaries.to_date > NOW()
GROUP BY dept_name
;