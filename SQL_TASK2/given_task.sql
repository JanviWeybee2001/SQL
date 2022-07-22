use amazon;

CREATE TABLE module_master (
id INTEGER PRIMARY KEY IDENTITY(1,1),
module_name VARCHAR(10),
status VARCHAR(20) CHECK (status IN ('active','inactive')),
);

CREATE TABLE customer (
id INTEGER PRIMARY KEY IDENTITY(1,1),
first_name VARCHAR(10),
last_name VARCHAR(10),
status VARCHAR(20) CHECK (status IN ('active','inactive')),
);

CREATE TABLE vendor (
id INTEGER PRIMARY KEY IDENTITY(1,1),
first_name VARCHAR(10),
last_name VARCHAR(10),
status VARCHAR(20) CHECK (status IN ('active','inactive')),
);

CREATE TABLE courier (
id INTEGER PRIMARY KEY IDENTITY(1,1),
first_name VARCHAR(10),
last_name VARCHAR(10),
status VARCHAR(20) CHECK (status IN ('active','inactive')),
);

CREATE TABLE sales_order (
id INTEGER PRIMARY KEY IDENTITY(1,1),
module_id INTEGER,
party_id INTEGER,
status VARCHAR(20) CHECK (status IN ('active','inactive')),
);

INSERT INTO module_master VALUES 
('customer', 'active'),
('vendor', 'active'),
('courier', 'active'),
('module_4', 'inactive'),
('module_5', 'inactive');



INSERT INTO customer VALUES
('janvi','desai','active'),
('nishita','kalayani','inactive'),
('hardi','goyani','active'),
('krishi','patel','active'),
('hemangi','niraml','inactive');


INSERT INTO vendor VALUES
('fenny','limbadiya','active'),
('akash','thoriya','active'),
('fatema','sadikot','inactive'),
('jhonty','dodecha','inactive'),
('nirmal','patel','active');


INSERT INTO courier VALUES
('courier','-001','active'),
('courier','-002','active'),
('courier','-003','active'),
('courier','-004','inactive'),
('courier','-005','active');


--drop table courier


INSERT INTO sales_order VALUES
(1,3,'active'),
(1,4,'active'),
(2,3,'inactive'),
(3,1,'inactive'),
(3,5,'active');


-- Given one row by set the @num's value
declare @query VARCHAR(500)
declare @num int = 2
select @query = 'select id, CONCAT(first_name,'' '', last_name) as NAME from ' + (SELECT M.module_name FROM sales_order AS S INNER JOIN module_master AS M ON S.module_id = M.id WHERE S.id= @num) 
+ CONCAT(' WHERE id =' , (SELECT party_id FROM sales_order where id = @num));
exec (@query)

-- Show DATA
SELECT * FROM customer;
SELECT * FROM courier;
SELECT * FROM vendor;
SELECT * FROM module_master;
SELECT * FROM sales_order;

-- Show the whole data table with name
SELECT S.id, M.module_name,S.party_id ,
CASE
 WHEN M.module_name = 'customer' THEN (SELECT first_name + ' ' + last_name FROM customer WHERE id = S.party_id)
 WHEN M.module_name = 'courier' THEN (SELECT first_name + ' ' + last_name FROM courier WHERE id = S.party_id)
 WHEN M.module_name = 'vendor' THEN (SELECT first_name + ' ' + last_name FROM vendor WHERE id = S.party_id)
END as full_name
FROM sales_order AS S INNER JOIN module_master AS M ON S.module_id = M.id;


-- Stored procedure
GO
CREATE PROCEDURE FULL_NAME @num int
as
declare @query VARCHAR(500)
select @query = 'select id , CONCAT(first_name,'' '', last_name) as NAME from ' + (SELECT M.module_name FROM sales_order AS S INNER JOIN module_master AS M ON S.module_id = M.id WHERE S.id= @num) 
+ CONCAT(' WHERE id =' , (SELECT party_id FROM sales_order where id = @num));
exec (@query);

EXECUTE FULL_NAME @num = 4;  
GO 

--DROP PROCEDURE FULL_NAME