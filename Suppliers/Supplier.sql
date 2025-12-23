create database supplier;
use supplier;

CREATE TABLE SUPPLIERS (
    SID INT PRIMARY KEY,
    SNAME VARCHAR(50),
    CITY VARCHAR(50)
);

CREATE TABLE PARTS (
    PID INT PRIMARY KEY,
    PNAME VARCHAR(50),
    COLOR VARCHAR(20)
);

CREATE TABLE CATALOG (
    SID INT,
    PID INT,
    COST DECIMAL(10,2),
    PRIMARY KEY (SID, PID),
    FOREIGN KEY (SID) REFERENCES SUPPLIERS(SID) ON DELETE CASCADE,
    FOREIGN KEY (PID) REFERENCES PARTS(PID) ON DELETE CASCADE
);

INSERT INTO SUPPLIERS (SID, SNAME, CITY) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO PARTS (PID, PNAME, COLOR) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');


SELECT * FROM SUPPLIERS;
SELECT * FROM PARTS;
SELECT * FROM CATALOG;


SELECT S.SNAME
FROM SUPPLIERS S
JOIN CATALOG C ON S.SID = C.SID
GROUP BY S.SID, S.SNAME
HAVING COUNT(DISTINCT C.PID) = (SELECT COUNT(*) FROM PARTS);

select distinct P.PNAME from Parts P Join Catalog C on P.PID=C.PID;

SELECT S.SNAME
FROM SUPPLIERS S
JOIN CATALOG C ON S.SID = C.SID
JOIN PARTS P ON C.PID = P.PID
WHERE P.COLOR = 'Red'
GROUP BY S.SID, S.SNAME
HAVING COUNT(DISTINCT P.PID) = (
    SELECT COUNT(*) FROM PARTS WHERE COLOR = 'Red'
);

SELECT P.PNAME
FROM PARTS P
JOIN CATALOG C ON P.PID = C.PID
GROUP BY P.PID, P.PNAME
HAVING COUNT(DISTINCT C.SID) = 1
   AND MAX(C.SID) = 10001;

select distinct c1.sid
from catalog c1
where c1.cost > (
    select avg(c2.cost)
    from catalog c2
    where c2.pid = c1.pid
);

select p.pname, s.sname
from parts p
join catalog c on p.pid = c.pid
join suppliers s on c.sid = s.sid
where c.cost = (
    select max(c2.cost)
    from catalog c2
    where c2.pid = p.pid
);


INSERT INTO CATALOG (SID, PID, COST) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40),
(10003, 20001,50),
(10003, 20002,30),
(10003, 20004,20),
(10003, 20005,40);
