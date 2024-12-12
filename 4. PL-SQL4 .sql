----------------------------------SQL-----------------------------------------------------
-- 2.  Create a sequence to be used with the primary key column of the DEPARTMENTS table. The sequence should start at 600 and have a maximum value of 1000. 
--Have your sequence increment by ten numbers. Name the sequence DEPT_ID_SEQ. and use it to insert a new row in departments table
create sequence DEPT_ID_SEQ
    start with 600
    increment by 10 
    maxvalue 1000
    nocycle;
----
insert into DEPARTMENTS  (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
values (DEPT_ID_SEQ.nextval,'NOC',1700)
    
-- 3. Create public synonyms for the view EMP_VU.
create public synonym syn_EMP_VU for hr.EMP_VU
select * from syn_EMP_VU

----------------------------------PL/SQL-----------------------------------------------------
-- 1.    Create plsql block to calculate the retired salary for the employee no = 105, Retired salary = no of working months * 10 % of his current salary
SET SERVEROUTPUT ON;
select SALARY,EMPLOYEE_ID from EMPLOYEES where EMPLOYEE_ID= 105;
declare   v_salary number(14,2);      v_emp_id number(4);    v_retired_salary number(14,2);     v_hire_date date;
begin

select SALARY,EMPLOYEE_ID, HIRE_DATE
into v_salary, v_emp_id, v_hire_date
from EMPLOYEES
where EMPLOYEE_ID=105;
---PL SQL
v_retired_salary := months_between(sysdate,v_hire_date) * (0.10*v_salary);
-- Output
dbms_output.put_line('EMPLOYEE_ID = ' ||  v_emp_id || ', ' || 'SALARY = ' || v_salary || ' ,' || 'Retired salary = ' ||  v_retired_salary);
end;
select SALARY,EMPLOYEE_ID from EMPLOYEES where EMPLOYEE_ID=105;

-------------------------------------------------------

-- 2.    Create plsql block to print last name, department name, city, country name for employee whose id = 105 ( without using join | sub query )
SET SERVEROUTPUT ON;
declare     v_last_name EMPLOYEES.LAST_NAME%type;
              v_dep_name DEPARTMENTS.DEPARTMENT_NAME%type;        v_dep_id DEPARTMENTS.DEPARTMENT_ID%type;      
              v_loc_id LOCATIONS.LOCATION_ID%type;                             v_city LOCATIONS.CITY%type;                                 v_country_id LOCATIONS.COUNTRY_ID%type;
              v_country_name COUNTRIES.COUNTRY_NAME%type;         
begin

select  LAST_NAME, DEPARTMENT_ID
into  v_last_name, v_dep_id
from EMPLOYEES
where EMPLOYEE_ID= 105;

select DEPARTMENT_NAME, LOCATION_ID
into v_dep_name, v_loc_id
from DEPARTMENTS
where DEPARTMENT_ID= v_dep_id;
--
select  CITY, COUNTRY_ID
into  v_city, v_country_id
from LOCATIONS
where LOCATION_ID=v_loc_id;
-- 
select COUNTRY_NAME
into  v_country_name
from COUNTRIES
where COUNTRY_ID=v_country_id;
-- OUTPUT
dbms_output.put_line ('LAST_NAME = ' ||  v_last_name  || ' ,' || 'DEPARTMENT_NAME = ' ||  v_dep_name || ' ,' || 'CITY = ' ||  v_city || ' ,' || 'COUNTRY_NAME = ' ||  v_country_name);
end;

---------------------------------------------------

-- 3.  Create a PL/SQL block to calculate the bonus for employee number = 102. Bonus = 5% of current salary.
set serveroutput on
select EMPLOYEE_ID, salary from EMPLOYEES where EMPLOYEE_ID=102;
declare v_emp_id number(10);  v_salary number(15,2);  v_bonus number(15,2);
begin
select EMPLOYEE_ID, salary
into v_emp_id, v_salary
from EMPLOYEES
where EMPLOYEE_ID=102;
--
v_bonus := 0.05* v_salary;
--
dbms_output.put_line('Salary of this Employee  is:  ' ||v_salary || ', and his Updated Bonus is: ' || v_bonus  );
end;
select EMPLOYEE_ID, salary from EMPLOYEES where EMPLOYEE_ID=102;

-----------------------------------------------------

--  4.  Create a PL/SQL block to count the number of employees in the department with ID = 10.
set serveroutput on
declare v_dep_id number(5);  v_count_emp number(5); v_emp_id number(5);
begin

select count(EMPLOYEE_ID)
into v_emp_id
from EMPLOYEES
where DEPARTMENT_ID=10;

DBMS_OUTPUT.PUT_LINE('Count of Employees in dep No 10 are:  ' || v_emp_id);
end;

----------------------------------------------

-- 5. Create a PL/SQL block to find the employee id, last name with the maximum salary.
set serveroutput on
declare  v_emp_id number(5); v_last_name varchar(20); v_salary number;
begin

select employee_id, last_name, salary
into v_emp_id, v_last_name, v_salary
from employees
where salary =(select max(salary)  from employees );
--
DBMS_OUTPUT.PUT_LINE('Emp_ID = ' || v_emp_id || '   ,Last_Name = ' ||v_last_name || '    ,The Max Salary =  '|| v_salary  );
end;

----------------------------------------------

-- 6. Create a PL/SQL block to calculate the total salary of all employees.
set serveroutput on
declare v_sum_sal number(12,2);
begin

select sum(salary)
into v_sum_sal
from employees;
--
DBMS_OUTPUT.PUT_LINE('Total Salary of all Emps is :   ' ||v_sum_sal);
end;
