show databases; # This statement shows the list of databases
drop database if exists DBEx2; # This statement drops/deletes the database named DBEx2
create database DBEx2; # Create the database named DBEx2
show databases;
use DBEx2; -- Use the database DBEx2 we just created
show tables; # This statement shows the list of tables in the database DBEx2
show procedure status; # Shows the list of procedures
show function status; # Shows the list of functions
show triggers; # Shows the list of triggers
SHOW PROCEDURE STATUS WHERE db = 'dbex2'; /* Shows the list of procedures in the
database DBEx2 */
SHOW function STATUS WHERE db = 'dbex2'; /* Shows the list of functions in the database
DBEx2 */
SHOW triggers in dbex2; # Shows the list of triggers in the database DBEx2
drop table if exists Employees;
create table Employees(
LName varchar(12) NOT NULL,
BirthDay date NOT NULL,
IDN int NOT NULL PRIMARY KEY,
Salary Decimal(20,2) NULL DEFAULT 0 ,
Deduction decimal(20, 2) NULL DEFAULT 0 );
/* IDN is primary key, the display order may be default to increasing IDN order */
describe Employees;
select * from Employees;
insert into Employees values ('Peter', '1986-9-6', 1, 1000, 10), ('Mary', '1996-9-6', 12, 2000,
0), ('Tony', '1989-7-9', 22, 4000, 32),
('Mike', '1999-11-12', 17, 4000, 10), ('John', '1980-3-2', 93, null, null);
select * from Employees;

drop table if exists IRAs;
create table IRAs(
FK_IDN int NOT NULL, /* FK_IDN is the foreign key */
IRA_acct varchar(12),
Balance decimal(20, 2),
FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
describe iras;
select * from iras;
insert into IRAs values(1, 'A1', 100), (22, 'A2', 200), (22, 'A3', 400), (93, 'A4', 500);
select * from iras;

#PART A: Simple Procedures

# Example [A1]*: Write a procedure to output the string: “This is a procedure.”
drop procedure if exists pex1;
DELIMITER //
create procedure pex1()
Begin
	select 'This is a procedure' as Procedure_example1;
End//
DELIMITER ;

call pex1();

# Example [A2]*: Write a procedure to add two integers.
drop procedure if exists add2;
delimiter //
create procedure add2(x int, y int)
Begin
	Declare s int;
    set s = x + y;
    select concat(x, '+',y, '=',s) as addition;
End//
delimiter ;

call add2(3,9);
call add2(-7,86);

#Alternate Example A2: Procedure to calculate powers.
drop procedure if exists powerex;
delimiter //
create procedure powerex(x int, y int)
Begin
	Declare p int;
    set p = power(x,y);
    select concat (x,' to the power of ',y,' is ',p) as answer;
End//
delimiter ;

call powerex(2,3);
call powerex(4,5);

/*Example [A3]*: Write a procedure to show the current time in format such as 04/10/2019 and
Wednesday, April 10th, 2019.*/
drop procedure if exists TimeNow;
delimiter //
create procedure TimeNow()
Begin
	select now() as CurrentTime,
    date_format(now(),'%m/%d/%Y') as NameForm1,
    date_format(now(),'%W, %M %D, %Y') as NameForm2;
End//
delimiter ;

call TimeNow();

# [B] Loops and ifs.
/* Example [B1]*: Write a procedure to tell if an integer is even or odd.
Example of using if. Note: m % d = the remainder when m is divided by d. */
drop procedure if exists EvenOdd;
delimiter //
create procedure EvenOdd(n int)
Begin
	Declare s varchar(12);
    if (n % 2 = 0) then set s = 'even';
		else set s = 'odd';
	end if;
    Select concat(n,' is ',s) as IntegerEO;
End//
delimiter ;

call EvenOdd(10);
call EvenOdd(121);

#Example [B2]: Write a procedure to tell if an integer is even or odd using case.
drop procedure if exists EvenOddC;
delimiter //
create procedure EvenOddC(n int)
Begin
	Declare s varchar(12);
    Case (n % 2) when 0 then set s = 'even';
    else set s = 'odd';
    end case;
    Select concat(n,' is ',s) as IntegerEOC;
End//
delimiter ;

call EvenOddC(10);
call EvenOddC(121);

/*Example [B3a]*: Write a procedure to calculate the sum of all positive even/odd integers below
an integer. Example of using while loop and if. Although we have formulas to find the results
very easily, we would like to show how to use loops and ifs instead.*/
drop procedure if exists SumEO;
delimiter //
create procedure SumEO(num int)
Begin
	Declare n, SE, SO int;
    set n=0, SE=0, SO=0;
    while n<num do
		if(n % 2 = 0) then set SE=SE+n;
        else set SO=SO+n;
        end if;
        set n=n+1;
	end while;
    select concat('Sum of positive Evens below ',num,' is: ',SE) as SumEvens,
    concat('Sum of positive Odds below ',num, ' is: ',SO) as SumOdds;
End//
delimiter ;

call SumEO(5);
call SumEO(10);
call SumEO(-20);

/* Example [B3b]: Write a procedure to calculate the sum of all positive even/odd integers below
an integer. Example of using while loop and case: */
drop procedure if exists SumEOc;
delimiter //
create procedure SumEOc(num int)
Begin
	Declare n, SE, SO int;
    set n=0, SE=0, SO=0;
    while n<num do
		case (n % 2) when 0 then set SE=SE+n;
        else set SO=SO+n;
        end case;
        set n=n+1;
	end while;
    select concat('Sum of positive Evens below ',num,' is: ',SE) as SumEvens,
    concat('Sum of positive Odds below ',num,' is: ',SO) as SumOdds;
End//
delimiter ;

call SumEOc(5);
call SumEOc(10);
call SumEOc(-20);

/* Example [B3c]: Write a procedure to calculate the following summation: For any integer n,
𝐹𝐹(𝑛𝑛) = ∑ 𝑖𝑖√𝑖𝑖 𝑛𝑛
𝑖𝑖=0 , 𝑛𝑛 > 0; 𝐹𝐹(𝑛𝑛) = 0, 𝑛𝑛 ≤ 0. Example of using while loop and if.
Note: the square root SQRT(x) = √𝑥𝑥. */
drop procedure if exists PF;
delimiter //
create procedure PF(num int)
Begin
	Declare i int;
    Declare S Decimal (20,4);
    set i = 0, S=0;
    while i<=num do
		set S=S+i*sqrt(i);
        set i=i+1;
	end while;
    select concat('F(',num,')=',S) as SumValue;
End//
delimiter ;

call PF(0);
call PF(1);
call PF(5);
call PF(-5);

/* Example [B4]: Write a procedure to calculate the sum of all positive even/odd integers below an
integer. Example of using repeat loop and if: */
drop procedure if exists SumEOrp;
delimiter //
create procedure SumEOrp(num int)
Begin
	Declare n, SE, SO int;
    set n=0, SE=0, SO=0;
    if num >0 then
		Repeat set n = n+1;
			if (n % 2 = 0) then set SE=SE+n;
            else set SO=SO+n;
			end if;
		until n=num - 1 end repeat;
	end if;
    select concat('Sum of positive Evens below ',num,' is: ',SE) as SumEvens,
    concat('Sum of positive Odds below ',num,' is: ',SO) as SumOdds;
end//
delimiter ;

call SumEOrp(5);
call SumEOrp(10);
call SumEorp(-20);

/* Example [B5]*: Write a procedure to calculate the factorial of an integer n: 𝑛𝑛! = ∏ (𝑖𝑖) 𝑖𝑖=𝑛𝑛 𝑖𝑖=1
3! = 1*2*3=6, and 5! = 1*2*3*4*5 = 120, etc. Example of using while loop. */
drop procedure if exists PFactorial;
delimiter //
create procedure PFactorial(num int)
Begin
	Declare i, Fact int;
    set i=1, Fact=1;
    while i<num do
		set fact=fact*i;
        set i=i+1;
	end while;
    select concat(num,'!= ',fact) as Factorial;
End//
delimiter ;

call PFactorial(3);
call PFactorial(5);

# PART C: Procedures Using Query Statements

/* Example [C1]*: Write a procedure to show the largest IRA balance, the sum of all IRA
balances, and the total number of all IRA accounts. */
drop procedure if exists Totals;
Delimiter //
create procedure Totals()
Begin
	Declare MaxBalance, TotalBalance decimal(10,2);
    Declare Num_Accts int;
    select max(balance), sum(balance), count(ira_acct)
    into MaxBalance, TotalBalance, Num_accts from IRAs;
    select concat('Largest IRA Balance: $',MaxBalance) as message2, Num_accts as
		'Numer of IRA accounts';
end//
Delimiter ;

call Totals();

/* Example [C2]*: Write a (update) procedure to add a bonus to all IRA accounts with low balance
(<$300) and increase addDeduction to the deductions of those employees with high salaries
(>$1500). */
select * from Employees;
select * from iras;
drop procedure if exists Updates;
delimiter //
create procedure Updates(Bonus decimal(20,2), addDeduction int)
Begin
	update IRAs set balance=balance + Bonus where balance <300;
    update Employees set Deduction = deduction + addDeduction
		where Salary >1500;
End//
delimiter ;

call Updates(10,5);
select * from Employees;
select * from iras;

#Example [C3]*: Write a search procedure to get the salary of LName
drop procedure if exists GetSalary;
delimiter //
create procedure GetSalary(emp varchar(20))
Begin
	Declare s decimal(10,2);
    set s=0;
    if emp in (select LName from Employees) then
		select Salary into s from Employees where LName=emp;
        select Concat('Salary of ',emp,' is $',s) as EmpSalary;
	else select Concat(emp,' is not an employee') as NotFound;
    end if;
end//
delimiter ;

call GetSalary('Tony');
call GetSalary('Peterson');

/* Example [C4]*: Write a search procedure to find the total balance of all IRA accounts of an
IDN. */
drop procedure if exists TotalBalance;
delimiter //
create procedure TotalBalance(I int)
Begin
	Declare s decimal(10,2);
    set s=0;
    if I in (select FK_IDN from IRAs) then
		select sum(balance) into s from IRAs where FK_IDN=i;
        select concat('Total Balance of IDN ',i,' is $',s) as Total_IRA_Balance;
	else select Concat(i,' does not have an account')NotFound;
    end if;
end//
delimiter ;

 call TotalBalance(1);
 call TotalBalance(22);
 call TotalBalance(122);
 
 #Knowledge Check
 #1:Write a SQL procedure to subtract the second input integer from the square of the first input integer.
drop procedure if exists KC1;
 delimiter //
 create procedure KC1(x int, y int)
 Begin
	Declare a int;
    set a = (x * x)- y;
    select concat(x,' squared minus ',y,' is ',a) as answer;
End//
delimiter ;

call KC1(4,3);

/* #2 Write a SQL procedure to calculate the following summation: For any input integer n,g
If n > 0, G(n) = the sum of all LaTeX: i^2-√i, where i is from 0 to n; G(n)=0 if n LaTeX: ≤0.
Note: the square root SQRT(x) = LaTeX: \sqrt{x}  . Use at least 5 digits after the decimal point. */
drop procedure if exists KC2;
delimiter //
create procedure KC2(n int)
Begin
	declare i int;
    declare S decimal(20,5);
    set i = 0, S=0;
    if n<=0 then 
		select concat('G(',n,') = 0.') as Integer0orBelow;
	else
		while n>i do
			set S = S+(i*i)-sqrt(i);
			set i= i+1;
		end while;
        select concat('G(',n,') = ',S) as Summation;
	end if;
end//
delimiter ;

call KC2(0);

#3 Write a SQL search procedure to get the deduction of LName.
drop procedure if exists KC3;
delimiter //
create procedure KC3(emp varchar(20))
Begin
	Declare d decimal(10,2);
    set d=0;
    if emp in (select LName from Employees) then
		select Deduction into d from Employees where LName=emp;
        select concat('Deduction for ',emp,' is $',d) as Employee_Deduction;
	else select concat(emp,' is not an employee.') as NotFound;
    end if;
end//
delimiter ;

call kc3('Peter');
call kc3('Paul');