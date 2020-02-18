## Additional exercises

# Employees DATABASE

#How much do the current managers of each department get paid, relative to the average salary for the department? Is there any department where the department manager gets paid less than the average salary? Two departments (production and customer service) managers get payed less than the average.

USE employees;

USE curie_942;
# Create two temporary tables, one to store the average salary of all the departments and a second table to store the salary of the department managers. Then I used a query to call both set of info and display them together. 

CREATE TEMPORARY TABLE avg_dept_salary AS 
	SELECT employees.departments.dept_name, AVG(employees.salaries.salary) avg_dept_salary
	FROM employees.salaries
	JOIN employees.employees USING(emp_no)
	JOIN employees.dept_emp USING (emp_no)
	JOIN employees.departments USING (dept_no)
	WHERE employees.dept_emp.to_date > NOW() AND employees.salaries.to_date > NOW()
	GROUP BY employees.departments.dept_name
;

CREATE TEMPORARY TABLE manager_salary AS
	SELECT employees.departments.dept_name, employees.salaries.salary AS salary_manager
	FROM employees.employees
	JOIN employees.salaries USING (emp_no)
	JOIN employees.dept_manager USING (emp_no)
	JOIN employees.departments USING (dept_no)
	WHERE emp_no IN (
		SELECT emp_no
		FROM employees.dept_manager
		WHERE employees.dept_manager.to_date > NOW()
	) AND employees.salaries.to_date > NOW()
;


SELECT dept_name, avg_dept_salary, salary_manager, (salary_manager - avg_dept_salary)
FROM avg_dept_salary
JOIN manager_salary USING (dept_name)
;

# World Database

USE world;

#What langueages are spoken in Santa Monica

SELECT * FROM city
WHERE NAME = 'Santa Monica'
;

SELECT * FROM countrylanguage
WHERE countrycode = "USA"; 

SELECT countrylanguage.language AS 'language', countrylanguage.percentage AS 'percentage'
FROM countrylanguage
WHERE countrycode IN (
	SELECT countrycode
	FROM city
	WHERE NAME = 'Santa Monica')
ORDER BY percentage ASC
;

# How many different countries are in each region?

SELECT region, count(*) AS n_countries
FROM country 
GROUP BY region
ORDER BY n_countries
;

# What is the population of each region? 

SELECT region, sum(population) AS population
FROM country
GROUP BY region
ORDER BY population DESC
;

#what is the population of each continent

SELECT continent, sum(population) AS population
FROM country
GROUP BY continent
ORDER BY continent ASC
;

# what is the average life expectancy globally 

SELECT AVG(LifeExpectancy)
FROM country
;

#What is the average life expectancy by continet

SELECT continent, AVG(LifeExpectancy) AS avg_life
FROM country
GROUP BY continent
ORDER BY avg_life ASC
;

#What is the average life expectancy by region 

SELECT region, AVG(LifeExpectancy) AS avg_life
FROM country
GROUP BY region
ORDER BY avg_life ASC
;

#Bonus Find all the countries whose local name is different from the official name

SELECT count(*)
FROM country
WHERE NAME != localname
;

SELECT NAME
FROM country 
WHERE NAME != localname
;

# Sakila Database
USE sakila;

# Display the first and last names in all lowercase of all the actor

SELECT lower(first_name), lower(last_name)
FROM actor
;

# You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you could use to obtain this information?

SELECT actor_id, lower(first_name), lower(last_name)
FROM actor
WHERE first_name = 'Joe'
;

#Find all actors whose last name contain the letters "gen"

SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%gen%'
;

#Find all actors whose last names contain the letters "li". This time, order the rows by last name and first name, in that order.

SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name
;

# Using IN, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China


SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
;

# List the last names of all the actors, as well as how many actors have that last name.

SELECT last_name, count(*)
FROM actor
GROUP BY last_name
;

#List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, count(*)
FROM actor
GROUP BY last_name
HAVING count(*) > 1
;

#You cannot locate the schema of the address table. Which query would you use to re-create it?

#Use JOIN to display the first and last names, as well as the address, of each staff member.

SELECT first_name, last_name, address
FROM staff
JOIN address USING (address_id)
;

# Use JOIN to display the total amount rung up by each staff member in August of 2005.

SELECT first_name, sum(amount)
FROM staff
JOIN payment USING (staff_id)
GROUP BY first_name
;

# List each film and the number of actors who are listed for that film.

SELECT title, count(*) AS n_actors
FROM film
JOIN film_actor USING (film_id)
GROUP BY title
;

# How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(*)
FROM inventory
WHERE film_id IN (
	SELECT film_id
	FROM film
	WHERE title = 'Hunchback Impossible'
)
;

# The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
FROM film
WHERE language_id IN (
	SELECT language_id
	FROM `language`
	WHERE `name` = 'English'
	) AND title REGEXP '^[K,G]'
;

## Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
		)
	);
	
## You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers

SELECT first_name, email
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE country_id IN (
			SELECT country_id
			FROM country
			WHERE country = 'Canada'
			)
	)
)
;

USE sakila;

##Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN (
		SELECT category_id
		FROM category
		WHERE `name` = 'Family'
		)
)
;

## Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, sum(payment.amount)
FROM payment
JOIN staff USING (staff_id)
JOIN store USING (store_id)
GROUP BY store_id
;	

# Write a query to display for each store its store ID, city, and country.

SELECT store_id, city, country
FROM store
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
;

#List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name AS genre, sum(payment.amount) AS gross_revenue
FROM category
JOIN film_category USING (category_id)
JOIN film USING (film_id)
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5
;


## Select statements Practice

#Select all columns from the actor table

SELECT * FROM actor;

# select only the last_name column from the actor table

SELECT last_name FROM actor;

## Disctinct operator practice

# select all distinct last names from the actors table

SELECT DISTINCT last_name FROM actor;

# Select all distinct (different) postal codes from the address table.

SELECT DISTINCT postal_code FROM address;

#Select all distinct (different) ratings from the film table

SELECT DISTINCT rating FROM film;

## Where clause practice

#Select the title, description, rating, movie length columns from the films table that last 3 hours or longer.

SELECT title, description, rating, length
FROM film
WHERE length > 180
;

# Select the payment id, amount, and payment date columns from the payments table for payments made on or after 05/27/2005.

SELECT payment_id, amount, payment_date
FROM payment
WHERE payment_date >= "2005-05-27"
;

#Select all columns from the customer table for rows that have a last names beginning with S and a first names ending with N.

SELECT *
FROM customer
WHERE last_name LIKE 'S%' AND first_name LIKE '%N'
;

#Select all columns from the customer table for rows where the customer is inactive or has a last name beginning with "M".

SELECT * 
FROM customer 
WHERE active = 0 OR last_name LIKE 'M%'
;

#Select all columns from the category table for rows where the primary key is greater than 4 and the name field begins with either C, S or T

SELECT *
FROM category
WHERE category_id > 4 AND `name` REGEXP '^[C,S,T]'
;

#Select all columns minus the password column from the staff table for rows that contain a password
# It doesn't seem like this is possible - only solution is to manually select all the column exept for password
SELECT *EXCLUDE staff.password
FROM staff;

## IN Challenges
#Select the phone and district columns from the address table for addresses in california, England, Taipei or West Java

SELECT phone, district
FROM address
WHERE district IN ('California', 'England', 'Taipei', 'West Java')
ORDER BY district
;

#Select the payment id, amount, and payment date columns from the payment table for paymets made in 05/25/2005, 05/27, 2005, and 05/29/2005 

SELECT payment_id, amount, payment_date
FROM payment
WHERE YEAR(payment_date) IN (2005) AND MONTH(payment_date) IN (05) AND DAY(payment_date) IN (25, 27, 29)
ORDER BY payment_date
;

#Select all columns from the film table for films rated G, PG-13, or NC-17
SELECT *
FROM film
WHERE rating IN ('G', 'PG-13', 'NC-17')
ORDER BY rating
;

#LIKE operator challenges
#Sekect akk columns from the payment table and only include the first 20 rows

SELECT *
FROM payment
LIMIT 20
;

#slect the payment and amount columns from the payment table for rows where the payment amount is greater than 5, and only select rows whose zero-based index in the result set is between 1000-2000.

SELECT payment_id, amount
FROM payment
WHERE amount > 5
LIMIT 240 OFFSET 246
;
 
## JOIN exercises
# Select customer first_name/last_name and actor first_name/last_name columns from performing a left join between the customer and actor column on the last_name column in each table. (i.e. customer.last_name = actor.last_name)
#Label customer first_name/last_name columns as customer_first_name/customer_last_name
#Label actor first_name/last_name COLUMNS IN a similar fashion.
#RETURNS correct number of records: 599

SELECT customer.first_name AS customer_first_name, customer.last_name AS customer_last_name, actor.first_name AS actor_first_name, actor.last_name AS actor_last_name
FROM customer
LEFT JOIN actor USING (last_name)
;

#Back to challenges.- end of basic practice
## What is the average replacement cost of a film? Does this change depending on the rating of the film?


SELECT AVG(replacement_cost)
FROM film
;

SELECT rating, AVG(replacement_cost)
FROM film
GROUP BY rating
;

# How many different films of each genre are in the database?

SELECT `name` AS genre, count(*)
FROM category
JOIN film_category USING (category_id)
JOIN film USING (film_id)
GROUP BY genre
;

# What are the 5 frequently rented films?

SELECT title, count(*) AS total
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY title
ORDER BY total DESC
LIMIT 10
;

# What are the most most profitable films (in terms of gross revenue)?

SELECT title, sum(amount) AS total
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY title
ORDER BY total DESC
LIMIT 5
;

#Who is the best customer? 

SELECT concat(last_name, ', ', first_name) AS NAME, sum(amount) AS total
FROM customer
JOIN rental USING (customer_id)
JOIN payment USING (rental_id)
GROUP BY NAME
ORDER BY total DESC
LIMIT 1
;

#Who are the most popular actors (that have appeared in the most films)? slight different between the correct answer - website doesn't seem TO recognize susan davis AS HAVING 54 appearances

SELECT concat(last_name, ', ', first_name) AS actor_name, count(*) AS total
FROM actor
JOIN film_actor USING (actor_id)
GROUP BY actor_name
ORDER BY total DESC
LIMIT 5
;

#What are the sales for each store for each month in 2005? Answer slightly different from results on page
SELECT Concat(YEAR(payment_date), '-', '0', MONTH(payment_date)) AS MONTH, store.store_id, sum(amount) AS sales
FROM payment
JOIN staff USING (staff_id)
JOIN store ON store.manager_staff_id = staff.staff_id
WHERE YEAR(payment_date) = "2005"
GROUP BY MONTH, store.store_id
;

#Using the date_format to effectively take out the date column
SELECT date_format(payment_date, '%Y' '-' '%m') AS MONTH, store.store_id, sum(amount) AS sales
FROM payment
JOIN staff USING (staff_id)
JOIN store USING (store_id)
WHERE YEAR(payment_date) = 2005
GROUP BY MONTH, store.store_id
;

SELECT MONTH(payment_date), count(customer_id)
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY MONTH(payment_date)
;

SELECT MONTH(payment_date), YEAR(payment_date) FROM payment;

## Bonus: Find the film title, customer name, customer phone number, and customer address for all the outstanding DVDs.

SELECT film.title, concat(customer.last_name,', ',customer.first_name), address.phone, address.address
FROM address
JOIN customer USING (address_id)
JOIN payment USING (customer_id)
JOIN rental USING (rental_id)
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
WHERE rental.return_date IS NULL
;

SELECT count(*)
FROM rental
WHERE return_date IS NULL;