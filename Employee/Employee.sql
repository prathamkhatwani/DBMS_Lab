create database employee ;
use employee;

create table Dept(DeptNO INT primary key,Dname varchar(30),Dloc varchar(30));
insert into Dept values
(10,'HR','Bengaluru'),
(20,'Finance','Hyderabad'),
(30,'IT','Mysuru'),
(40,'Marketing','Chennai'),
(50,'operations','Delhi');

create table Employee(EmpNO INT primary key,Ename varchar(30),Mgr_NO INT,Hiredate date,SAL decimal(10,2),DEPTNO INT,foreign key(DEPTNO) references Dept(DEPTNO));
insert into Employee values
(1001,'Asha',NULL,'2020-05-12',55000,10),
(1002,'Rahul',1001,'2021-01-18',48000,20),
(1003,'Sneha',1001,'2019-08-21',60000,30),
(1004,'Kiran',1003,'2022-04-15',45000,40),
(1005,'Vikram',1002,'2020-09-12',52000,50),
(1006,'Neha',1003,'2023-03-10',47000,30);

create table Project(PNO INT primary key,Pname varchar(30),PLOC varchar(30));
insert into Project values
(501,'ERP upgrade','Bengaluru'),
(502,'Payroll Automation','Hyderabad'),
(503,'AI chatbot','Mysuru'),
(504,'Market survey','Delhi'),
(505,'Data migration','Chennai');

create table Assigned_TO(EmpNO INT,PNO INT , JOB_ROLE varchar(30), primary key(EmpNO,PNO),
foreign key(EmpNO) references Employee(EmpNO),
foreign key(PNO) references Project(PNO));
insert into Assigned_TO values
(1001,501,'Manager'),
(1002,502,'Analyst'),
(1003,503,'Developer'),
(1004,505,'Exectuive'),
(1005,504,'Coordinator'),
(1006,503,'Tester '),
(1003,501,'Consultant');

create table Incentives(EMPNO INT,Incentivedate DATE,Incentive_Amount decimal(10,2),foreign key(EMPNO) references Employee(EMPNO));
insert into Incentives values
(1001,'2023-12-10',5000),
(1003,'2024-01-20',7000),
(1005,'2023-03-15',6000),
(1006,'2023-04-25',3000),
(1002,'2023-10-05',4000);

select * from dept;
select * from Employee;
select * from Assigned_TO;
select * from Incentives;
select * from Project;

SELECT E.Ename AS Manager_Name
FROM Employee E
WHERE E.EmpNO IN (
    SELECT Mgr_NO
    FROM Employee
    WHERE Mgr_NO IS NOT NULL
    GROUP BY Mgr_NO
    HAVING COUNT(*) = (
        SELECT MAX(EmpCount)
        FROM (
            SELECT COUNT(*) AS EmpCount
            FROM Employee
            WHERE Mgr_NO IS NOT NULL
            GROUP BY Mgr_NO
        ) AS Counts
    )
);


SELECT M.Ename AS Manager_Name, M.SAL AS Manager_Salary
FROM Employee M
WHERE M.EmpNO IN (
    SELECT E.Mgr_NO
    FROM Employee E
    GROUP BY E.Mgr_NO
    HAVING AVG(E.SAL) < (
        SELECT SAL
        FROM Employee
        WHERE EmpNO = E.Mgr_NO
    )
);

SELECT E1.DeptNo, E1.Ename AS Second_Level_Manager
FROM Employee E1
WHERE E1.EmpNo IN (
    SELECT Mgr_no FROM Employee
)
AND E1.EmpNo IN (
    SELECT E2.EmpNo
    FROM Employee E2
    WHERE E2.EmpNo IN (SELECT Mgr_no FROM Employee)
    GROUP BY E2.DeptNo, E2.EmpNo
    HAVING COUNT(*) = 1 AND MAX(E2.Sal) > E1.Sal
);

SELECT E.EName AS EmployeeName, M.EName AS ManagerName, E.DeptNo
FROM Employee E
JOIN Employee M ON E.Mgr_NO = M.EmpNo
WHERE E.DeptNo = M.DeptNo;

select E.*
from Employee E
join Incentives I on E.EmpNo=I.EmpNo
Where I.Incentivedate between '2019-01-01' and '2019-01-31'
and I.Incentive_Amount = ( select Max(Incentive_Amount) from Incentives where Incentivedate between '2019-01-01' and '2019-01-31' and Incentive_Amount<(select max(Incentive_Amount) from Incentives where I.Incentivedate between '2019-01-01' and '2019-01-31'));
