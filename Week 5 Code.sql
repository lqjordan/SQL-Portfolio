/* PART A: How to create database tables – relational database tables.
----------------------------------------------------------------------*/

#Example A: The following codes create the database DBEx2 containing the three tables:
show databases;
drop database if exists DBEx2;
create database DBEx2;
show databases;
use DBEx2;
show tables;

#Example Aa: Create the Employees Table
drop table if exists Employees;
create table Employees(
LName varchar(12) NOT NULL,
BirthDay date NOT NULL,
IDN int NOT NULL PRIMARY KEY,
Salary Decimal(20,2) NULL DEFAULT 0 ,
Deduction decimal(20, 2) NULL DEFAULT 0 );

describe Employees;
select * from Employees;
insert into Employees values ('Peter', '1986-9-6', 1, 1000, 10), ('Mary', '1996-9-6', 12, 2000,
0), ('Tony', '1989-7-9', 22, 4000, 32),
('Mike', '1999-11-12', 17, 4000, 10), ('John', '1980-3-2', 93, null, null);
select * from Employees;

/* Example A1: The following query statements demonstrate how to use the function CONCAT()
and DATE_FORMAT using specifiers such as %W, %M %d, and %Y. */
select LName, DATE_FORMAT(Birthday, '%W, %M %d, %Y') as Birth_Date from employees;

select concat(LName, ' was born on ', date_format(Birthday,'%W, %M %d, %Y')) as BornDate from employees;

select concat(LName,' is ',year(now())-year(birthday),' years old.') as currentage from employees;

#Example Ab: The following codes create the IRAs table:
drop table if exists IRAs;
create table IRAs(
FK_IDN int NOT NULL,
IRA_acct varchar(12),
Balance decimal(20, 2),
FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
describe iras;
select * from iras;
insert into IRAs values(1, 'A1', 100), (22, 'A2', 200), (22, 'A3', 400), (93, 'A4', 500);
select * from iras;

#Example Ac: The following codes create the AddressCity table:
drop table if exists AddressCity;
create table AddressCity(
FK_IDN int NOT NULL,
CompanyCity varchar(22),
HomeCity varchar(22),
FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
describe addresscity;
select * from addresscity;
insert into addresscity values (1, 'Saint Louis', 'Saint Louis'), (12, 'Saint Louis',
'Chesterfield'),
(22, 'Chesterfield', 'Saint Louis'), (93, 'Chesterfield', 'Chesterfield'), (17, 'Fenton',
'Fenton');
select * from addresscity;

#Example A4: Multiple FK for one primary key
insert into addresscity values (22, 'BCA', 'Saint Louis'); /* Can have more than one record
for the same FK_IDN */
select * from addresscity;
delete from addresscity where CompanyCity = 'BCA'; /* may delete row in this case */
select * from addresscity;

#Example A5: Can change the structure of a table, for example, may add a column to a table.
alter table addresscity add WorkCity varchar(22) NULL;
select * from addresscity;

update addresscity set workcity = companycity;
select * from addresscity;

#Example A7: More time function exercises.
select now();
select current_timestamp;
select year(now())-year('1990-11-17')as age;
select year(now()) as datepartstring;
select month(now()) as datepartstring;
select monthname(now()) as datepartstring;
select day(now()) as datepartstring;
select dayofmonth(now()) as datepartstring;
select dayofyear(now()) as datepartstring;

SELECT dayofweek( '2017/08/25') AS DatePartString;
SELECT dayname( '2017/08/25') AS DatePartString;
SELECT date( '2017/08/25') AS DatePartString;
select year(now()) - year('1956-9-6') as YearsOld;
select DATE_FORMAT('1997-10-04 22:23:00', '%W %M %Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%W, %M %d, %Y') as FEx ;
select DATE_FORMAT('1997-10-04 22:23:00', '%W, %M %D, %Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%w %m %Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%w-%m-%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%d-%m-%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m-%d-%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m/%d/%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m /%d /%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m / %d / %Y') as FEx;

/*PART B:How to create views 
--------------------------------------------------------------------------------*/
#Example B1: The following codes create the view viewex1
drop view if exists viewex1;
select LName, salary from employees where salary<3000;

create view viewex1 as select LName, salary from employees where salary<3000;
select * from viewex1;

#Alternate B1:
create or replace view myexampleview as
	select LName, Salary,year(now())-year(birthday) as Age 
    from employees;
select * from myexampleview;

#Example B2: The following codes create the view viewex2:
drop view if exists viewex2;
select * from iras where balance < 300;

create view viewex2 as
		select * from iras where balance < 300;
select * from viewex2;
select * from viewex2 where balance < 150;

#Example B3: May use views to update the original table
select * from employees;
select * from viewex1;
update viewex1 set salary = salary + 1000;
select * from employees;
select * from viewex1;
select LName, salary from employees where salary<3000;
update employees set salary = salary + 100;
select * from employees;
select * from viewex1;

/*Example B4: Create views using more than one table such as the following viewex3 and
viewex4 produced by two queries. Note the differences between views and tables.*/
select LName, Salary, sum(balance) as Total_IRAB from employees, IRAs
	where idn = fk_idn group by idn;
    
create or replace view viewex3 as
	select LName, Salary, sum(balance) as Total_IRAB from employees, IRAs
	where idn = fk_idn group by idn;
select * from viewex3;

select LName, Salary, count(IRA_acct) as NumAccts, sum(balance) as Total_IRAB
	from employees, IRAs where idn=FK_idn group by idn;

create or replace view viewex4 as
	select LName, Salary, count(IRA_acct) as NumAccts, sum(balance) as Total_IRAB
	from employees, IRAs where idn=FK_idn group by idn;
select * from viewex4;

select * from iras;

update IRAs set balance = balance + 50 where balance < 300;
select * from iras;

select * from viewex4;

#Knowledge Check
#1 Write a query statement to find the age of each employee. 
select LName, year(now()) - year(birthday) as Age from employees;

#2 Write a query to find the last name, birth year, and the total IRA balance of each employee.
select LName, Birthday, sum(Balance) as Total_IRA  from employees e, iras i where e.IDN = i.fk_IDN group by IDN;

/* 3 Write a SQL statement to create a view containing the last name, birth year, and the total IRA balance 
of each employee. */
create view viewQ3 as 
select LName, Birthday, sum(Balance) as Total_IRA  
from employees e, iras i where e.IDN = i.fk_IDN group by IDN;
select * from viewQ3;

/* Write a query to find the last name, birth year, and the total balance of the employee with
 the maximal total ira balance. */
 select LName, Birthday, sum(Balance) as Total_Balance
 from employees e, iras i
 where e.idn = i.fk_IDN
 group by LName, e.idn
 having Total_Balance >= all(select sum(balance) from iras group by IDN);

#My SQL Test 3
drop table if exists students;
drop table if exists courses;
create table Students(
	SIDN varchar(12) NOT NULL Primary Key,
    SName varchar(12) NOT NULL,
    Birthday date NOT NULL);
    
create table Courses(
	FK_SIDN varchar(12) NOT NULL,
    CName varchar(12),
    Credits int,
    Foreign Key (FK_SIDN) References Students(SIDN));

#Write a query statement to insert three rows into Students table and five rows into Courses table.
insert into students values
	('A1', 'Matthew', '1990-11-17'),
    ('B2', 'Mark', '1989-11-04'),
    ('C3', 'Luke', '1986-7-7');

insert into courses values
	('A1', 'Math', 4),
    ('A1', 'Science', 3),
    ('B2', 'ELA', 3),
    ('B2', 'Band',3),
    ('C3', 'Art', 2);

#Write a query statement to find the current age of each student.
select SName, year (now())- year(Birthday) as Age
from students;

/*Write a query statement to find the student name, student identification number, 
total number of courses, and the total number of credits on each student. */
select SName, SIDN, count(CName) as TotalCourses, sum(credits) as TotalCredits
from students s, courses c
where s.SIDN = c.FK_SIDN
group by SName, SIDN;

/* Write a SQL statement to create a view containing the student name, student identification number, 
the total number of courses, and the total number of credits on each student. */
create view viewQ5 as
select SName, SIDN, count(CName) as TotalCourses, sum(credits) as TotalCredits
from students s, courses c
where s.SIDN = c.FK_SIDN
group by SName, SIDN;