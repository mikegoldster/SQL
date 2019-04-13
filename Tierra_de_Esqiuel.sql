USE Sakila;
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
FROM actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(UPPER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(first_name, 2)), " ", UPPER(SUBSTR(last_name, 1, 1)), LOWER(SUBSTR(last_name, 2))) 
AS "Actor Names" 
FROM actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM ACTOR 
WHERE first_name = "Joe" ;
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name 
FROM ACTOR 
WHERE last_name 
RLIKE "GEN";
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name 
FROM ACTOR 
WHERE last_name 
RLIKE "LI"
ORDER BY last_name, first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
SET sql_safe_updates=0;
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SHOW CREATE TABLE address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff
LEFT JOIN address
ON staff.address_id = address.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id; 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title; 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title, COUNT(inventory.inventory_id)
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
WHERE film.title = "HUNCHBACK IMPOSSIBLE"; 
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
	FROM film
    WHERE language_id=1 AND 
    title LIKE 'Q%'
    OR title LIKE 'K%';
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'ALONE TRIP'
  )
);
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
	INNER JOIN address
		ON customer.address_id = address.address_id
	INNER JOIN city
		ON address.city_id = city.city_id
	INNER JOIN country
		ON city.country_id = country.country_id
WHERE country = 'Canada';
SELECT * FROM country;
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
	INNER JOIN film_category
		ON film.film_id = film_category.film_id
	INNER JOIN category
		ON film_category.category_id = category.category_id
WHERE name = 'Family';
-- 7e. Display the most frequently rented movies in descending order.
SELECT inventory.film_id, film.title, COUNT(film.film_id) as rents
FROM film
INNER JOIN inventory
	ON film.film_id = inventory.film_id
INNER JOIN rental
	ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
	ON rental.rental_id = payment.rental_id
GROUP BY film.title
ORDER BY rents DESC;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT address.address, SUM(payment.amount)
FROM address
INNER JOIN store 
	ON address.address_id = store.address_id
INNER JOIN customer
	ON store.store_id = customer.store_id
INNER JOIN payment
	ON payment.customer_id = customer.customer_id
GROUP BY address;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
JOIN address
	ON store.address_id = address.address_id
JOIN city
	ON address.city_id = city.city_id
JOIN country
	ON city.country_id = country.country_id
;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to u0se the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name AS genre, SUM(payment.amount) AS gross_revs  
FROM category
JOIN film_category
	ON category.category_id = film_category.category_id
JOIN inventory
	ON film_category.film_id = inventory.film_id
JOIN rental
	ON inventory.inventory_id = rental.inventory_id
JOIN payment
	ON rental.rental_id = payment.rental_id
GROUP BY genre
ORDER BY gross_revs DESC
LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW genrebonanza AS
SELECT category.name AS genre, SUM(payment.amount) AS gross_revs  
FROM category
JOIN film_category
	ON category.category_id = film_category.category_id
JOIN inventory
	ON film_category.film_id = inventory.film_id
JOIN rental
	ON inventory.inventory_id = rental.inventory_id
JOIN payment
	ON rental.rental_id = payment.rental_id
GROUP BY genre
ORDER BY gross_revs DESC
LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM genrebonanza;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW genrebonanza;