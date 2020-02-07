## Selecting Database
USE employees;

## Showing tables in the employee Databases
SHOW TABLES;

## Explore the employees table to see data types
SHOW CREATE TABLE employees;

DESCRIBE employees;

DESCRIBE salaries;

DESCRIBE departments;

DESCRIBE employees_with_departments;


#Which tables comtain numeric type column?
## All != departments

# Which table contains a string type column?
## All != salaries

# Which table contains a data? 
## ALl != departments & employees_with_departments

#What is the relationship between the employees and the departments table?
# There is no relationship between the two tables. For us to relate these two data sets, we would need the "employees_with_departments" table

#Show the SQL that created the dept_manager table

SHOW CREATE TABLE dept_manager;
