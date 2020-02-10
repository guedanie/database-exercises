USE employees;

SELECT * FROM employees;

#Find all employees with first anmes "Irena, Vidya or Maya
SELECT first_name
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');

#Find all employees whose last name starts with "E"
SELECT *
FROM employees
WHERE last_name LIKE "e%";

#Find all employees hired in the 90s
SELECT *
FROM employees
WHERE hire_date BETWEEN "1990-01-01" AND "1999-12-31";

#Find all employees born on christams
SELECT *
FROM employees
WHERE birth_date LIKE '%12-25';

#Find all employees with a 'q' last name
SELECT *
FROM employees
WHERE last_name LIKE '%q%';

#Find all employees whose last name starts or ends with E
SELECT last_name
FROM employees
WHERE last_name LIKE 'E%' OR last_name LIKE '%E';

#Duplicate previous query and update to find all employees whose last name starts and ends with E
SELECT last_name
FROM employees
WHERE last_name LIKE 'E%' and last_name LIKE '%E';

#Find all employees hired in the 90s and born on Christmas
SELECT *
FROM employees
WHERE hire_date BETWEEN "1990-01-01" AND "1999-12-31" AND birth_date LIKE "%12-25";

#Find all employees with a 'q' in their last name but not 'qu'
SELECT *
FROM employees
WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%';