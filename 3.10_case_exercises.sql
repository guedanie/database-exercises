USE employees;

## Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.

SELECT emp_no, dept_no, hire_date, to_date, 
	CASE 
		WHEN to_date LIKE '9999-01-01' THEN 1
		ELSE 0
		END AS 'is_current_employee'
FROM employees
JOIN dept_emp USING (emp_no)
;

SELECT *
FROM dept_emp
WHERE to_date LIKE '9999%'
;

#Write a query that returns all employee names, and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.

SELECT first_name, last_name, 
	CASE 
		WHEN last_name IN ('A%', 'B%', 'C%', 'D%', 'E%', 'F%', 'G%', 'H%') THEN 'A-H'
		WHEN last_name IN ('I%', 'J%', 'K%', 'L%', 'M%', 'N%', 'P%', 'Q%') THEN 'I-Q'
		ELSE 'R-Z'
	END AS 'alpha_group'
FROM employees
;

SELECT first_name, last_name, 
	CASE 
		WHEN last_name IN ('A%', 'B%', 'C%', 'D%', 'E%', 'F%', 'G%', 'H%') THEN 'A-H'
		WHEN last_name IN ('I%', 'J%', 'K%', 'L%', 'M%', 'N%', 'P%', 'Q%') THEN 'I-Q'
		ELSE 'R-Z'
	END AS 'alpha_group'
FROM employees
;

#How many employees were born in each decade?

SELECT count(CASE 
	WHEN YEAR(birth_date) BETWEEN 1940 AND 1949 THEN '1940s'
	WHEN YEAR(birth_date) BETWEEN 1950 AND 1959 THEN '1950s'
	WHEN YEAR(birth_date) BETWEEN 1960 AND 1969 THEN '1960s'
	WHEN YEAR(birth_date) BETWEEN 1970 AND 1979 THEN '1970s'
	WHEN YEAR(birth_date) BETWEEN 1980 AND 1989 THEN '1980s'
	WHEN YEAR(birth_date) BETWEEN 1990 AND 1999 THEN '1990s'
	ELSE '2000s'
END) AS 'decade_born'
FROM employees
;

SELECT count(*)
FROM employees
WHERE YEAR(birth_date) BETWEEN 1950 AND 1959
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

SELECT dept_name, AVG(salary)
FROM departments
JOIN dept_emp USING (dept_no)
JOIN salaries USING (emp_no)
WHERE dept_emp.to_date > NOW() AND salaries.to_date > NOW()
GROUP BY dept_name
;