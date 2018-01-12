-- ALERT !!
-- THIS Code Delete every TABLE , VIEW ,PACKAGE ,PROCEDURE ,FUNCTION ,SEQUENCE ,SYNONYM ,Trigger ,PACKAGE BODY in  your user !!!
-- Don't use it if u don't understand the risk .
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'Trigger',		
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
/

-- Stop here !
-- you have to know that you will drop students and employees users by completing copying this code & dropping student and employee roles too !

-- Dropping employees
drop user E320180001;
drop user E320180002;
drop user E320180003;
drop user E320180004;
drop user E320180005;
drop user E320180006;

-- Dropping students1
drop user S120180001;
drop user S120180002;

-- Dropping students2
drop user S220180001;
drop user S220180002;
-- Dropping roles
DROP ROLE student_role;
DROP ROLE employee_role;
DROP ROLE teacher_role;
DROP ROLE manager_role;
DROP ROLE security_role;
DROP ROLE secretary_role;
-- Done

--drop jobs according to our current insertion
begin
DBMS_SCHEDULER.DROP_JOB('RVK_MNGR_E320180004_2017_1');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('RVK_SCURTY_E320180005_2017_2');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('RVK_TCHR_E320180001_2017_1');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('RVK_TCHR_E320180002_2017_1');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('RVK_TCHR_E320180003_2017_2');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('RVK_TCHR_E320180003_2018_2');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('GRNT_EMP_E320180003');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('GRNT_TCHR_E320180002_2018_1');
end;
/

begin
DBMS_SCHEDULER.DROP_JOB('RVK_TCHR_E320180002_2018_1');
end;
/


--manually check if there still existing jobs please comment 'clear scr' command if you want to check this
select job_name from user_scheduler_jobs;
