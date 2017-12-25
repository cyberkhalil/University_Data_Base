-- still under test
CREATE OR REPLACE PROCEDURE insert_std(
Full_name_ar  VARCHAR2 ,
Full_name_en  VARCHAR2 ,
Nationality VARCHAR2  ,
national_id  NUMBER ,
sex  CHAR ,
social_status  CHAR , 
guardian_name  VARCHAR2 ,
guardian_national_id  NUMBER ,
guardian_relation VARCHAR2 , 
birh_place  VARCHAR2  ,
date_of_birth  DATE ,
religion  VARCHAR2 ,
health_status  VARCHAR2   ,
mother_name  VARCHAR2 ,
mother_job  VARCHAR2  , 
mother_job_desc  VARCHAR2 ,
father_job  VARCHAR2 , 
father_job_desc  VARCHAR2 ,
parents_status  VARCHAR2   ,
number_of_family_members  NUMBER ,
family_university_students NUMBER , 
social_affairs  VARCHAR2  ,
phone  NUMBER ,
telephone_home  NUMBER ,
emergency_phone   NUMBER ,
email VARCHAR2 ,
password  VARCHAR2 ,
tawjihi_GPA  NUMBER ,
tawjihi_field CHAR ,
area_name  VARCHAR2 ,
city_name  VARCHAR2 ,
block_name  VARCHAR2 ,
street_name  VARCHAR2 ,
major_id  NUMBER , 
balance NUMBER )
AUTHID CURRENT_USER
IS

sex_number NUMBER(1);
year NUMBER(4) := extract (year from sysdate);
seq_count number(2);
seq_name VARCHAR2(30);
sid NUMBER(9);

BEGIN
 IF sex = 'M' then
 sex_number :=1;
 else if sex='F' then
  sex_number :=2;
  end if;
 end if;

seq_name := 'S'||sex_number||year||'_SEQ';

select count(*) into seq_count from user_sequences where SEQUENCE_NAME =seq_name;

 if seq_count = 0 then
 execute immediate 'create sequence '||seq_name|| ' start with '||sex_number||year ||'0001 maxvalue '||sex_number||year ||'9999' ;
end if;

execute immediate 'select '||seq_name||'.nextval from dual' into SID;

 execute immediate 'INSERT INTO STUDENT VALUES ('''||Full_name_ar  ||''','''||Full_name_en ||''','''||Nationality ||''','||national_id ||','''||sex  ||''','''||social_status  ||''','''|| guardian_name  ||''','||guardian_national_id  ||','''||guardian_relation ||''','''|| birh_place  ||''','''||date_of_birth  ||''','''||religion  ||''','''||health_status  ||''','''||mother_name ||''','''||mother_job  ||''','''|| mother_job_desc  ||''','''||father_job ||''','''||father_job_desc  ||''','''||parents_status  ||''','||number_of_family_members  ||','||family_university_students ||','''|| social_affairs   ||''','||phone  ||','||telephone_home  ||','||emergency_phone ||','''||email ||''','''||password  ||''','||tawjihi_GPA  ||','''||tawjihi_field ||''','''||area_name ||''','''||city_name  ||''','''||block_name ||''','''||street_name  ||''','||major_id ||','||balance ||')' ;
 --execute immediate 'CREATE USER S' ||sid|| ' IDENTIFIED BY 123456';
END;
/

show errors
