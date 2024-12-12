(Stored Functions / Stored Procedures)
-- 1. Create and invoke the ADD_LOC procedure and consider the results.
-- a) Create a procedure called ADD_LOC to insert a new Location into the LOCATIONS Provide the LOCATION_ID , STREET_ADDRESS, POSTAL_CODE , CITY, STATE_PROVINCE, COUNTRY_ID parameters.

  SELECT * FROM LOCATIONS;
create or replace procedure ADD_LOC (V_LOCATION_ID NUMBER,
V_STREET_ADDRESS VARCHAR2, V_POSTAL_CODE VARCHAR2, V_CITY VARCHAR2,
V_STATE_PROVINCE VARCHAR2, V_COUNTRY_ID CHAR)
is
begin
 INSERT INTO LOCATIONS ( LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY,
STATE_PROVINCE, COUNTRY_ID)
 VALUES (V_LOCATION_ID, V_STREET_ADDRESS, V_POSTAL_CODE, V_CITY,
V_STATE_PROVINCE, V_COUNTRY_ID);
End;

-- b) Compile the code; invoke (call ) the procedure. Query the Locations table to view the results.

EXECUTE ADD_LOC (V_LOCATION_ID=> 999, V_STREET_ADDRESS=>'9450 Kamiyacho' , V_POSTAL_CODE =>6828, V_CITY => 'Tokyo', V_STATE_PROVINCE=>'Tokyo
Prefecture' , V_COUNTRY_ID=>'JP');
SELECT * FROM LOCATIONS;
SHOW ERRORS
  
-- c) Handle Error for the Invalid Country IDs

  DECLARE
 COUNTRY_ID_EXCEPTION exception;
 pragma exception_init(COUNTRY_ID_EXCEPTION, -02284);
 BEGIN
 ADD_LOC (V_LOCATION_ID=> 999, V_STREET_ADDRESS=>'9450 Kamiya-cho' ,
V_POSTAL_CODE =>6828, V_CITY => 'Tokyo', V_STATE_PROVINCE=>'Tokyo
Prefecture' , V_COUNTRY_ID=>98);
 DBMS_OUTPUT.PUT_LINE('Data is Inserted successfully! ');
 EXCEPTION
 WHEN COUNTRY_ID_EXCEPTION THEN
 DBMS_OUTPUT.PUT_LINE('Please Enter a Valid Data! ');
 WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('Invalid Data! ');
END;
SELECT * FROM LOCATIONS;

-- 2. Create and Invoke the Query_loc Function to display the data for a certain region from Locations, Countries, regions tables in the following format " Region Name , 
-- Country Name , LOCATION_ID , STREET_ADDRESS , POSTAL_CODE , CITY " Pass Location ID as an input parameter
-- Hint : concat them in a single character variable and return it

set serveroutput on size 1000000;
create or replace Function Query_loc(v_LOCATION_ID number)
return varchar2
is
 v_all varchar2(3000);
begin
 select r.Region_Name ||', '||c.Country_Name ||' ,'|| l.LOCATION_ID || ', ' ||
l.STREET_ADDRESS || ', ' || l.POSTAL_CODE || ', ' || l.CITY
 into v_all
 from Locations l , Countries c , regions r
 where l.LOCATION_ID= v_LOCATION_ID
 and L.COUNTRY_ID =C.COUNTRY_ID
 and C.REGION_ID =R.REGION_ID;
 return v_all;
end;
show errors
  ------------------
declare
 result varchar2(32767);
begin
 result:=Query_loc(1000);
 DBMS_OUTPUT.PUT_LINE( 'The Data fro certin Location: ' || result );
end;

-- 3. Create and invoke the GET_LOC function to return the street address, city for a specified LOCATION_ID.
-- Hint : use out parameters for the city

set serveroutput on
create or replace function GET_LOC (v_CITY out varchar2 , v_LOCATION_ID number)
return varchar2
is v_STREET_ADDRESS varchar2(40);
begin
 select STREET_ADDRESS, CITY
 into v_STREET_ADDRESS, v_CITY
 from locations
 where LOCATION_ID=v_LOCATION_ID;

 return v_STREET_ADDRESS;

end;
show errors
-------------  
set serveroutput on
declare
 v_result varchar2(50); v_CITY varchar2(50);
begin
 v_result:=GET_LOC(v_CITY,1000);
 DBMS_OUTPUT.PUT_LINE( 'Result: ' || v_result );
end;

-- 4. Create a function called GET_ANNUAL_COMP to return the annual salary computed from an employee’s monthly salary and commission passed as parameters. 
-- Use the following basic formula to calculate the annual salary: (Salary*12) + (commission_pct*salary*12) Use the function in a SELECT statement
-- Hint: Function call prototype GET_ANNUAL_COMP(7000, 0.15)

set serveroutput on
create or replace function GET_ANNUAL_COMP( v_salary number ,v_COMMISSION_PCT
number )
return number
is
 v_annual_salary number (18,2);
begin
 v_annual_salary:= (v_salary*12) + (v_COMMISSION_PCT*v_salary*12);
 return v_annual_salary;
end;
show errors
 ------- 
declare
 v_result number(18,2);
begin
 v_result:=GET_ANNUAL_COMP(7000, 0.15);
 DBMS_OUTPUT.PUT_LINE('the annual salary is: ' ||v_result );
end;

-- 5. a- add RETIRED NUMBER(1) column to employees table using alter
-- b- Create and call
alter table employees
add RETIRED NUMBER(1);

-- CHECK_RETIRED FUNCTION(V_EMP_ID NUMBER, V_MAX_HIRE_YEAR NUMBER) RETURN Number; that will return 1 if employee has passed no of years >= V_MAX_HIRE_YEAR, return 0 for otherwise
-- c- create anonymous block to update the emp with set retired = 1 if this employee will retired

set serveroutput on
create or replace FUNCTION CHECK_RETIRED(V_EMP_ID NUMBER, V_MAX_HIRE_YEAR
NUMBER)
RETURN Number
is v_No_of_years number(5);
 v_HIRE_DATE date;
begin
 select HIRE_DATE
 into v_HIRE_DATE
 from employees
 where EMPLOYEE_ID=V_EMP_ID;
 v_No_of_years:=trunc(months_between(sysdate, v_HIRE_DATE)/12);
 if v_No_of_years >=V_MAX_HIRE_YEAR then
 return 1;
 else
 return 0;
 end if;
end;
show errors
  
-- c- create anonymous block to update the emp with set retired = 1 if this employee will retired

  set serveroutput on size 1000000
declare
 cursor result_cursor is
 select EMPLOYEE_ID
 from employees;
 v_result number(5);
begin
 for result_record in result_cursor loop
 v_result:=CHECK_RETIRED(result_record.EMPLOYEE_ID ,20);
 if v_result=1 then
 update employees
 set RETIRED =1
 where EMPLOYEE_ID=result_record.EMPLOYEE_ID;
 DBMS_OUTPUT.PUT_LINE('Done Successfully so result will be: ' || v_result );
 else
 update employees
 set RETIRED =0
 where EMPLOYEE_ID=result_record.EMPLOYEE_ID;
 DBMS_OUTPUT.PUT_LINE('Employee Did not retird so result will be: ' ||
v_result );
 end if;
 end loop;
 end;
select * from employees
