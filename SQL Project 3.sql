show databases;
drop database if exists DBEx1;
create database DBEx1; # Create the database named DBEx1
show databases;
use DBEx1; -- Use the database DBEx1 we just created
show tables;
drop table if exists employees;
create table Employees(LName varchar(20), IDN int, Salary decimal(20, 2),
Deduction decimal(20, 2));
describe employees;
insert into Employees values ('Peter', 1, 1000, 10), ('Mary', 12, 2000, 0),
('Tony', 22, 4000, 32), ('Mike', 17, 4000, 10), ('John', 93, null, null);
select * from employees;
drop table if exists IRAs;
create table IRAs(IDN int, IRA_acct varchar(12), Balance decimal(20, 2));
describe iras;
insert into IRAs values(1, 'A1', 100), (22, 'A2', 200), (22, 'A3', 400), (93, 'A4', 500);
select * from iras;
drop table if exists addresscity;
create table AddressCity(IDN int, CompanyCity varchar(22), HomeCity varchar(22) );
describe addresscity;
insert into addresscity values (1, 'Saint Louis', 'Saint Louis'), (12, 'Saint Louis',
'Chesterfield'),
(22, 'Chesterfield', 'Saint Louis'), (93, 'Chesterfield', 'Chesterfield'), (17, 'Fenton',
'Fenton');
select * from addresscity;
select * from employees;
select * from iras;
select * from addresscity;

/* Part A: How to Code Summary Queries */

#Example A1: Use one table IRAs
select IDN, Sum(balance) as TotalBalance, count(IRA_Acct) as NumAccts from iras group by IDN;

#Example A2: Use two tables Employees and IRAs:
select LName, Sum(balance) as TotalBalance, count(IRA_Acct) as NumAccts from employees e,
iras i where e.IDN = i.IDN group by LName, e.IDN;

select LName, Sum(balance) as TotalBalance, count(IRA_Acct) as NumAccts
from Employees e left join IRAs i on e.IDN = i.IDN group by LName, i.IDN;

#Example A3: Write a query statement to find the total amount of IRA balance, total number of 
#            IRA accounts, maximal balance, minimal balance, and average balance of all ira accounts. 
select sum(balance) as TotalB, count(IRA_acct) as NumAccts, max(balance) as MaxB, min(Balance) as MinB,
avg(Balance) as AverageB from IRAs;

/* Example A4: Write a query statement to find the last name, total amount of IRA balance, total
number of IRA accounts, maximal balance, minimal balance, and average balance of each
people. Similar to Example A2. Summary Query for each people. */
select LName, sum(balance) as TotalB, count(IRA_acct) as NumAccts, max(balance) as MaxB,
min(Balance) as MinB, avg(Balance) as AverageB from Employees e, IRAs i where e.idn = i.idn
group by LName, e.idn;

/*Example A5: Write a query statement to find the total amount of IRA balance, total number of
IRA accounts, maximal balance, minimal balance, and average balance of all people who live in
each city. Summary Query for all people in each city.*/
select homecity, sum(balance) as TotalB, count(IRA_acct) as TotalAccts, max(balance) as MaxB,
min(Balance) as MinB, round(avg(Balance),2) as AverageB from addresscity a, IRAs i where a.idn = i.idn
group by homecity;

/* Part B: Using summary queires in coding subqueries */

#Example B1a: Write a query to find the average salary of all empolyees.

select avg(salary) from employees;
select avg(salary) from employees where salary is not null;

#Example B1b: Write a query to find the last name and salary of all employees with above average salary.

select LName, Salary from employees where salary >(select avg(salary) from employees);

/* Example B1c: Write a query to find the last name, salary, and total balance of each
employee with at least $2000 salary and above average ira balance. */

select LName, salary, sum(Balance) as TotalB 
from employees e, iras i 
where e.idn=i.idn and salary >=2000 
group by LName, salary 
having TotalB > (select avg(balance) from iras);

/* Example B2a1: Write a query statement to find the IDN number, total amount of IRA balance,
total number of IRA accounts, maximal balance, minimal balance, and average balance of each
people. */

select idn, sum(balance) as TotalB, count(IRA_acct) as TotalAccts, max(balance) as MaxB, min(balance) as MinB,
avg(balance) as AverageB from IRAs group by idn;

#Example B2a2: Write a query statement to find the average balance of all people.

select avg(t1.TotalB) as averageBalance
from (select idn, sum(balance) as TotalB, count(IRA_acct) as TotalAccts, max(balance) as MaxB, min(balance) as MinB,
avg(balance) as AverageB from IRAs group by idn) as t1;
#or
select sum(balance)/count(distinct IDN) as averageBalance from iras;

/* Example B3: Write a query to find the names of employees with at least one acct balance above
$200. */
select LName
from employees e
where IDN in (select IDN from IRAs where balance > 200);

#Example B4: Write a query to find the name of employee with the largest acct balance.
select LName, balance
from employees e, iras i
where e.IDN = i.IDN and balance >= (select max(balance) from iras);

/* Example B4a: Write a query to find the name of employee with the largest total acct balance
and the number of IRA accounts. */
select LName, TotalB, NumAccts
from
		(select idn, sum(balance) as TotalB, count(IRA_acct) as NumAccts
        from IRAS 
        group by idn)
        as t1,
        employees e
where e.idn = t1.idn and TotalB >= 
		(select max(TotalB2)
        from (select sum(balance) as TotalB2 from IRAS
        group by idn)t2);
#or use having clause
select LName, TotalB, NumAccts
from
	(select idn, sum(balance) as TotalB, count(IRA_acct) as NumAccts
	from IRAs group by idn) as t1,
	employees e
where e.idn = t1.idn
having TotalB >=
	(select max(TotalB2)
	from (select sum(balance) as TotalB2 from IRAs group by idn) t2);

/* Example B5: Write a query to find the idn, last name, and salary of employees who have ira
accounts. */
select idn, lname, salary from employees
where idn in (select idn from iras);

#Example B6: Queries using the key words any and all. 
select idn, salary from employees where salary > any (select salary from employees);

select idn, balance from iras where balance >= all (select balance from iras);

#Example B7: Write a query to find the largest salary paid to employees working in each city.
select companycity, max(salary) as MaxS 
from employees e, addresscity a 
where e.idn=a.idn
group by companycity;

#Alternative B7: Write query to find average salary paid to employees working in each city.
select companycity, avg(salary) as AverageSalary
from employees e, addresscity a
where e.idn = a.idn
group by companycity;

/* Example B8: Write a query to find the last name, IDN, salary, and companycity of the
employees who have the largest salary among all employees working in each city. */
select LName, e.IDN, Salary, a.CompanyCity
from employees e, addresscity a,
	(select companycity, max(salary) as MaxS
    from employees e, addresscity a 
    where e.idn = a.idn
    group by companycity)t1
where e.idn = a.idn and a.CompanyCity = t1.CompanyCity and salary = MaxS;

#Week 4 Knowledge Check
 /*Write a query statement to find the total amount of IRA balance and the 
maximal balance of all people who live in each city. 
Summary Query for all people in each city. */
select homecity, sum(Balance) as TotalBalance, max(balance) as MaximalBalance
from addresscity a, IRAs i
where a.idn = i.idn
group by homecity;

/* Write a query to find the last name and total balance of 
each employee with above average ira balance. */
select LName, sum(Balance) as TotalBalance
from  employees e, iras i
where e.IDN = i.idn
group by LName 
having TotalBalance > (select avg(balance) from iras);

/* Write a query to find the last name and total balance of 
the employee with the maximal total ira balance. */
select LName, sum(balance) as TotalBalance
from employees e, iras i
where e.idn = i.idn and balance >=all(select (balance) from iras)
group by LName;

#MySQL Test 2

/* Write a query to create a table named Table2 containing the records of those 
accounts with a balance of at least $280. */
create table Table2
select LName, sum(Balance) as TotalBalance
from employees e, iras i
where e.idn = i.idn and balance >= 280
group by LName;

/* Write a query to insert the records of all IRA accounts (with a balance 
between $200 and $350) into Table2. */
insert into Table2
select LName, sum(Balance) as TotalBalance
from employees e, iras i
where e.idn = i.idn and balance between 200 and 350
group by LName;
select * from Table2;

/*Write an update statement to add $25 to all IRA accounts in T
able2 with less than $250 balance. */
update Table2 set TotalBalance = TotalBalance + 25
where TotalBalance < 250;
select * from Table2;

/* Write a delete statement to delete the records in table2 with a balance above $300. */
delete from Table2
where TotalBalance > 300;
select * from Table2;

/* Write a query to find the records of all employees in the 
Employees table with at least average salary. */
select *
from employees
where salary >= (select avg(salary) from employees);

/* Write a query to find the records of all employees in the 
Employees table with the highest salary */
select *
from employees
where salary >=(select max(salary) from employees);

/* Write a query to find the total number of all employees who live in each city.
Hint: HomeCity and the total number of all employees who live in the city.*/
select Homecity, count(IDN) as NumofEmployees
from AddressCity
group by Homecity;

/*Write a query to find the largest number of employees who live in one city 
in all cities. Hint: May use [7] as a subquery. */
select Homecity, max(NumofEmployees)
from
	(select Homecity as Homecity1, count(IDN) as NumofEmployees
	from AddressCity
	group by Homecity1) as t1, AddressCity a
where a.Homecity = t1.Homecity1 and NumofEmployees >=
	(select max(NumEmployees)
    from (select Homecity as Homecity2, count(IDN) as NumEmployees 
			from AddressCity 
            group by Homecity2)t2)
group by Homecity;
	
/*Write a query to find the lowest total amount of IRA Balance among 
all the employees who have IRA accounts. */
select LName, min(Balance)
from employees e, iras i
where e.idn = i.idn
group by LName;

/*Write a query to find the last name together the total amount of IRA Balance of the employee 
who has the lowest total IRA balance among all the employees who have IRA accounts. */
select LName, Balance
from employees e, iras i
where e.idn = i.idn and balance <=(select min(balance) from iras);
