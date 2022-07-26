use amazon;

CREATE TABLE CUSTOMERS (
CUSTMER_ID INTEGER PRIMARY KEY IDENTITY(1,1),
FIRST_NAME NVARCHAR(20) NOT NULL,
LAST_NAME NVARCHAR(20),
BIRTH_DATE DATE DEFAULT '2001-11-20',
PHONE NUMERIC,
ADDRESS NVARCHAR(20),
CITY NVARCHAR(20),
STATE NVARCHAR(20),
);

INSERT INTO CUSTOMERS VALUES ('Dipika', 'patel', '2003-09-28', 9864823574, 'narayan nagar','rajkot', 'gujrat');
INSERT INTO CUSTOMERS VALUES ('Shreya', 'kanani', '1997-02-08', 9824223574, 'gurukrupa nagar','udaypur', 'gujrat');
INSERT INTO CUSTOMERS VALUES ('Mytri', 'patel', '2002-03-18', 9864483574, 'lkhshmi','amreli', 'gujrat');
INSERT INTO CUSTOMERS VALUES ('Selja', 'ramani', '2001-12-12', 9424223574, 'mauva','mumbai', 'maharastra');

SELECT * FROM CUSTOMERS;

CREATE TABLE PRODUCT (
PRODUCT_ID INTEGER PRIMARY KEY IDENTITY(1,1),
PRODUCT_NAME NVARCHAR(20) NOT NULL,
UNIT_PRICE NUMERIC,
);

INSERT INTO PRODUCT VALUES ('MAKE-UP', 550.09);
INSERT INTO PRODUCT VALUES ('LIPSTIC', 943.50);

SELECT * FROM PRODUCT;

CREATE TABLE SHIPPING (
SHIPPER_ID INTEGER PRIMARY KEY IDENTITY(1,1),
SHIPPER_NAME NVARCHAR(20) NOT NULL,
);

INSERT INTO SHIPPING VALUES ('RANBEER');
INSERT INTO SHIPPING VALUES ('KARAN');

SELECT * FROM SHIPPING;

CREATE TABLE ORDERS (
ORDER_ID INTEGER PRIMARY KEY IDENTITY(1,1),
CUSTMER_ID INTEGER FOREIGN KEY REFERENCES CUSTOMERS(CUSTMER_ID),
ORDER_DATE DATE DEFAULT GETDATE(),
STATUS NVARCHAR(20) CHECK (STATUS IN ('PENDING','IN-PROGRESS','SHIPPED')),
COMMENTS NVARCHAR(30),
SHIPPED_DATE DATE DEFAULT GETDATE()+2,
SHIPPER_ID INTEGER FOREIGN KEY REFERENCES SHIPPING(SHIPPER_ID),
);


INSERT INTO ORDERS VALUES (1, '2013-11-23', 'PENDING', '', '2013-12-01', 1);
INSERT INTO ORDERS(CUSTMER_ID,ORDER_DATE,STATUS,COMMENTS,SHIPPED_DATE,SHIPPER_ID) VALUES (2, '2022-06-13', 'IN-PROGRESS','','2022-08-08', 1);
INSERT INTO ORDERS(CUSTMER_ID,ORDER_DATE,STATUS,COMMENTS,SHIPPER_ID) VALUES (2, '2012-06-03', 'IN-PROGRESS', '', 2);
INSERT INTO ORDERS VALUES (1, '2003-10-03', 'SHIPPED', 'NICE', '2003-10-07', 2);
INSERT INTO ORDERS VALUES (1, '2021-10-03', 'SHIPPED', 'VERY NICE', '2021-10-17', 1);

SELECT * FROM ORDERS;

CREATE TABLE ORDER_ITEM (
ORDER_ITEM_ID INTEGER PRIMARY KEY IDENTITY(1,1),
ORDER_ID INTEGER FOREIGN KEY REFERENCES ORDERS(ORDER_ID),
PRODUCT_ID INTEGER  FOREIGN KEY REFERENCES PRODUCT(PRODUCT_ID),
QUANTITY INTEGER,
UNIT_PRICE NUMERIC,
);

INSERT INTO ORDER_ITEM VALUES (1,1,3,225);
INSERT INTO ORDER_ITEM VALUES (2,2,1,500);
INSERT INTO ORDER_ITEM VALUES (2,2,4,327);
INSERT INTO ORDER_ITEM VALUES (3,2,6,124);
INSERT INTO ORDER_ITEM VALUES (4,1,2,657);

SELECT * FROM ORDER_ITEM;

--DROP TABLE CUSTOMERS
--DROP TABLE ORDER_ITEM
--DROP TABLE ORDERS
--DROP TABLE PRODUCT
--DROP TABLE SHIPPING


SELECT * FROM ORDER_ITEM WHERE (UNIT_PRICE*QUANTITY) > (SELECT AVG(UNIT_PRICE*QUANTITY) FROM ORDER_ITEM);

SELECT *,(UNIT_PRICE*QUANTITY) AS TOTAL_PRICE FROM ORDER_ITEM WHERE ORDER_ID = 2 ORDER BY (UNIT_PRICE*QUANTITY) DESC;

SELECT FIRST_NAME + ' ' + LAST_NAME AS CUSTOMER_NAME FROM CUSTOMERS;

SELECT OI.ORDER_ITEM_ID, OI.ORDER_ID, C.FIRST_NAME + ' ' + C.LAST_NAME AS CUSTOMER_NAME, P.PRODUCT_NAME, S.SHIPPER_NAME, O.STATUS
FROM ((((
(ORDER_ITEM AS OI INNER JOIN ORDERS AS O ON OI.ORDER_ID = O.ORDER_ID)    
LEFT JOIN CUSTOMERS AS C ON C.CUSTMER_ID = O.CUSTMER_ID)
INNER JOIN SHIPPING AS S ON O.SHIPPER_ID = S.SHIPPER_ID))
INNER JOIN PRODUCT AS P ON OI.PRODUCT_ID = P.PRODUCT_ID)

SELECT * FROM CUSTOMERS WHERE FIRST_NAME LIKE IN ('My%','%Se%')


