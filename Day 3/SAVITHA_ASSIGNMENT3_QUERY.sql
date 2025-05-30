SELECT * FROM CATEGORIES 
select * from shippers
select * from products

-- 1)      Update the categoryName From “Beverages” to "Drinks" in the categories table.

UPDATE CATEGORIES
SET CATEGORY_NAME = 'DRINKS'
WHERE CATEGORY_NAME = 'Beverages'

--2)      Insert into shipper new record (give any values) Delete that new record from shippers table.

insert into shippers (shipper_id,company_name,phone)
values (7,'USPS','328-440-8403')

delete from shippers
where shipper_id = 7

--Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too. 
--Display the both category and products table to show the cascade.

ALTER TABLE products
DROP CONSTRAINT IF EXISTS fk_categories;
ALTER TABLE products
DROP CONSTRAINT fk_products_categories;

ALTER TABLE products
ADD CONSTRAINT fk_categories
FOREIGN KEY (category_ID)
REFERENCES categories(category_ID)
ON UPDATE CASCADE;

UPDATE categories
SET category_ID = 1001
WHERE category_ID = 1;

select * 
from categories 
where category_id = 1001.

select * 
from products 


 --Delete the categoryID= “3”  from categories. 
 --Verify that the corresponding records are deleted automatically from products.

 ALTER TABLE products
DROP CONSTRAINT fk_category;
 
ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (category_id)
REFERENCES categories(category_id)
ON DELETE CASCADE;


delete from categories 
where category_id = 3

ALTER TABLE order_details
DROP CONSTRAINT fk_order_details_products;

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_products
FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE CASCADE;


select * from categories
select * from products
select * from order_details order by product_id asc

--Delete the customer = “VINET”  from customers. 
--Corresponding customers in orders table should be set to null

alter table orders 
drop constraint if exists fk_orders_customers

alter table orders
add constraint fk_orders_customers
foreign key (customer_id)
references customers(customer_id)
on delete set null

select * from customers
select * from orders  -- where customer_id = 'VINET'

delete from customers
where customer_id = 'VINET'

/* 5. Insert the following data to Products using UPSERT:
product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=5
product_id = 101, product_name = White bread, quantityperunit=5 boxes,unitprice = 13, discontinued = 0, categoryID=5
product_id = 100, product_name = Wheat bread, quantityperunit=10 boxes,unitprice = 13, discontinued = 0, categoryID=5
(this should update the quantityperunit for product_id = 100)*/

SELECT * FROM PRODUCTS WHERE PRODUCT_ID = 100

--INSERT PRODUCT ID 100

INSERT INTO products (product_id, product_name, quantity_per_unit, unit_price, discontinued, category_ID)
VALUES (100, 'White bread', '1 boxes', 13, 0, 5)
ON CONFLICT (product_id)
DO NOTHING;

--INSERT PRODUCT ID 101

INSERT INTO products (product_id, product_name, quantity_per_unit, unit_price, discontinued, category_ID)
VALUES (101, 'White bread', '5 boxes', 13, 0, 5)
ON CONFLICT (product_id)
DO NOTHING;

--UPDATE QUANTITY PER UNIT FOR PRODUCT ID 100

INSERT INTO products (product_id, product_name, quantity_per_unit, unit_price, discontinued, category_ID)
VALUES (100, 'Wheat bread', '10 boxes', 13, 0, 5)
ON CONFLICT (product_id)
DO UPDATE SET quantity_per_unit = EXCLUDED.quantity_per_unit;


 -- 6 Create temp table with name:  ‘updated_products’ and insert values as below:

 CREATE TEMP TABLE updated_products (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    quantityperunit TEXT,
    unitprice NUMERIC,
    discontinued INT,
    categoryid INT
);

INSERT INTO updated_products (product_id, product_name, quantityperunit, unitprice, discontinued, categoryid)
VALUES 
(100, 'Wheat bread', '10', 20, 1, 5),
(101, 'White bread', '5 boxes', 19.99, 0, 5),
(102, 'Midnight Mango Fizz', '24 - 12 oz bottles', 19, 0, 1),
(103, 'Savory Fire Sauce', '12 - 550 ml bottles', 10, 0, 2);

-- Update the price and discontinued status for from below table ‘updated_products’ only 
--if there are matching products and updated_products .discontinued =0 

SELECT * FROM PRODUCTS

	UPDATE products p
SET unit_price = u.unitprice,
    discontinued = u.discontinued
FROM updated_products u
WHERE p.product_id = u.product_id
  AND u.discontinued = 0;


--If there are matching products and updated_products .discontinued =1 then delete 

DELETE FROM products p
USING updated_products u
WHERE p.product_id = u.product_id
  AND u.discontinued = 1;
 
 --Insert any new products from updated_products that don’t exist in products 
 --only if updated_products .discontinued =0.

 INSERT INTO categories (category_id, category_name)
VALUES (1, 'USPS');

INSERT INTO products (product_id, product_name, quantity_per_unit, unit_price, discontinued, category_id)
SELECT u.product_id, u.product_name, u.quantityperunit, u.unitprice, u.discontinued, u.categoryid
FROM updated_products u
LEFT JOIN products p ON u.product_id = p.product_id
WHERE p.product_id IS NULL
  AND u.discontinued = 0;



  --7 7)      List all orders with employee full names. (Inner join)


  SELECT *  FROM EMPLOYEES
  SELECT * FROM ORDERS


  SELECT O.ORDER_ID , O.ORDER_DATE , O.SHIP_ADDRESS,
    E.FIRST_NAME || ''|| E.LAST_NAME AS EMPLOYEE_FULLNAME 
	FROM ORDERS O
	INNER JOIN EMPLOYEES E  ON O.EMPLOYEE_ID = E.EMPLOYEE_ID
  













