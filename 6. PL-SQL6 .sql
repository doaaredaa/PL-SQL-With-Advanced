-- 1. Create a PL/SQL block to give a 5% bonus to all employees in the ‘Sales’ department who have a salary greater than 8000.

set serveroutput on size 1000000
select SALARY, DEPARTMENT_ID from employees where DEPARTMENT_ID=80;
declare
 cursor emp_dept_cursor is
 select e.SALARY, e.DEPARTMENT_ID, d.DEPARTMENT_NAME ,
e.EMPLOYEE_ID
 from employees e, departments d
 where e.DEPARTMENT_ID=d.DEPARTMENT_ID and
d.DEPARTMENT_NAME='Sales';
begin
 for emp_record in emp_dept_cursor loop

 if EMP_RECORD.SALARY > 8000 then
 update employees
 set SALARY = EMP_RECORD.SALARY + 0.05 * EMP_RECORD.SALARY
 where EMPLOYEE_ID= EMP_RECORD.EMPLOYEE_ID;
 end if;

 end loop;
 DBMS_OUTPUT.PUT_LINE('Bonus added successfully');
end;
select SALARY, DEPARTMENT_ID from employees where DEPARTMENT_ID=80;

-- 2. Create a PL/SQL block to calculate the average salary in each department and print it out.
declare
 cursor emp_dept_cursor is
 select avg(salary) as avg_sal, DEPARTMENT_ID
 from employees
 group by DEPARTMENT_ID;
begin
 for emp_record in emp_dept_cursor loop
 DBMS_OUTPUT.PUT_LINE( 'Avg Salary: ' || emp_record.avg_sal || ' & ' || '
DEPARTMENT_ID: ' || EMP_RECORD.DEPARTMENT_ID);
 end loop;
end;

-- 3. Create a PL/SQL block to award a 500 bonus to all employees who have been working for over 15 years and have no commission.

select salary, employee_id from employees;
declare
 cursor emp_cursor is
 select *
 from employees where COMMISSION_PCT is null;
 years_of_experience number(2);
begin
 for emp_record in emp_cursor loop
 years_of_experience := trunc(months_between(sysdate,
EMP_RECORD.HIRE_DATE)/12);
 if years_of_experience > 15 then
 update employees
 set salary = emp_record.salary + 500
 where EMPLOYEE_ID=EMP_RECORD.EMPLOYEE_ID;
 end if;

 end loop;
 DBMS_OUTPUT.PUT_LINE('-----------------------------------');
end;
select salary, employee_id from employees;

-- 4. Create a PL/SQL block that prints employees' first name, salary, and salary grade based on this range: for all employees
-- SALARY < 5000: Grade A
-- 5000 <= SALARY < 10000: Grade B
-- SALARY >= 10000: Grade C

alter table employees
add grade_salary varchar(100);
select * from employees;
declare
 cursor emp_cursor is
 select *
 from employees;
begin
 for emp_record in emp_cursor loop
 if EMP_RECORD.SALARY < 5000 then
 EMP_RECORD.GRADE_SALARY := 'Grade A';
 elsif EMP_RECORD.SALARY <10000 then
 EMP_RECORD.GRADE_SALARY := 'Grade B';
 else
 EMP_RECORD.GRADE_SALARY := 'Grade C';
 end if;
 update employees
 set grade_salary = EMP_RECORD.GRADE_SALARY
 where EMPLOYEE_ID = EMP_RECORD.EMPLOYEE_ID;
 end loop;
end;
select * from employees;

-- 5. Create a PL/SQL block that checks if any employee in the database has the same last name, and prints a message if a duplicate is found.
set serveroutput on
declare
 cursor emp_cursor is
 select last_name from employees;
 no_of_duplicate number(2);
begin
 for emp_record in emp_cursor loop
 select count(last_name)
 into no_of_duplicate
 from employees
 where last_name = EMP_RECORD.LAST_NAME;
 if no_of_duplicate > 1 then
 DBMS_OUTPUT.PUT_LINE('There is a Duplicate Found! ' ||
EMP_RECORD.LAST_NAME);
 end if;
 end loop; end;

-- 6. Create a PL/SQL block that gives a 20% salary bonus to employees in the ‘IT’
department if their hire date is before 2015.
select salary, DEPARTMENT_ID from employees;
declare
 cursor emp_cursor is
 select e.salary , e.DEPARTMENT_ID, d.DEPARTMENT_NAME, e.HIRE_DATE
as hire_date, e.EMPLOYEE_ID
 from EMPLOYEES e, DEPARTMENTS d
 where e.DEPARTMENT_ID = d.DEPARTMENT_ID
 and DEPARTMENT_NAME = 'IT';
begin
 for emp_record in emp_cursor loop
 if to_char(emp_record.hire_date, 'yyyy') < 2015 then
 update employees
 set salary = salary + 0.20 * salary
 where EMPLOYEE_ID = emp_record.EMPLOYEE_ID;
 end if;
 DBMS_OUTPUT.PUT_LINE('salary: ' || emp_record.salary);
 end loop;
end;
select salary, DEPARTMENT_ID from employees;

-- 7. Create plsql block that insert new Department
With these data
Department_id = 350
Department name = Oracle Dept
Manager id = 103
Location Id = 17
Handle exception as needed
  
-- ORA-02291: integrity constraint (HR.DEPT_LOC_FK) violated - parent key not found (Non predefined)
set serveroutput on
declare
 insert_dept_eception exception;
 pragma exception_init(insert_dept_eception, -02291);
begin
 insert into departments (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID,
LOCATION_ID)
 values (350,'Oracle',103,17);
 DBMS_OUTPUT.PUT_LINE('Data is Inserted successfully! ');
 exception
 when insert_dept_eception then
 DBMS_OUTPUT.PUT_LINE('Please Enter a Valid Data! ');
 when others then
 DBMS_OUTPUT.PUT_LINE('Please Enter a Valid Data!!! ');

 end;
