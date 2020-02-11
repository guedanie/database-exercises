USE employees;

SELECT * FROM employees;

#Find all employees with first anmes "Irena, Vidya or Maya, sort by first name then last name 
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY first_name, last_name;

#Update the order clause
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY last_name, first_name;

#Order by employee number
SELECT *
FROM employees
WHERE last_name LIKE "e%"
ORDER BY emp_no;

#Find all employees hired in the 90s
SELECT *
FROM employees
WHERE hire_date BETWEEN "1990-01-01" AND "1999-12-31";

#Find all employees born on christams
SELECT *
FROM employees
WHERE birth_date LIKE '%12-25';

#Alternative solution
SELECT *
FROM employees
WHERE MONTH(birth_date) = "12" AND DAY(birth_date) = "25";

#Find all employees with a 'q' last name
SELECT *
FROM employees
WHERE last_name LIKE '%q%';

#Update query to use or instead of in
SELECT *
FROM employees
WHERE first_name = 'Irena' 
OR first_name = 'Vidya' 
OR first_name = 'Maya';

#Add condition to previous query to find male
SELECT * 
FROM employees
WHERE (first_name = 'Irena' OR first_name = 'Vidya' OR first_name = 'Maya') 
AND gender = 'M';

#Order by employee number in ascending order 
SELECT *, UPPER(CONCAT(first_name, last_name)) AS full_name
FROM employees
WHERE CONCAT(last_name, first_name) LIKE 'E%' OR CONCAT(last_name, first_name) LIKE '%E'
ORDER BY emp_no ASC;

#Order by employee number in descending order - update to contt the first and last name
SELECT *, UPPER(CONCAT(first_name, last_name)) AS full_name
FROM employees
WHERE CONCAT(last_name, first_name) LIKE 'E%' AND CONCAT(last_name, first_name) LIKE '%E'
ORDER BY emp_no DESC;

#Find all employees hired in the 90s and born on Christmas
SELECT *
FROM employees
WHERE (hire_date BETWEEN "1990-01-01" AND "1999-12-31")
AND birth_date LIKE "%12-25"
ORDER BY birth_date ASC, hire_date DESC;

#How long have employees hired in the 90's been working 
SELECT *, DATEDIFF(NOW(), hire_date) AS "Days working"
FROM employees
WHERE (hire_date BETWEEN "1990-01-01" AND "1999-12-31")
AND birth_date LIKE "%12-25"
ORDER BY birth_date ASC, hire_date DESC;

#Largest and Smaller salary
SELECT * FROM salaries;

SELECT MIN(salary), MAX(salary)
FROM salaries;

#Generate username for all employees
SELECT * FROM employees;

SELECT LOWER(CONCAT(
SUBSTR(first_name, 1,1), 
SUBSTR(last_name, 1,4), 
'_', 
SUBSTR(birth_date, 6, 2), 
SUBSTR(birth_date, 3, 2)
))
AS 'Username', first_name, last_name, birth_date 
FROM employees
LIMIT 10;

#Find all employees with a 'q' in their last name but not 'qu'
SELECT *
FROM employees
WHERE last_name LIKE '%q%'
AND last_name NOT LIKE '%qu%';

SELECT first_name, len(first_name)
FROM employees;

##BONUS
# Find the number of years each employee has been with the company, not just the
# number of days. *Bonus* do this without the DATEDIFF function (hint: YEAR)
SELECT *, Datediff(NOW(), hire_date) / 365.25 AS 'Time in Company'
FROM employees

SELECT *, YEAR(NOW()) - YEAR(hire_date) / 365.25 AS 'Time in Company'
FROM employees;

# Find OUT how old EACH employee was WHEN they were hired.
SELECT *, datediff(hire_date, birth_date) / 365.25 AS 'Age when hired'
FROM employees;

# Find the most recent DATE IN the dataset. What does this tell you? Does this
# explain the distribution of employee ages?
SELECT AVG(DATEDIFF(NOW(), hire_date)/ 365.25) AS 'AVG time in company', AVG(DATEDIFF(now(),birth_date) /365.25) AS 'AVG age', MAX(hire_date), max(birth_date), DATEdiff(MAX(hire_date),MAX(birth_date)) / 365.25 AS 'Difference'
FROM employees;

