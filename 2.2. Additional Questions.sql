--1. Display the first names and hire dates of employees, if no hire date, display 'Not Hired Yet'. Hint: Use NVL function.
select E.FIRST_NAME, NVL(to_char(E.HIRE_DATE, 'dd-mm-yyyy'), 'Not Hired Yet') as hire_date
from employees e;
----------------------------------------
--2. Write a query to find the first Friday of the current year and display it in the format like "05-January-2024".
select to_char(next_day(trunc(sysdate,'YEAR'), 'Fri'), 'FMdd-Month-yyyy') as First_Friday_in_Year
from dual;
----------------------------------------
--3. Write a query to get the date of the first day of the next year and print it in the format "01-January-2025".
select to_char(add_months(trunc(sysdate,'YEAR') , 12), 'FMdd-Month-yyyy') as First_Day_in_new_year
from dual;
----------------
select to_char(round(sysdate,'year'),  'FMdd-Month-yyyy') as First_day_in_new_Year
from dual;
----------------------------------------
--4. Display employees' names, their hire dates, and the date they are eligible for their first promotion. 
--  The promotion eligibility date is exactly one year after their hire date. Format the dates as "Monday, the Fifth of March, 2022".
select E.FIRST_NAME, E.LAST_NAME, to_char(E.HIRE_DATE, 'FMDay, "The" ddth "of" Month, yyyy') as hire_date
                                                     , to_char(add_months(HIRE_DATE,12), 'FMDay, "The" ddth "of" Month, yyyy') as "eligibility date"
from employees e;
----------------------------------------
-- 5. Write a query to find the difference between the highest and lowest salaries across all departments combined.
select max(salary),  min(salary) , max(salary) - min(salary) as "difference between salaries"
from employees e
where DEPARTMENT_ID is not null;
----------------------------------------
-- 6. Display the country name, department name, the total number of employees, and the total salary for employees in each department, grouping by country name and department name.
select D.DEPARTMENT_NAME,C.COUNTRY_NAME ,count(E.EMPLOYEE_ID) as "total number of employees", sum(salary) as "total salary"
from employees e, departments d, locations l, COUNTRies c 
where E.DEPARTMENT_ID=D.DEPARTMENT_ID and D.LOCATION_ID=L.LOCATION_ID and L.COUNTRY_ID=C.COUNTRY_ID
group by D.DEPARTMENT_NAME,C.COUNTRY_NAME;
----------------------------------------
-- Givesme the current time (hours, mins, seconds)
select to_char(sysdate, 'hh12:mi:ss PM')
from dual;
--------------------------------------
-- here, consider this part  to_date('16-04-1998','dd-mm-yyyy') --> as sysdate 
-- here to_char( ----------- , 'Day dd.Mon.yyyy, hh12:mi:ss PM') --> i want co convert this part into letters Sun November 2024
select to_char( to_date('16-04-1998','dd-mm-yyyy') , 'Day dd.Mon.yyyy, hh12:mi:ss PM') as "Doaa Birthday"
from dual;
------------------------------------------
--employees hired in 06 2005
select * from employees
where to_char(hire_date, 'mm yyyy')='06 2005';
---------------------------------------------
-- employees hired in 2005
select * from employees
where to_char(hire_date, 'yyyy')='2005';
------------------------------------------------
-- show years between 2 dates, remaining months ||| remaining days exactly.
-- here i used [ total_months / 12 ]  to retrive years.
select E.EMPLOYEE_ID,E.LAST_NAME,  e.hire_date,months_between(sysdate,hire_date) as total_months_of_work
                        ,months_between(sysdate,hire_date)/12 as years_without_filter 
                       , trunc(months_between(sysdate,hire_date)/12) as years
                       ,mod(months_between(sysdate,hire_date),12) as months_without_filter
                       , trunc(mod( months_between(sysdate,hire_date) ,12)) as months
from employees e;
-----------------------------------
-- the first Saturday from the next month
select next_day(last_day(sysdate),'sat')
from dual;
------------------------------------
-- the first day from the next month
select last_day(sysdate)+1
from dual;
----------------------------------
--round(sysdate, 'Month') --> gives me the next month
-- round(sysdate, 'Year') --> gives me the next year
--  trunc(sysdate, 'Month') --> gives me the current month
-- trunc(sysdate, 'Year') --> gives me the current year
select round(sysdate, 'Month'), round(sysdate, 'Year'),
         trunc(sysdate, 'Month'), trunc(sysdate, 'Year')
from dual;
---------------------------------------
-- mult row subquery [noncorrelated]
select * from departments 
where DEPARTMENT_ID not in (select NVL(DEPARTMENT_ID,0) from departments );
----------------------------------------
-- Correlated Sub Query 
-- Example : Find Employees data along with their average salary of their department
--                Then Filter Employees to show only employees take salary > avg sal of their dept
select outer_query.EMPLOYEE_ID, outer_query.FIRST_NAME, outer_query.SALARY, outer_query.DEPARTMENT_ID, (select round(avg(subquery.salary),2) from employees subquery
                                                                                                                                                           where subquery.DEPARTMENT_ID=outer_query.DEPARTMENT_ID ) as avg_Salary
from employees outer_query
where outer_query.salary > (select avg(subquery.salary) from employees subquery
                            where subquery.DEPARTMENT_ID=outer_query.DEPARTMENT_ID );
                            --its not self join X X X
--------------------------------------
-- Example : Show Departments data along with count employees in this department 
--               filter departments to show only which have More than or Equal 5 Employees  
select outer_query.DEPARTMENT_ID, outer_query.DEPARTMENT_NAME,(select count(subquery.EMPLOYEE_ID) from employees subquery 
                                                                                                         where subquery.DEPARTMENT_ID=outer_query.DEPARTMENT_ID ) as emp_count
from departments outer_query
where  (select count(subquery.EMPLOYEE_ID) from employees subquery 
             where subquery.DEPARTMENT_ID=outer_query.DEPARTMENT_ID ) >=5;
