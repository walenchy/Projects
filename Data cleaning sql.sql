
-- SELECT CLAUSE

/*
 USE sql_store;
 SELECT *
 FROM customers -- to retrieve database table
  WHERE customer_id = 1 -- to specify column
  ORDER BY first_name -- rearrange the column by name
 */
 
 /*SELECT 
 last_name, 
 first_name, 
 points, 
 (points + 10) * 100 AS 'discount factor'  -- use alias
 FROM customers
 */
 
/*  SELECT DISTINCT state
 FROM customers
 */
 
/* SELECT *
 FROM products
 */
 
 
 /* SELECT 
 name, 
 unit_price, 
 unit_price * 1.1 AS 'new price'
 FROM products
 */
 
 -- The WHERE Clause to filter data in a specific table
 /* SELECT *
 FROM customers
 WHERE points > 3000
 */
 
 -- operaators in SQL
 /*
 >
 >=
 <
 <=
 =
 != or <>
 */
 
-- SELECT *
 -- FROM customers
 -- WHERE state = 'va'
 -- WHERE state != 'va'
 -- WHERE state <> 'va'
 -- WHERE birth_date > '1990-01-01'
 
 -- how to combine multiple condition when filtering data
 
 -- task  Get the orders placed this year
 -- SOLUTION
 /*
 SELECT *
 FROM orders
 WHERE order_date >= '2019-01-01'
 */
 -- The AND , OR and NOT operators
  /* 
  
  SELECT *
   FROM customers
 WHERE birth_date >'1990-01-01' OR 
 (points > 1000 AND state = 'va')
 WHERE state = 'va' OR state = 'GA' OR state='FL'
 
-- better in this way
-- WHERE state IN ('VA', 'GA', 'FL')
 WHERE state NOT IN ('VA', 'GA', 'FL')
 */
 
 --  TASK Return products with
 -- quantity in stock equal to 49, 38, 72
 
 -- SOLUTION
 /* SELECT *
  FROM products
  WHERE quantity_in_stock IN ('49', '38', '72')
 */
 
 -- WHERE NOT (birth_date > '1990-01-01' OR points > 1000)
 -- WHERE birth_date <= '1990-01-01' AND points <= 1000
 
 -- TASK for order_items
 -- from the order_items table , get the items order #6
 -- where the total price is greater than 30
 
 -- SOLUTION
 /*
 SELECT *-- , unit_price * quantity > 30 AS total_price 
 FROM order_items
  WHERE order_id = 6  AND unit_price * quantity > 30
 
 */
 
 
 -- between operator
 -- SELECT *
 -- FROM customers
 -- WHERE points >= 1000 AND points <= 3000
 -- order 
-- WHERE points BETWEEN 1000 AND 3000
-- WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01'

-- WHERE last_name LIKE 'b%' -- the last_name start with b
-- WHERE last_name LIKE '%b%' -- b can be anywhere in the table (before and after)
-- WHERE last_name LIKE '%y' -- name end with y
-- WHERE last_name LIKE 'b____y' (like 3 character after b and before y)

-- SAMPLES
-- % use this for any number of characters
-- LIMIT specify the number of row you want in your ouput and also be combine with ORDER BY
# HAVING goes with a specific condition 
-- _ use this for single character
-- A___% means 3 characters after a and anything end it

-- TASK for the LIKE operator: Get the customers whose addresses
-- contain TRAIL or AVENUE
-- phone numbers end with 9

-- SOLUTION
-- WHERE address LIKE '%trail%' OR
-- address LIKE '%avenue%'
-- WHERE phone LIKE '%9'
-- WHERE phone NOT LIKE '%9'

-- SAMPLES
-- WHERE last_name LIKE '%field%' -- that contain field in ther last name
-- or
-- WHERE last_name REGEXP 'field'  -- to search for string in a table
-- WHERE last_name REGEXP '^field' -- field will begins in the last_name
-- WHERE last_name REGEXP 'field$|mac|rose' -- will be last here
 -- WHERE last_name REGEXP 'e' -- to  search for character of 'e' in the last_name column
-- WHERE last_name REGEXP '[a-k]e' -- will search for character range in the bracket and end with 'e'

-- OPERATORS
-- % means anything
-- _ means a specific character
-- ^ beginning of the stirngs
-- $ end of the strings
-- | logical pipe or supply multiple pattern
-- [abcd] to match any single character listed in the bracket
-- [a-g] with the hyphen to denote the range of characters
-- this ^ carrot sign means
-- last_name must start with field, while the dolla $ means end of a strings

-- TASK
-- Get the customers whose
-- first names are ELKA or AMBUR

/* SOLUTION
SELECT *
 FROM customers
 WHERE first_name REGEXP 'elka' OR 
 first_name REGEXP 'ambur'
  or
 WHERE first_name REGEXP 'elka|ambur'
 */
 
-- last names end with EY or ON
 -- SOLUTION
-- WHERE last_name REGEXP 'ey$|on$' 

-- last name start MY or contain SE
-- solution
-- WHERE last_name REGEXP '^my|se'

-- last name contain B followed by R or U
-- solution
-- WHERE last_name REGEXP 'b[ru]'
-- or 
-- WHERE last_name REGEXP 'br|bu'

-- record with missing value 
-- WHERE phone IS NULL -- for customers doesnot have having
-- WHERE phone IS NOT NULL

-- TASK
-- GET the orders that not shipped yet
/* SELECT *
FROM orders
WHERE shipped_date IS NULL
*/

-- THE ORDER BY clause

-- SORTING DATA IN SEQUEL
-- SELECT *
-- SELECT first_name, last_name, 10 AS points
-- FROM customers
-- ORDER BY state, first_name 
-- ORDER BY points, first_name
-- ORDER BY first_name DESC 

-- TASK FOR ORDER BY from order_items table
/*
SELECT *,
 quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC
*/
-- LIMIT Clause
-- SELECT *
-- FROM customers
-- LIMIT 3
-- page 1: 1-3
-- page 2: 4-6
-- page 3: 7-9
-- LIMIT 6, 3 -- 6 is what we call an offset

-- TASK 
-- GET THE TOP 3  LOYAL CUSTOMERS
-- ORDER BY points DESC
-- LIMIT 3

-- INNER JOIN clause to join 2 diferent columns 
-- SELECT *
/*
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c
     ON o.customer_id = c.customer_id
 */
 -- TASK
 /* SELECT *
 SELECT order_id, oi.product_id, quantity, oi.unit_price
 FROM order_items oi
 JOIN products p ON oi.product_id = p.product_id
*/

-- JOINING table accross multiple DATABASES
/*
SELECT *
FROM order_items oi
JOIN sql_inventory.products p 
ON oi.product_id = p.product_id
*/

/*
-- if we were to use sql_inventory database
USE sql_inventory;
SELECT *
FROM sql_store.order_items oi
JOIN products p ON oi.product_id = p.product_id
*/

-- SELF JOIN (join 2 tables)
/*
USE sql_hr;
-- SELECT *
SELECT 
e.employee_id,
e.first_name,
m.first_name AS manager
FROM employees e
JOIN employees m ON e.reports_to = m.employee_id
*/

/* JOINING MULTIPLE TABLES

USE sql_store;

-- SELECT *
SELECT 
o.order_id,
o.order_date,
c.first_name,
c.last_name,
os.name AS status

FROM orders o 
JOIN customers c 
     ON o.customer_id = c.customer_id
    
    -- OR USE BELOW QUERY
Implicit Join Syntax
SELECT *
FROM orders o, customers c 
WHERE o.customer_id = c.customer_id
     
     
JOIN order_statuses os
     ON o.status = os.order_status_id
*/

/* TASK ON JOINING MULTIPLE TABLE
USE sql_invoicing;
-- SELECT *
 SELECT
 p.date,
 p.invoice_id,
 p.amount,
 c.name,
 pm.name AS payment_mode

FROM payments p 
JOIN clients c
     ON p.client_id = c.client_id
JOIN payment_methods pm
     ON p.payment_method = pm.payment_method_id
*/

/*
-- compound join condition
-- USE sql_store;
-- SELECT *
SELECT
oi.order_Id,
oi.product_id,
oi.unit_price,
oin.note_id,
oin.note
FROM order_items oi
JOIN order_item_notes oin
     ON oi.order_id = oin.order_Id
     AND oi.product_id = oin.product_id
*/

-- outer join and we have two type of LEFT AND RIGHT

SELECT  *
  # c.customer_id,
  # c.first_name,
  # o.order_id
FROM customers c 
RIGHT JOIN orders o  -- IF u are doing right or left join it mean u are on OUTER JOIN
-- only JOIN is INNER JOIN
     ON c.customer_id = o.customer_id;
    # ORDER BY c.customer_id -- ORDER BY here means we are sorting the result of customer_id

-- TASK ON OUTER JOIN

/*
SELECT
p.product_id,
p.name,
oi.quantity

FROM products p 
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
 ORDER BY p.product_id
*/
 
 -- OUTER JOIN BETWEEN MULTIPLE TABLE
 /*
 SELECT  
  c.customer_id,

   c.first_name,
   sh.name AS shipper
FROM customers c 
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
LEFT JOIN shippers sh 
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id
*/


-- TASK ON MULTIPLE COLUMNS WITH OUTER JOINING
/*
SELECT
o.order_date,
o.order_id,  
c.first_name,
sh.name AS shipper,
os.name AS status

FROM customers c 
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
LEFT JOIN shippers sh 
	ON o.shipper_id = sh.shipper_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY order_date
*/

/*
SELECT 
o.order_id,
o.order_date,
c.first_name AS customer,
sh.name AS shipper,
os.name AS status
FROM orders o 
JOIN customers c 
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh 
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY order_id
*/
/*

-- SELF OUTER JOIN
USE sql_hr;

SELECT 
e.employee_id,
e.first_name,
m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id
*/
/*
-- The USING clause
SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o 
JOIN customers c 
	-- ON o.customer_id = c.customer_id
    USING (customer_id)
LEFT JOIN shippers sh 
	USING (shipper_id)
*/
-- 2 task on USING keyword
/*
SELECT *
FROM order_items oi
 LEFT JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_Id AND
		-- oi.product_id = oin.product_id
USING (order_id,product_id)
*/

/*
SELECT 
p.date,
c.name AS client,
p.amount,
pm.name AS payment_method
FROM payments p 
JOIN clients c 
	USING (client_id)
 JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
*/	
/*
-- NATURAL JOIN not recommend to use
SELECT
o.order_id,
c.first_name
FROM orders o 
NATURAL JOIN customers c 
*/

/*
-- CROSS JOIN
SELECT 
	c.first_name AS customer,
    p.name AS product
-- FROM customers c     
FROM customers c, products p  -- this implicit syntax query
-- CROSS JOIN products p   -- explicit syntax cross join
ORDER BY c.first_name
*/
/* task on cross join
SELECT 
sh.name AS shipper,
sh.shipper_id,
p.name AS product
-- FROM shippers sh, products p -- this implicit cross join
FROM shippers sh -- this explicit cross join
CROSS JOIN products p 
ORDER BY sh.name
*/

-- UNION OPERATOR
/*
SELECT 
order_id,
order_date,
'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT 
order_id,
order_date,
'Archive' AS status
FROM orders
WHERE order_date < '2019-01-01'
*/

/*
-- SECOND TASK ON UNION
SELECT first_name
FROM customers
UNION
SELECT name 
FROM shippers
*/
/*
SELECT first_name
FROM archived_orders
UNION
SELECT name 
FROM orders
*/

/*
 UNION TASK
SELECT 
customer_id,
first_name,
points,
'Bronze' AS Type
FROM customers
WHERE points < 2000
UNION
SELECT
customer_id,
first_name,
points,
'Silver' AS Type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
customer_id,
first_name,
points,
'Gold' AS Type
FROM customers
WHERE points > 3000
ORDER BY first_name
*/

-- COLUMN ATTRIBUTE: TO INSERT, UPDATE, AND DELETE DATA
-- inserting a single row into a customers table
-- 6 columns with a single row 
/*
INSERT INTO customers
(last_name,
first_name,
birth_date,
address,
city,
state)
VALUES (
	'Smith',
    'John',
    '1990-01-01',
    'address',
    'city',
    'CA')
*/
/*
INSERT INTO shippers (name) -- three rows with one column
VALUES ('shippers1'),
	   ('Shippers2'),
       ('Shippers3')
   */    
-- TASK Insert three rows in the products table
-- three columns with three rows
/*
INSERT INTO products 
(
name,
quantity_in_stock,
unit_price
)
VALUES
 ('product1', 10, 1.45),
 ('product2', 17, 2.78),
 ('product3', 23, 34.0)
*/

-- INSERT DATA INTO MULTIPLE TABLE ()hirarachy)
/*
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.95),
    (LAST_INSERT_ID(), 2, 1, 3.95)
 */
 
 -- CREATING A COPY IN A TABLE
 -- TO COPY A DATA FROM ONE TABLE TO ANOTHER

/* CREATE TABLE orders_archived AS
 SELECT * FROM orders   -- this is subquery
 */
 
 /*
 INSERT INTO orders_archived -- INSERT STATEMENT
 SELECT *                -- SELECT QUERY
 FROM orders 
 WHERE order_date < '2019-01-01'
*/

-- TASK ON INVOICES & CLIENTS TABLE
/*
CREATE TABLE invoices_archived AS -- sub query
SELECT 
i.invoice_id,
i.number,
c.name AS client,
i.invoice_total,
i.payment_total,
i.invoice_date,
i.payment_date,
i.due_date

FROM invoices i
 JOIN clients c 
	USING (client_id)
WHERE payment_date IS NOT NULL
*/

-- UPDATING A SINGLE ROW IN A DATABASE USING UPDATE
/*
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice_id = 1
*/

/*
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date    
SELECT *
FROM invoices
WHERE payment_date IS NULL
*/
/*
WHERE client_id IN 
			(SELECT client_id    
			FROM clients
			WHERE state IN ('CA', 'NY'))  -- this is a subquery to an update statement invoices
	-- subquery is select statement that is within SQL
  */


/*
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN (3, 4, 5, 1)
*/

/*
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01'
*/

-- HOW TO USE SUB QUERY IN AN UPDATE STATEMENT
-- when id of a client is missing and we are only given name
-- TASK ON ORDERS TABLE IN UPDATING COMMENTS
/*
UPDATE orders
SET comments = 'Gold customer'
WHERE customer_id IN

				(SELECT customer_id
				FROM customers
				WHERE points > 3000)	
	*/
   /* 
    -- DELETING ROW/DATA
    DELETE FROM invoices 
    WHERE client_id = (
   
				   SELECT *
					FROM clients
					WHERE name = 'Myworks'
				   ) 
    
*/
SELECT first_name, last_name
FROM customers
UNION
SELECT shipped_date, shipper_id
FROM orders;
SELECT LENGTH('skyfall');

SELECT first_name, LENGTH(first_name)
FROM customers
ORDER BY 2;
SELECT UPPER ('sky');
SELECT LOWER ('bowl');
SELECT LTRIM('    sky    ')

