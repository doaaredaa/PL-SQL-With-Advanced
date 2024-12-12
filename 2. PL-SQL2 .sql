** NVL & to_char & next_day & last_day & add_months **
-- 1.	Display the employees last names and commissions for all employees, if no commission, displays (no commission). Hint : use to_char function

SELECT LAST_NAME, NVL(to_char(COMMISSION_PCT,'99.99'),'No Commission') as Commission_PCT
FROM EMPLOYEES

-- 2.	Write a Query that get the date of the First Sun day in the next month Print it in format   like 14-december-2020

select  to_char(next_day(last_day(sysdate), 'Sun'),'dd-month-yyyy') 
from dual

-- 3.	Write a Query that get the last day date after 3 months from today Print it in format   like 14-december-2020

select to_char(add_months(last_day(sysdate),3),'dd-month-yyyy') as Date_after_3_months
from dual

-- 4.	Display the employee’s name, hire date and salary review date,  The salary review date is the first Monday after six months of service. Label the column Review. Format the dates to appear in the format similar to “Sunday, the Seventh of September, 1981 “.

select FIRST_NAME || ' ' || LAST_NAME as Full_Name, to_char(HIRE_DATE, 'FMDay "The" ddspth "of" Month, yyyy') as Hire_date,
 SALARY, to_char(next_Day(add_months(HIRE_DATE,6),'Mon'), 'FMDay "The" ddspth "of" Month, yyyy') as salary_review_date
FROM EMPLOYEES

-- 5.	Write a query that will display the difference between the highest and lowest salaries in each department.

select DEPARTMENT_ID,max(salary) , min(salary) , max(salary) - min(salary) as "Difference Between Salaries"
FROM EMPLOYEES
where DEPARTMENT_ID is not null
group by DEPARTMENT_ID


-- 6.	write a query that will display the city, department name number of employees and the average salary for all employee in that department, round the average salary to two decimal places. 

select l.CITY ,d.DEPARTMENT_NAME, count(EMPLOYEE_ID) as Number_of_Emp, round(avg(e.SALARY),2) as Avg_Salary
from LOCATIONS l, DEPARTMENTS d, EMPLOYEES e
where d.LOCATION_ID=l.LOCATION_ID and e.DEPARTMENT_ID=d.DEPARTMENT_ID
group by l.CITY , d.DEPARTMENT_NAME

-- 7.	Display the employee number, name and salary for all employee who earn more than the average salary.

select EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME as Full_Name, SALARY
from EMPLOYEES
where SALARY > (select avg(salary) from EMPLOYEES)

-- 8.	Show Employees data Whose Salary is Higher Than Their Manager's and show Manager name, salary ( use sub query not join )

select e.* , 
(select s.salary from EMPLOYEES s where s.EMPLOYEE_ID=e.Manager_ID ) as Manager_salary, 
(select s.FIRST_NAME as Manager_Name from EMPLOYEES s where s.EMPLOYEE_ID=e.Manager_ID ) as Manager_name
from EMPLOYEES e
where e.salary > 
(select s.salary from EMPLOYEES s where s.EMPLOYEE_ID=e.Manager_ID )

-- 9.	Show Employees data Who Earn the Lowest Salary in Their Department ( use subquery not join )

select e.*
from EMPLOYEES e
where e.salary <= all (select salary from EMPLOYEES s where e.DEPARTMENT_ID=s.DEPARTMENT_ID)


-- 10.	Find employees who have been hired earlier than anyone else in the same job ( use subquery not join )

select e.*
from EMPLOYEES e
where e.HIRE_DATE <= all (select HIRE_DATE from EMPLOYEES s where e.JOB_ID=s.JOB_ID)


-- 11.	Write a query to display employee_id, last_name, salary, dept id, dept name, job Id, job title, city, street address, country id, country name, region id, region name for all employees including those employees whose have no department too.

select c.COUNTRY_ID, c.COUNTRY_NAME, c.REGION_ID,
d.DEPARTMENT_ID, d.DEPARTMENT_NAME, d.MANAGER_ID, d.LOCATION_ID,
e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.EMAIL, e.PHONE_NUMBER, e.HIRE_DATE, e.JOB_ID, e.SALARY, e.COMMISSION_PCT, e.MANAGER_ID, e.DEPARTMENT_ID,
j.JOB_ID, j.JOB_TITLE, j.MIN_SALARY, j.MAX_SALARY,
l.LOCATION_ID, l.STREET_ADDRESS, l.POSTAL_CODE, l.CITY, l.STATE_PROVINCE, l.COUNTRY_ID,
r.REGION_ID, r.REGION_NAME
from EMPLOYEES e left join DEPARTMENTS d
on e.DEPARTMENT_ID=d.DEPARTMENT_ID
left join LOCATIONS l
on l.LOCATION_ID=d.LOCATION_ID
left join jobs j
on J.JOB_ID=E.JOB_ID
left join COUNTRIES c
on C.COUNTRY_ID=L.COUNTRY_ID
left join regions r
on R.REGION_ID= C.REGION_ID

