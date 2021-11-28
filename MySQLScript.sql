create database if not exists SalesData;

use SalesData;

CREATE TABLE IF NOT EXISTS table1 (
    city VARCHAR(255),
    years NUMERIC,
    months NUMERIC,
    sales NUMERIC
);

insert into table1(city,years,months,sales)
values ('Delhi',2020,5,4300);
insert into table1(city,years,months,sales)
values ('Delhi',2020,6,2000);
insert into table1(city,years,months,sales)
values ('Delhi',2020,7,2100);
insert into table1(city,years,months,sales)
values ('Delhi',2020,8,2200);
insert into table1(city,years,months,sales)
values ('Delhi',2020,9,1900);
insert into table1(city,years,months,sales)
values ('Delhi',2020,10,200);
insert into table1(city,years,months,sales)
values ('Mumbai',2020,5,4400);
insert into table1(city,years,months,sales)
values ('Mumbai',2020,6,2000);
insert into table1(city,years,months,sales)
values ('Mumbai',2020,7,6000);
insert into table1(city,years,months,sales)
values ('Mumbai',2020,8,9300);
insert into table1(city,years,months,sales)
values ('Mumbai',2020,9,4200);
insert into table1(city,years,months,sales)
values ('Mumbai',2020,10,9700);
insert into table1(city,years,months,sales)
values ('Bangalore',2020,5,1000);
insert into table1(city,years,months,sales)
values ('Bangalore',2020,6,2300);
insert into table1(city,years,months,sales)
values ('Bangalore',2020,7,6800);
insert into table1(city,years,months,sales)
values ('Bangalore',2020,8,7000);
insert into table1(city,years,months,sales)
values ('Bangalore',2020,9,2300);
insert into table1(city,years,months,sales)
values ('Bangalore',2020,10,8400);

SELECT 
    *
FROM
    table1;

SELECT city,
       years,
       months,
       sales,
       lag(sales) OVER (order by months) AS PrevMonthSales,
       lead(sales) OVER (order by months) AS NextMonthSales,
       Sum(sales) OVER (ORDER by MONTHS) as YTDSales
from table1
where city = 'Delhi';

drop table table1;

drop database if exists SalesData;
