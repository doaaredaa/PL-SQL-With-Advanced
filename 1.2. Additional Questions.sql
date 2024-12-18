-- 1. Display the last name and the length of the last name for all employees. Label the column as "Last Name Length".
select last_name, length(last_name) as "Last Name Length"
from employees;

-- 2. Retrieve the first name, hire date, and salary of employees who were hired before 2005 and have a salary greater than $4000.
select FIRST_NAME || ' ' ||  LAST_NAME as Full_Name, HIRE_DATE, SALARY
from employees
where SALARY > 4000
AND EXTRACT(YEAR FROM HIRE_DATE) < 2005;
----------------------
select FIRST_NAME || ' ' ||  LAST_NAME as Full_Name, HIRE_DATE, SALARY
from employees
where SALARY > 4000
AND HIRE_DATE < TO_DATE('01-JAN-2005', 'DD-MON-YYYY');
---------------------

-- 3. Find employees whose first name starts with 'A' or ends with 'n'. Display their first name, last name, and job ID.
select E.FIRST_NAME, E.LAST_NAME, E.JOB_ID
from employees e
where FIRST_NAME like 'A%'
or FIRST_NAME like '%_n';
----------------------------
select E.FIRST_NAME, E.LAST_NAME, E.JOB_ID
from employees e
where instr(FIRST_NAME, 'A') =1
or instr(FIRST_NAME, 'n',-1) = length(FIRST_NAME);
-------------------------
select E.FIRST_NAME, E.LAST_NAME, E.JOB_ID
from employees e
where regexp_like(FIRST_NAME, '^A')
or regexp_like(FIRST_NAME, 'n$');
----
select E.FIRST_NAME, E.LAST_NAME, E.JOB_ID
from employees e
WHERE REGEXP_LIKE(FIRST_NAME, '^A|n$');
------
-- 4. Display the last name, department ID, and phone number of employees whose phone numbers contain a hyphen ('.').
select E.LAST_NAME, E.DEPARTMENT_ID, E.PHONE_NUMBER
from employees e
where e.PHONE_NUMBER like '%.%';

--5. Show the first name, email, and job ID for employees whose email starts with the letter 'j' and ends with 'mail.com'.
select E.FIRST_NAME, E.EMAIL, E.JOB_ID
from employees e
where instr(EMAIL,'j')=1
and regexp_like(EMAIL, 'mail.com$');
--------
SELECT E.FIRST_NAME, E.EMAIL, E.JOB_ID
FROM EMPLOYEES E
WHERE E.EMAIL LIKE 'j%mail.com';
-----------
SELECT E.FIRST_NAME, E.EMAIL, E.JOB_ID
FROM EMPLOYEES E
WHERE SUBSTR(E.EMAIL, 1, 1) = 'j'
  AND E.EMAIL LIKE '%mail.com';
------------
-- 6. List the last name, salary, and commission percentage of employees whose commission percentage is not null and salary exceeds $7000.
select E.LAST_NAME, E.SALARY, E.COMMISSION_PCT
from employees e
where COMMISSION_PCT is not null
and SALARY >7000;

--7. Extract the first two characters of the last name and display them as initials, separated by a hyphen ('-'). Label the column as "Initials".
select substr(LAST_NAME,1,1) || '-' || substr(LAST_NAME,2,1) as initials
from employees ;

--8. Replace all underscores (_) with spaces in the job_title column and display the updated job titles.
select replace(JOB_TITLE, ' ', '_') as JOB_TITLE
from jobs;

--9. Retrieve the job ID and salary of employees whose salary is a multiple of 1000.
select E.JOB_ID, E.SALARY
from employees e
where mod(salary ,1000)=0;
-- mod(salary ,1000)=0; This checks if the remainder when dividing the salary by 1000 is 0, which ensures the salary is a multiple of 1000.

--10. Display the first name, last name, and department ID of employees whose department ID is not between 40 and 70.
select E.FIRST_NAME, E.LAST_NAME, E.DEPARTMENT_ID
from employees e
where E.DEPARTMENT_ID not between 40 and 70;

-- 12. Write a query to display the bonus for employees based on their job ID. Use the following logic:
select E.SALARY, E.JOB_ID,
            case JOB_ID when 'SA_REP' then 0.15
                              when 'IT_PROG' then 0.10
                              when 'AD_ASST' then 0.8
                              else 0.5
                              end as Bonus
from employees e;
