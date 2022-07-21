use w3schools;

select * from employees;

alter table employees drop column amp;

update employees set amp = 1 where EmployeeID = 2;

insert into employees (EmployeeID) values (11);

delete from employees where EmployeeID=11;

alter table employees add amp int;

alter table employees alter column amp varchar;

ALTER TABLE employees
ADD UNIQUE (FirstName);

update employees set FirstName = 'Janvi1' where EmployeeID = 3;