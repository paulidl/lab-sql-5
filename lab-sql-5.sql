USE sakila;
-- 1. Drop column picture from staff.

ALTER TABLE sakila.staff DROP COLUMN picture;

-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

# Consulting all the information of Tammy Sanders..
SELECT * FROM sakila.customer WHERE first_name REGEXP "tammy";

# Where I want to fill the information.
SELECT * FROM sakila.staff;

INSERT INTO sakila.staff(staff_id, first_name, last_name, address_id, email, store_id, username, last_update)
SELECT '3', first_name, last_name, address_id, email, store_id, first_name, last_update
FROM sakila.customer 
WHERE first_name = "Tammy" AND last_name = "Sanders";

-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
-- You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there. 
-- You can query those pieces of information. For eg., you would notice that you need customer_id information as well. 
-- To get that you can use the following query: SELECT customer_id FROM sakila.customer WHERE first_name = 'CHARLOTTE' and last_name = 'HUNTER';
-- Use similar method to get inventory_id, film_id, and staff_id.

# Consulting all the information from the member of the staff Mike Hillyer.
SELECT * FROM sakila.staff; 				-- staff_id= 1
# Consulting all the information of the film Academy Dinosaur.
SELECT * FROM sakila.film WHERE title REGEXP "Academy Dinosaur"; 								-- film_id = 1
# Consulting all the information of the inventory from the film Academy Dinosaur.
SELECT * FROM sakila.inventory;
SELECT inventory_id FROM sakila.inventory WHERE film_id=1 AND store_id=1; 						-- There are 4.
# Consulting all the information of Charlotte Hunter.
SELECT * FROM sakila.customer WHERE first_name REGEXP "Charlotte" AND last_name REGEXP "Hunter"; -- customer_id=130
# Where I want to fill the information
SELECT * FROM sakila.rental;
# Consulting the last rental_id.
SELECT * FROM sakila.rental ORDER BY rental_id DESC limit 1; 									-- last rental_id = 16049

INSERT INTO sakila.rental(rental_date, inventory_id, customer_id, staff_id, last_update)
VALUES (current_timestamp, 1, 130, 1, current_timestamp);

-- 4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. 
-- Follow these steps:

-- 4.1. Check if there are any non-active users:
SELECT * FROM sakila.customer;
SELECT active, count(*) AS total_number FROM customer GROUP BY active;
SELECT * FROM sakila.customer WHERE active = 0;

-- 4.2. Create a table backup table as suggested:
CREATE TABLE deleted_users (
  customer_id INTEGER NOT NULL PRIMARY KEY,  
  email VARCHAR(50), 								-- String column of up to 50 characters
  date TIMESTAMP									-- Store time in UTC
);
SELECT * FROM sakila.deleted_users;	-- Checking if the table was created.

-- 4.3. Insert the non active users in the table backup table:

INSERT INTO deleted_users(customer_id, email, date)
SELECT customer_id, email, current_timestamp
FROM sakila.customer
WHERE active = 0;
SELECT * FROM sakila.deleted_users; -- Checking if the non active users are inserted on the table.

-- 4.4. Delete the non active users from the table customer

DELETE FROM sakila.customer WHERE active = 0;			-- It gives me an ERROR.

SET foreign_key_checks = 0; 							-- Disable the foreign key checks
DELETE FROM sakila.customer WHERE active = 0;
SET SQL_SAFE_UPDATES = 1;

SELECT active, count(*) AS total_number FROM customer GROUP BY active; -- Checking if the non active users are deleted form the table.