Database Triggers Lab
  
-- 1. Create trigger to audit the user updates in the employees table and tracing the salary changes And insert data in new table emp_audit table Table columns
-- employee_id , user_name , upd_time , old_sal , new_sal

  CREATE TABLE EMP_AUDIT
( EMPLOYEE_ID NUMBER(6),
 UPD_TIME DATE,
 USER_NAME VARCHAR(20),
 OLD_SAL NUMBER(12,2),
 NEW_SAL NUMBER(12,2),
 PRIMARY KEY (EMPLOYEE_ID, UPD_TIME) )
  --------
SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER UDT_EMP_SAL
AFTER UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
 INSERT INTO EMP_AUDIT (EMPLOYEE_ID, UPD_TIME, USER_NAME, OLD_SAL,NEW_SAL)
 VALUES (:OLD.EMPLOYEE_ID, SYSDATE, USER, :OLD.SALARY, :NEW.SALARY);
END;
/
SHOW ERRORS
  
--TESTING
UPDATE EMPLOYEES
SET SALARY=SALARY +1000
WHERE EMPLOYEE_ID=100;
SELECT * FROM EMP_AUDIT;

-- 2. Prevent employees from deleting the employee data after business hours.

SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER PRV_DEL_DATA
BEFORE DELETE ON EMPLOYEES
FOR EACH ROW
BEGIN
 IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
 OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
 RAISE_APPLICATION_ERROR (-20205,
 'You may only make changes during normal office hours');
 END IF;
END;
/
  
-- 3. The rows in the JOBS table store a minimum and maximum salary allowed for different JOB_ID values. You are asked to write code to ensure that employees’ 
  -- salaries fall in the range allowed for their job type. ( case for update salary )

create or replace trigger max_min_sal
before update of salary on employees
for each row
declare v_MIN_SALARY number(18,2); v_MAX_SALARY number(18,2);
begin
 select MIN_SALARY, MAX_SALARY
 into v_MIN_SALARY, v_MAX_SALARY
 from JOBS
 where JOB_ID= :new.JOB_ID;

 if :new.salary < v_MIN_SALARY or :new.salary > v_MAX_SALARY then
 RAISE_APPLICATION_ERROR (-20205, 'Salary is not between expected range: ' ||
v_MIN_SALARY || ' and ' || v_MAX_SALARY);
 end if;
end;
/
  
--Test
update employees
set SALARY = salary +50000
where employee_id=100;
show errors
  
-- 4. Create trigger to track logon / log off actions for users.

  CREATE TABLE SYS.LOG_TRIG_TABLE
(
 LOG_ID NUMBER,
 LOG_DATE DATE,
 ACTION VARCHAR2(100),
 USER_NAME VARCHAR2(100 )
);
----------------
set serveroutput on
create or replace trigger log_on_trig
after logon on database
declare
 v_LOG_ID number(7);
begin
 select nvl(max(LOG_ID),0)+1
 into v_LOG_ID
 from LOG_TRIG_TABLE;
 insert into LOG_TRIG_TABLE (LOG_ID, LOG_DATE,ACTION, USER_NAME)
 values (v_LOG_ID, sysdate,'logging on' ,user);
end;
/
---------------
set serveroutput on
create or replace trigger log_off_trig
before logoff on database
declare
 v_LOG_ID number(7);
begin
 select nvl(max(LOG_ID),0)+1
 into v_LOG_ID
 from LOG_TRIG_TABLE;
 insert into LOG_TRIG_TABLE (LOG_ID, LOG_DATE,ACTION, USER_NAME)
 values (v_LOG_ID, sysdate,'logging off' ,user);
end;
/
show errors


-- 5. Add a new column created_by (VARCHAR2(50)) | created_date with date type to all tables in the current schema using dynamic SQL.

  set serveroutput on
declare
 cursor create_col_cursor is
 select TABLE_NAME from user_tables;
begin
 for create_col_record in create_col_cursor loop
 execute immediate 'alter table ' || create_col_record.TABLE_NAME||' add (created_by
VARCHAR2(50) , created_date DATE)';
 end loop;
end;
/
show errors
 
