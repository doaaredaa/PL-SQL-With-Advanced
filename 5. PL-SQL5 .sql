-- 1. Create plsql block and to check for all employees using cursor; and update their commission_pct based on the salary

SALARY < 7000 : COMM = 0.1
7000 <= SALARY < 10000 COMM = 0.15
10000 <= SALARY < 15000 COMM = 0.2
15000 <= SALARY COMM = 0.25
set serveroutput on 1000000
select EMPLOYEE_ID, COMMISSION_PCT from employees
where COMMISSION_PCT is not null;
declare cursor emp_cursor is
 select EMPLOYEE_ID, COMMISSION_PCT, SALARY from employees;
 v_COMMISSION_PCT EMPLOYEES.COMMISSION_PCT%type;

begin
 for emp_record in emp_cursor loop

 if emp_record.salary < 7000 then
 v_COMMISSION_PCT := 0.1;
 elsif emp_record.salary < 10000 then
 v_COMMISSION_PCT := 0.15;
 elsif emp_record.salary < 15000 then
 v_COMMISSION_PCT := 0.2;
 else
 v_COMMISSION_PCT := 0.25;
 end if;

 update employees
 set COMMISSION_PCT = v_COMMISSION_PCT
 where EMPLOYEES.EMPLOYEE_ID= emp_record.EMPLOYEE_ID;
 end loop;
 dbms_output.put_line('Update is done successfully');
end;
select EMPLOYEE_ID, COMMISSION_PCT from employees
where COMMISSION_PCT is not null;

---------------------------------------------

-- 2. Alter table employees then add column retired_bonus Create plsql block to calculate the retired salary for all employees using cursor and update retired_bonus column
-- Retired bonus = no of working months * 10 % of his current salary Only for those employees have passed 18 years of their hired date

add retired_bonus number(20,2);
select employee_id, salary , retired_bonus from employees;
----------
declare cursor emp_cursor is
 select * from employees;
 v_Retired_bonus number(10,2);
 year_of_experience number(3);
begin
 for emp_record in emp_cursor loop

 year_of_experience :=
trunc(months_between(sysdate,emp_record.HIRE_DATE)/12);

 if year_of_experience > 18 then

 v_Retired_bonus :=months_between(sysdate,emp_record.HIRE_DATE) *
(0.10* emp_record.salary);

 update employees
 set retired_bonus=v_Retired_bonus
 where EMPLOYEES.EMPLOYEE_ID= emp_record.EMPLOYEE_ID;
 end if;

 end loop;

 DBMS_OUTPUT.PUT_LINE('----------------------------------------------
---------------------------------------------------------------------------');
end;
select employee_id, salary , retired_bonus from employees;
ALTER TABLE employees ADD (retired_bonus NUMBER);

-------------------------------------------

-- 3. Create plsql block using cursor to print last name, department name, city, country name for all employees employee ( without using join | sub query)

set serveroutput on size 1000000
declare cursor emp_cursor is
 select * from employees
 where DEPARTMENT_ID is not null;
 v_LOCATION_ID number;
 v_DEPARTMENT_NAME varchar2(100);
 v_CITY varchar(100);
 v_COUNTRY_ID char (2);
 v_DEPARTMENT_ID number;
 v_COUNTRY_NAME varchar2(40);
 v_LAST_NAME varchar(100);

begin
 for emp_record in emp_cursor loop
 select DEPARTMENT_ID, LAST_NAME
 into v_DEPARTMENT_ID,v_LAST_NAME
 from EMPLOYEES
 where EMPLOYEE_ID = emp_record.EMPLOYEE_ID;
 ----
 select LOCATION_ID, DEPARTMENT_NAME
 into v_LOCATION_ID, v_DEPARTMENT_NAME
 from DEPARTMENTS
 where DEPARTMENT_ID=v_DEPARTMENT_ID;
 ----
 select COUNTRY_ID, CITY
 into v_COUNTRY_ID,v_CITY
 from LOCATIONS
 where LOCATION_ID=v_LOCATION_ID;
 ----
 select COUNTRY_NAME
 into v_COUNTRY_NAME
 from COUNTRIES
 where COUNTRY_ID = v_COUNTRY_ID;

 DBMS_OUTPUT.PUT_LINE('Last Name: ' ||emp_record.LAST_NAME || ' & ' || '
DEPARTMENT Name: '|| v_DEPARTMENT_NAME || ' & '||
 ' City: ' || v_CITY ||' & '|| ' Country Name: ' || v_COUNTRY_NAME );

 end loop;

end;

---------------------------------------

-- 4. Create plsql block that loop over employees table and Increase only those working in ‘IT’ department by 10% of their salary.
set serveroutput on
select EMPLOYEE_ID, salary, DEPARTMENT_NAME from employees e, departments d
where e.DEPARTMENT_ID=d.DEPARTMENT_ID and d.DEPARTMENT_ID=60;
declare
 cursor emp_cursor is
 select EMPLOYEE_ID, salary from employees
 where DEPARTMENT_ID=60;
 v_DEPARTMENT_ID number;
 v_salary number(15,2);
 v_DEPARTMENT_NAME varchar(20);

begin
 for emp_record in emp_cursor loop
 select DEPARTMENT_ID, salary
 into v_DEPARTMENT_ID, v_salary
 from employees
 where EMPLOYEE_ID=emp_record.EMPLOYEE_ID;
 -------
 select DEPARTMENT_NAME
 into v_DEPARTMENT_NAME
 FROM departments
 where DEPARTMENT_ID= v_DEPARTMENT_ID;

 if v_DEPARTMENT_NAME = 'IT' then
 update employees
 set salary = (0.10*salary)+ salary
 where EMPLOYEE_ID=emp_record.EMPLOYEE_ID;
 end if;
 DBMS_OUTPUT.PUT_LINE('------------------------------------------------------
---------');

 end loop;
end;
select EMPLOYEE_ID, salary, DEPARTMENT_NAME from employees e, departments d
where e.DEPARTMENT_ID=d.DEPARTMENT_ID and d.DEPARTMENT_ID=60;
