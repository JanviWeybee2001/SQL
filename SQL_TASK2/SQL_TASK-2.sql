CREATE DATABASE task;

USE task;

CREATE TABLE JOBS (
JOB_ID INTEGER PRIMARY KEY IDENTITY(1,1),
JOB_TITLE NVARCHAR(20) NOT NULL,
MIN_SALARY NUMERIC,
MAX_SALRY NUMERIC,
);

CREATE TABLE  DEPARTMENTS(
DEPARTMENT_ID INTEGER PRIMARY KEY IDENTITY(1,1),
DEPARTMENT_NAME NVARCHAR(30) NOT NULL,
MANAGER_ID INTEGER UNIQUE,
LOCATION_ID INTEGER,
);

CREATE TABLE EMPLOYEES (
EMPLOYEE_ID INTEGER PRIMARY KEY IDENTITY(1,1),
FIRST_NAME NVARCHAR(20) NOT NULL,
LAST_NAME NVARCHAR(20),
EMAIL NVARCHAR(20),
PHONE_NUMBER NUMERIC,
HIRE_DATE DATE DEFAULT GETDATE(),
JOB_ID INTEGER FOREIGN KEY REFERENCES JOBS(JOB_ID),
SALARY NUMERIC,
COMMISSION_PCT FLOAT,
MANAGER_ID INTEGER,
DEPARTMENT_ID INTEGER FOREIGN KEY REFERENCES DEPARTMENTS(DEPARTMENT_ID),
);

ALTER TABLE JOBS ALTER COLUMN JOB_TITLE NVARCHAR(40);

INSERT INTO JOBS VALUES 
('Project Manager', 35000, 50000),
('UX Designer & UI Developer', 25000, 40000),
('Content Writer', 30000, 50000),
('Web Developer', 50000, 75000),
('BDE', 20000, 40000),
('Chartered Accountant', 50000, 75000);



INSERT INTO DEPARTMENTS VALUES 
('Research and development', 1, 361500),
('Administration', 2, 371600),
('Marketing', 3, 331700),
('Computer',4, 361800),
('Finance', 5, 371900),
('IT', 6, 332000);

INSERT INTO DEPARTMENTS (DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID) VALUES ('Forensic', 700, 332001);
UPDATE DEPARTMENTS SET MANAGER_ID = 7 WHERE MANAGER_ID = 700;


INSERT INTO EMPLOYEES VALUES 
('Julius', 'Caesar', 'juluis@gmail.com', 9876543210, '1991-11-18', 1, 40000, 0.20, 100, 1),
('Nick','Jonas','nick@gmail.com', 9876987600 ,'1991-05-01', 2, 35000 , 0.10, 200 , 2),
('Alia','Bhatt','alia@gmail.com', 5432154321 ,'1991-06-09', 3, 45000 , 0.15, 300 , 3),
('Katrina','Kaif','katrina@gmail.com', 9887743210 ,'1991-04-02', 4, 60000 , 0.12, 400 , 4),
('Vicky','Kaushal','vicky@gmail.com', 9876332210 ,'1997-04-19', 5, 25000 , 0.18, 500 , 5),
('Anushka','Sharma','anushka@gmail.com', 9875463210 ,'1990-12-18', 6, 70000 , 0.09, 600 , 6),
('Virat','Kohli','virat@gmail.com', 9876543012,'1992-01-23', 1, 33000 , 0.22, 100 , 1),
('Deepika','Padukone','deepika@gmail.com', 7896543210 ,'1991-12-03', 2, 37000 , 0.14, 200 , 2),
('Ranveer','Singh','ranveer@gmail.com', 9876543771 ,'1997-05-23', 3, 42000 , 0.11, 300 , 3),
('Ranbir','Kapoor','ranbir@gmail.com', 9988043210 ,'1991-09-08', 4, 58000 , 0.16, 400 , 4),
('Virat','Patel','viratpatel@gmail.com', 9887543012,'1993-01-23', 1, 33000 , 0.22, 600 , 6),
('Nishita','Kalyani','nishita@gmail.com', 7896357210 ,'1997-12-03', 2, 67000 , 0.14, 500 , 5),
('Janvi','Desai','janvi@gmail.com', 9834543771 ,'1994-05-23', 5, 82000 , 0.11, 300 , 3),
('Hardi','Patel','hardi@gmail.com', 9934543210 ,'1998-09-08', 6, 78000 , 0.16, 400 , 4);


INSERT INTO EMPLOYEES VALUES ('Fenny','Limbadiya','FENNY@gmail.com', 9921343210 ,'1997-10-18', 5, 98000 , 0.36, 400 , 4);

SELECT * FROM JOBS;
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;

UPDATE EMPLOYEES SET MANAGER_ID = 1 WHERE MANAGER_ID = 100;
UPDATE EMPLOYEES SET MANAGER_ID = 2 WHERE MANAGER_ID = 200;
UPDATE EMPLOYEES SET MANAGER_ID = 3 WHERE MANAGER_ID = 300;
UPDATE EMPLOYEES SET MANAGER_ID = 4 WHERE MANAGER_ID = 400;
UPDATE EMPLOYEES SET MANAGER_ID = 5 WHERE MANAGER_ID = 500;
UPDATE EMPLOYEES SET MANAGER_ID = 6 WHERE MANAGER_ID = 600;

--DROP TABLE EMPLOYEES;
--DROP TABLE DEPARTMENTS;
--DROP TABLE JOBS;

DELETE FROM DEPARTMENTS WHERE MANAGER_ID = 7;


--1. Given SQL query will execute successfully: TRUE/FALSE SELECT last_name, job_id, salary AS Sal FROM employees;
SELECT LAST_NAME, JOB_ID, SALARY AS Sal FROM EMPLOYEES;

--2. Identity errors in the following statement: SELECT employee_id, last_name, sal*12 ANNUAL SALARY FROM employees;
SELECT EMPLOYEE_ID, LAST_NAME, (SALARY*12) AS [ANNUAL SALARY] FROM EMPLOYEES;

--3. Write a query to determine the structure of the table 'DEPARTMENTS'
EXEC SP_HELP DEPARTMENTS;

--4. Write a query to determine the unique Job IDs from the EMPLOYEES table.
SELECT DISTINCT JOB_ID FROM EMPLOYEES;

--5. Write a query to display the employee number, lastname, salary (oldsalary), salary increased by 15.5% name it has NewSalary and subtract the (NewSalary from OldSalary) name the column as Increment.
SELECT EMPLOYEE_ID, LAST_NAME, SALARY AS [OLD SALARY], (SALARY + SALARY*(15.5/100)) AS [NEW SALARY], SALARY*(15.5/100) AS INCREMENT FROM EMPLOYEES;

--6. Write a query to display the minimum, maximum, sum and average salary for each job type.
SELECT JOB_ID, MIN(SALARY) AS [MIN SALARY], MAX(SALARY) AS [MAX SALARY], SUM(SALARY) AS [TOTAL SALARY], AVG(SALARY) AS [AVG SALARY] FROM EMPLOYEES GROUP BY JOB_ID;

--7. The HR department needs to find the names and hire dates of all employees who were hired before their managers, along with their managers’ names and hire dates.
SELECT A.FIRST_NAME + ' ' + A.LAST_NAME AS [EMPLOYEE NAME], A.HIRE_DATE, B.FIRST_NAME + ' ' + B.LAST_NAME AS [MANAGER NAME], B.HIRE_DATE 
FROM EMPLOYEES A, EMPLOYEES B 
WHERE A.EMPLOYEE_ID <> B.EMPLOYEE_ID
AND A.MANAGER_ID = B.EMPLOYEE_ID
AND A.HIRE_DATE > B.HIRE_DATE;

--8. Create a report for the HR department that displays employee last names, department numbers, and all the employees who work in the same department as a given employee.
SELECT EMPLOYEES.LAST_NAME, DEPARTMENTS.DEPARTMENT_NAME FROM EMPLOYEES INNER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

--9. Find the highest, lowest, sum, and average salary of all employees. Label the columns Maximum, Minimum, Sum, and Average, respectively. Round your results to the nearest whole number.
SELECT MIN(SALARY) AS Minimum, MAX(SALARY) AS Maximum, SUM(SALARY) AS Sum, AVG(SALARY) AS Average FROM EMPLOYEES

--10. Create a report that displays list of employees whose salary is more than the salary of any employee from department 6.
SELECT FIRST_NAME + ' ' + LAST_NAME AS EMPLOYEE_NAME FROM EMPLOYEES WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 6);

--11. Create a report that displays last name and salary of every employee who reports to King(Use any manager name instead of King)
SELECT LAST_NAME, SALARY FROM EMPLOYEES WHERE MANAGER_ID = 4 AND EMPLOYEE_ID != 4;

--12. Write a query to display the list of department IDs for departments that do not contain the job Id ST_CLERK(Add this job ST_CLERK to Job table). Use SET Operator for this query
UPDATE JOBS SET JOB_TITLE = 'ST_CLERK' WHERE JOB_ID = 2;
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID <> (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = 'ST_CLERK');

--13. Write a query to display the list of employees who work in department 5 and 6. Show employee Id, job Id and department Id by using set operators. - Add 5 and 8 department Id to department table
INSERT INTO DEPARTMENTS VALUES ('Designing',50000,90000);
INSERT INTO DEPARTMENTS VALUES ('Data Science',55000,80000);

SELECT EMPLOYEE_ID, JOB_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID = 5 
UNION 
SELECT EMPLOYEE_ID, JOB_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID = 6;














