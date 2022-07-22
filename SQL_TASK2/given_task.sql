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

SELECT * FROM module_master;


INSERT INTO customer VALUES
('janvi','desai','active'),
('nishita','kalayani','inactive'),
('hardi','goyani','active'),
('krishi','patel','active'),
('hemangi','niraml','inactive');

SELECT * FROM customer;

INSERT INTO vendor VALUES
('fenny','limbadiya','active'),
('akash','thoriya','active'),
('fatema','sadikot','inactive'),
('jhonty','dodecha','inactive'),
('nirmal','patel','active');

SELECT * FROM vendor;

INSERT INTO courier VALUES
('courier','-001','active'),
('courier','-002','active'),
('courier','-003','active'),
('courier','-004','inactive'),
('courier','-005','active');

SELECT * FROM courier;

--drop table courier


INSERT INTO sales_order VALUES
(1,3,'active'),
(1,4,'active'),
(2,3,'inactive'),
(3,1,'inactive'),
(3,5,'active');

SELECT * FROM sales_order;

SELECT sys.columns.name AS ColumnName
FROM sys.columns
JOIN sys.tables ON sys.columns.object_id = tables.object_id
WHERE
  tables.name = (SELECT M.module_name FROM sales_order AS S INNER JOIN module_master AS M ON S.module_id = M.module_id WHERE S.sales_order_id=1)


declare @query VARCHAR(500)
declare @num int = 1
select @query = 'select id, CONCAT(first_name,'' '', last_name) as NAME from ' + (SELECT M.module_name FROM sales_order AS S INNER JOIN module_master AS M ON S.module_id = M.id WHERE S.id= @num) + CONCAT(' WHERE id =' , (SELECT party_id FROM sales_order where id = @num));
exec (@query)