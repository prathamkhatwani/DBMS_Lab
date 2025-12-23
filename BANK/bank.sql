create table branch(
branch_name varchar(30),
branch_city varchar(30),
assets real,
primary key(branch_name)
);

CREATE TABLE Customer (
    customer_name VARCHAR(255),
    customer_street VARCHAR(255),
    customer_city VARCHAR(255) NOT NULL,
    primary key(customer_name)
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(255) NOT NULL,
    balance REAL CHECK (balance >= 0),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE LOAN (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(255) NOT NULL,
    amount REAL CHECK (amount > 0),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(255),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES Customer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

INSERT INTO Branch values
('SBI_Chamrajpet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 10000),
('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParlimentRoad', 'Delhi', 10000),
('SBI_Jantarmantar', 'Delhi', 20000);

INSERT INTO Customer VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannergatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');

INSERT INTO BankAccount VALUES
(1, 'SBI_Chamrajpet', 2000),
(2, 'SBI_ResidencyRoad', 5000),
(3, 'SBI_ShivajiRoad', 6000),
(4, 'SBI_ParlimentRoad', 9000),
(5, 'SBI_Jantarmantar', 8000),
(6, 'SBI_ShivajiRoad', 4000),
(8, 'SBI_ResidencyRoad', 4000),
(9, 'SBI_ParlimentRoad', 3000),
(10, 'SBI_ResidencyRoad', 5000),
(11, 'SBI_Jantarmantar', 2000);

INSERT INTO Depositer VALUES
('Avinash', 1),
('Dinesh', 2),
('Nikil', 4),
('Ravi', 5),
('Avinash', 8),
('Nikil', 9),
('Dinesh', 10),
('Nikil', 11);

INSERT INTO LOAN VALUES
(1, 'SBI_Chamrajpet', 1000),
(2, 'SBI_ResidencyRoad', 2000),
(3, 'SBI_ShivajiRoad', 3000),
(4, 'SBI_ParlimentRoad', 4000),
(5, 'SBI_Jantarmantar', 5000);

select * from branch;
select * from Customer;
select * from BankAccount;
select * from Depositer;
select * from loan;

select branch_name, (assets/100000) as "assets_in_lakhs" from branch;

select d.customer_name,b.branch_name,count(*) as no_of_account
from depositer d
join bankaccount1 b on d.accno=b.accno
group by d.customer_name,b.branch_name
having count(*)>=2;

create view branchloan as
select branch_name, sum(amount) as total_loan_amount
from loan
group by branch_name;
select * from branchloan;

select distinct d.customer_name
from depositer d
join bankaccount1 ba on d.accno=ba.accno
join branch b on ba.branch_name=b.branch_name
where b.branch_city='delhi';

select distinct bc.customer_name
from bankcustomer bc
where bc.customer_name not in (
select customer_name from depositer
)
and bc.customer_name in(
select customer_name from loan
);

SELECT DISTINCT d.customer_name
FROM depositer d
JOIN bankaccount1 ba ON d.accno = ba.accno
JOIN branch b1 ON ba.branch_name = b1.branch_name
JOIN loan l ON d.customer_name IN (
    SELECT customer_name FROM depositer
)
JOIN branch b2 ON l.branch_name = b2.branch_name
WHERE b1.branch_city = 'Bangalore'
  AND b2.branch_city = 'Bangalore';
 
select branch_name
from branch
where assets>all(select assets from branch where branch_city='bangalore');


delete from bankaccount1
where branch_name in (
select branch_name from branch
where branch_city='bombay'
);

update bankaccount1
set balance=balance*1.05;
