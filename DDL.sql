-- DDL:-

-- 1
CREATE TABLE address (
area_name VARCHAR2(30),
city_name VARCHAR2(30),
block_name VARCHAR2(30), 
street_name VARCHAR2(30), 
CONSTRAINT adrs_pk PRIMARY KEY (area_name,street_name,block_name,city_name));

-- 2
CREATE TABLE  nationality(
nationality VARCHAR2(20) PRIMARY KEY);

-- 3
CREATE TABLE employee (
employee_id NUMBER(9) PRIMARY KEY,
full_name_ar VARCHAR2(100) NOT NULL,
full_name_en VARCHAR2(100) NOT NULL,
nationality VARCHAR2(20) NOT NULL REFERENCES nationality (nationality),
national_id NUMBER(9) NOT NULL, --no unique required becuase emp can get employeed more than once
sex CHAR NOT NULL ,
social_status CHAR NOT NULL, 
salary NUMBER (8,2) CHECK ( salary >=0),
birh_place  VARCHAR2(10) NOT NULL ,
date_of_birth DATE NOT NULL,
religion VARCHAR2(20)  NOT NULL,
health_status VARCHAR2(40) NOT NULL,
number_of_family_members NUMBER(2) NOT NULL,
phone NUMBER(12) NOT NULL,
telephone_home NUMBER(9),
email VARCHAR2(30) NOT NULL,
password VARCHAR2(30) NOT NULL,
area_name VARCHAR2(30) NOT NULL,
city_name VARCHAR2(30) NOT NULL,
block_name VARCHAR2(30) NOT NULL,
street_name VARCHAR2(30) NOT NULL,
CONSTRAINT emp_sex_chk CHECK (sex IN ('M' , 'F')),
CONSTRAINT emp_social_status_chk CHECK ( social_status  IN ('S','M','D' ) ),
CONSTRAINT EMP_FK_ADRES FOREIGN KEY (area_name,city_name,block_name,street_name) REFERENCES Address(area_name,city_name,block_name,street_name));

-- 4
CREATE TABLE building (
building_code CHAR (1) PRIMARY KEY,
building_desc VARCHAR2(100) );

-- 5
CREATE TABLE floor (
floor_number NUMBER(2),
building_code CHAR(1) REFERENCES building(building_code),
floor_desc VARCHAR2(100),
PRIMARY KEY (building_code, floor_number));

-- 6
CREATE TABLE room (
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
capacity NUMBER (5) NOT NULL,
FOREIGN KEY (building_code,floor_number) REFERENCES floor(building_code,floor_number),
PRIMARY KEY (building_code ,floor_number,room_number));

-- 7
CREATE TABLE department (
department_id NUMBER (3) PRIMARY KEY,
department_name VARCHAR2(30) NOT NULL UNIQUE,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
FOREIGN KEY (building_code,floor_number,room_number) REFERENCES room (building_code,floor_number,room_number) );

-- 8
CREATE TABLE majors_department (
majors_department_id NUMBER (3) PRIMARY KEY ,
majors_department_name VARCHAR2(30) NOT NULL UNIQUE,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
FOREIGN KEY (building_code,floor_number,room_number) REFERENCES room (building_code,floor_number,room_number) );

-- 9
CREATE TABLE major (
major_id NUMBER (3) PRIMARY KEY,
major_name VARCHAR2(30) NOT NULL UNIQUE,
majors_department_id NUMBER (3) REFERENCES majors_department (majors_department_id) );

-- 10
CREATE TABLE course (
course_id VARCHAR2(10) PRIMARY KEY ,
course_name VARCHAR2(30) NOT NULL,
credit NUMBER (1) NOT NULL,
clevel NUMBER(1) NOT NULL,
description LONG, 
majors_department_id NUMBER (3) REFERENCES Majors_Department (majors_department_id) );

-- 11
CREATE TABLE pre_required_courses (
course_id VARCHAR2(10) REFERENCES course(course_id) ,
pre_required_course_id VARCHAR2(10) REFERENCES course(course_id),
PRIMARY KEY (course_id,pre_required_course_id));

-- 12
CREATE TABLE teacher (
teacher_id NUMBER (9) REFERENCES employee(employee_id) PRIMARY KEY,
employment_start_date DATE DEFAULT sysdate,
employment_end_date DATE,
majors_department_id NUMBER (3) REFERENCES majors_department (majors_department_id),
salary NUMBER (8,2) check (salary >=0) );

-- 13
CREATE TABLE manager (
manager_id NUMBER (9) REFERENCES employee(employee_id) PRIMARY KEY,
employment_start_date DATE DEFAULT sysdate,
employment_end_date DATE,
salary NUMBER (8,2) check (salary >=0),
manager_grade VARCHAR2(15) NOT NULL,
majors_department_id NUMBER (3) REFERENCES majors_department (majors_department_id) ,
department_id NUMBER (3) REFERENCES department (department_id) ,
check ( (majors_department_id IN NULL AND  department_id IS NOT NULL) OR (department_id IS NULL AND majors_department_id IS NOT NULL) )  );

-- 14
CREATE TABLE security (
security_id NUMBER (9) REFERENCES employee(employee_id) PRIMARY KEY ,
employment_start_date DATE DEFAULT sysdate,
employment_end_date DATE,
salary NUMBER (8,2) check (salary >=0),
department_id NUMBER (3) REFERENCES department (department_id) );

-- 15
CREATE TABLE secretary (
secretary_id NUMBER (9) REFERENCES employee(employee_id) PRIMARY KEY,
employment_start_date DATE DEFAULT sysdate,
employment_end_date DATE,
majors_department_id NUMBER (3) REFERENCES majors_department (majors_department_id) ,
department_id NUMBER (3) REFERENCES department (department_id) ,
check ( (majors_department_id IN NULL AND  department_id IS NOT NULL) OR (department_id IS NULL AND majors_department_id IS NOT NULL) ) );

-- 16
CREATE TABLE item (
item_id NUMBER (3) PRIMARY KEY,
item_name VARCHAR2(30) NOT NULL,
item_description VARCHAR2(200) NOT NULL);

-- 17
CREATE TABLE room_items (
item_id NUMBER (3) REFERENCES item (item_id) ,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
FOREIGN KEY (building_code,floor_number,room_number) REFERENCES room (building_code,floor_number,room_number) ,
quantity NUMBER (5) NOT NULL,
PRIMARY KEY (item_id , room_number));

-- 18
CREATE TABLE study_plan (
plan_number NUMBER (3),
major_id NUMBER (3) REFERENCES major (major_id) ,
PRIMARY KEY (plan_number, major_id));

-- 19
CREATE TABLE study_plan_courses (
plan_number NUMBER (3),
major_id NUMBER (3),
course_id VARCHAR2(10) REFERENCES course (course_id),
year DATE NOT NULL,
semester NUMBER (1) ,
FOREIGN KEY (plan_number, major_id) REFERENCES study_plan (plan_number, major_id),
PRIMARY KEY (plan_number, major_id, course_id),
CONSTRAINT stdy_pln_smstr_chk CHECK (semester IN (1,2,3)));

-- 20
CREATE TABLE student (
sid NUMBER(9) PRIMARY KEY,
full_name_ar VARCHAR2(100) NOT NULL,
full_name_en VARCHAR2(100) NOT NULL,
nationality VARCHAR2(20) NOT NULL REFERENCES nationality (nationality) ,
national_id NUMBER(9) NOT NULL,
sex CHAR NOT NULL ,
social_status CHAR NOT NULL , 
guardian_name  VARCHAR2(30) NOT NULL,
guardian_national_id NUMBER(9) NOT NULL,
guardian_relation VARCHAR2(10) NOT NULL, 
birh_place VARCHAR2(10) NOT NULL ,
date_of_birth DATE NOT NULL,
religion VARCHAR2(20) NOT NULL,
health_status VARCHAR2(40) NOT NULL  ,
mother_name VARCHAR2(30) NOT NULL,
mother_job VARCHAR2(20) NOT NULL , 
mother_job_desc VARCHAR2(100) NOT NULL,
father_job VARCHAR2(20) NOT NULL , 
father_job_desc VARCHAR2(100) NOT NULL,
parents_status VARCHAR2(30) NOT NULL ,
number_of_family_members NUMBER(2) NOT NULL,
family_university_students NUMBER(2) NOT NULL, 
social_affairs VARCHAR2(40) NOT NULL ,
phone NUMBER(12) ,
telephone_home NUMBER(9) ,
emergency_phone NUMBER(12) NOT NULL,
email VARCHAR2(30) ,
password VARCHAR2(30) NOT NULL,
tawjihi_GPA NUMBER(4,2) NOT NULL,
tawjihi_field CHAR NOT NULL,
area_name VARCHAR2(30) NOT NULL,
city_name VARCHAR2(30) NOT NULL,
block_name VARCHAR2(30) NOT NULL,
street_name VARCHAR2(30) NOT NULL,
major_id NUMBER(3) NOT NULL REFERENCES major(major_id) ,
balance NUMBER(5) NOT NULL,
FOREIGN KEY (area_name,city_name,block_name,street_name) REFERENCES address(area_name,city_name,block_name,street_name),
CONSTRAINT stdnt_sex_chk CHECK (sex IN ('M' , 'F')),
CONSTRAINT stdnt_social_status_chk CHECK ( social_status  IN ('S','M','D' ) ),
CONSTRAINT stdnt_twj_fld_chk CHECK (tawjihi_field  IN ('S' , 'L' )));

-- 21
CREATE TABLE academic_advice (
teacher_id NUMBER (9) REFERENCES teacher (teacher_id) ,
sid NUMBER(9) REFERENCES student (sid) ,
year DATE DEFAULT sysdate, 
semester NUMBER (1),
PRIMARY KEY (teacher_id, sid, year, semester),
CONSTRAINT acdmic_advc_smstr_chk CHECK (semester IN (1,2,3)));

-- 22
CREATE TABLE section (
section_number NUMBER (3),
course_id VARCHAR2(10) REFERENCES course (course_id) ,
year DATE DEFAULT sysdate,
semester NUMBER (1) ,
teacher_id NUMBER(9) REFERENCES teacher (teacher_id) ,
PRIMARY KEY (section_number, course_id, year, semester),
CONSTRAINT section_smstr_chk CHECK (semester IN (1,2,3)));

-- 23
CREATE TABLE enroll (
sid NUMBER(9) REFERENCES student (sid) ,
course_id VARCHAR2(10) ,
section_number NUMBER(3) ,
year DATE DEFAULT sysdate, 
semester NUMBER(1) ,
grade_mid NUMBER (2) DEFAULT NULL ,
grade_final NUMBER (3) DEFAULT NULL,
FOREIGN KEY (section_number , course_id , year , semester) REFERENCES section (section_number , course_id , year , semester) ,
PRIMARY KEY (sid , course_id , section_number , year , semester),
CONSTRAINT eroll_grade_chk CHECK ((grade_final+grade_mid >=40)and (grade_final+grade_mid <=100 )));

-- 24
CREATE TABLE section_rooms (
section_number NUMBER (3) ,
course_id VARCHAR2 (10) ,
year DATE DEFAULT sysdate, 
semester NUMBER (1) ,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
FOREIGN KEY (building_code,floor_number,room_number) REFERENCES room (building_code,floor_number,room_number) ,
day DATE NOT NULL,
start_time DATE ,
end_time DATE ,
FOREIGN KEY (section_number , course_id , year , semester ) REFERENCES section (section_number , course_id , year , semester ) ,
PRIMARY KEY (building_code,floor_number, year , semester, room_number, start_time,day));

--------------------------------------------------------------------------------------------------------------------

CREATE TABLE Address_log (
street_name VARCHAR2(30) NOT NULL,
block_name VARCHAR2(30) NOT NULL, 
city_name VARCHAR2(30) NOT NULL, 
area_name VARCHAR2(30) NOT NULL, 
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_address_trgr after insert on address 
for each row
begin
insert into address_log values (:new.street_name ,:new.block_name ,:new.city_name ,:new.area_name ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_address_trgr after update on address
for each row 
begin 
insert into ADDRESS_LOG values (:old.street_name ,:old.block_name ,:old.city_name ,:old.area_name , 'delete',DEFAULT,DEFAULT );
insert into ADDRESS_LOG values (:new.street_name ,:new.block_name ,:new.city_name ,:new.area_name , 'insert',DEFAULT,DEFAULT ); 
end;
 /
 
CREATE OR REPLACE TRIGGER ad_address_trgr after delete on address 
for each row 
begin 
insert into ADDRESS_LOG values (:old.street_name ,:old.block_name ,:old.city_name ,:old.area_name ,'delete' ,DEFAULT ,DEFAULT );
end;
 /

CREATE TABLE employee_log (
employee_id NUMBER(9) ,
Full_name_ar  VARCHAR2(100) NOT NULL,
Full_name_en  VARCHAR2(100) NOT NULL,
Nationality VARCHAR2(20) NOT NULL,
national_id  NUMBER(9) NOT NULL,
sex CHAR  NOT NULL ,
social_status CHAR NOT NULL, 
salary NUMBER (8,2) CHECK ( salary >=0),
birh_place  VARCHAR2(10) NOT NULL ,
date_of_birth DATE NOT NULL,
religion VARCHAR2(20)  NOT NULL,
health_status  VARCHAR2(40) NOT NULL,
number_of_family_members NUMBER(2) NOT NULL,
phone  NUMBER(12) NOT NULL,
telephone_home NUMBER(9),
email VARCHAR2(30) NOT NULL,
password  VARCHAR2(30) NOT NULL,
area_name  VARCHAR2(30) NOT NULL,
city_name  VARCHAR2(30) NOT NULL,
block_name  VARCHAR2(30) NOT NULL,
street_name  VARCHAR2(30) NOT NULL,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_employee_trgr after insert on employee
for each row
begin
insert into employee_log values (:new.employee_id ,:new.Full_name_ar ,:new.Full_name_en ,:new.nationality ,:new.national_id 
,:new.sex ,:new.social_status ,:new.salary ,:new.birh_place , :new.date_of_birth ,:new.religion ,:new.health_status ,:new.number_of_family_members 
,:new.phone ,:new.telephone_home ,:new.email ,:new.password ,:new.area_name ,:new.city_name ,:new.block_name  ,:new.street_name ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_employee_trgr after update on employee
for each row 
begin
insert into employee_log values (:old.employee_id ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality  ,:old.national_id,:new.sex  ,:old.social_status  ,:old.salary  ,:old.birh_place,:old.date_of_birth ,:old.religion  ,:old.health_status ,:old.number_of_family_members ,:old.phone ,:old.telephone_home ,:old.email ,:old.password ,:old.area_name ,:old.city_name  ,:old.block_name  ,:old.street_name  ,'delete' ,DEFAULT ,DEFAULT );
insert into employee_log values (:new.employee_id ,:new.Full_name_ar ,:new.Full_name_en ,:new.nationality  ,:new.national_id,:new.sex  ,:new.social_status  ,:new.salary  ,:new.birh_place,:new.date_of_birth ,:new.religion  ,:new.health_status ,:new.number_of_family_members ,:new.phone ,:new.telephone_home ,:new.email ,:new.password ,:new.area_name ,:new.city_name  ,:new.block_name  ,:new.street_name  ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_employee_trgr after delete on employee
for each row 
begin 
insert into employee_log values (:old.employee_id ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality  ,:old.national_id,:old.sex  ,:old.social_status  ,:old.salary  ,:old.birh_place, :old.date_of_birth ,:old.religion  ,:old.health_status ,:old.number_of_family_members,:old.phone  ,:old.telephone_home ,:old.email ,:old.password ,:old.area_name ,:old.city_name  ,:old.block_name  ,:old.street_name  ,'delete' ,DEFAULT ,DEFAULT );
end;
 /
CREATE TABLE building_log (
building_code CHAR (1) ,
building_desc VARCHAR2 (100),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL );

CREATE OR REPLACE TRIGGER ai_building_trgr after insert on building
for each row
begin
insert into building_log values (:new.building_code,:new.building_desc ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_building_trgr after update on building
for each row 
begin 
insert into building_log values (:old.building_code,:old.building_desc,'delete' ,DEFAULT,DEFAULT );
insert into building_log values (:new.building_code,:new.building_desc,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_building_trgr after delete on building
for each row 
begin 
insert into building_log values (:old.building_code,:old.building_desc,'delete' ,DEFAULT,DEFAULT );
end;
 /


CREATE TABLE floor_log (
floor_number NUMBER (2),
building_code CHAR (1),
floor_desc VARCHAR2 (100),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL );

CREATE OR REPLACE TRIGGER ai_floor_trgr after insert on floor
for each row
begin
insert into floor_log values (:new.floor_number ,:new.building_code,:new.floor_desc ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_floor_trgr after update on floor
for each row 
begin 
insert into floor_log values (:old.floor_number ,:old.building_code,:old.floor_desc ,'delete' ,DEFAULT,DEFAULT );
insert into floor_log values (:new.floor_number ,:new.building_code,:new.floor_desc ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_floor_trgr after delete on floor
for each row 
begin 
insert into floor_log values (:old.floor_number ,:old.building_code,:old.floor_desc,'delete' , DEFAULT ,DEFAULT );
end;
 /
 
 
CREATE TABLE room_log (
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
capacity NUMBER (5) NOT NULL,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_room_trgr after insert on room
for each row
begin
insert into room_log values (:new.room_number ,:new.floor_number ,:new.building_code,:new.capacity ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_room_trgr after update on room
for each row 
begin
insert into room_log values (:old.room_number ,:old.floor_number ,:old.building_code,:old.capacity ,'delete' ,DEFAULT,DEFAULT ); 
insert into room_log values (:new.room_number ,:new.floor_number ,:new.building_code,:new.capacity ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_room_trgr after delete on room
for each row 
begin 
insert into room_log values (:old.room_number ,:old.floor_number ,:old.building_code,:old.capacity ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /
 
 
CREATE TABLE Department_log (
Department_id NUMBER (3),
Department_name VARCHAR2(30) NOT NULL UNIQUE,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);


CREATE OR REPLACE TRIGGER ai_Department_trgr after insert on Department
for each row
begin
insert into Department_log values (:new.Department_id ,:new.Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_Department_trgr after update on Department
for each row 
begin
insert into Department_log values (:old.Department_id ,:old.Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
insert into Department_log values (:new.Department_id ,:new.Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Department_trgr after delete on Department
for each row 
begin 
insert into Department_log values (:old.Department_id ,:old.Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
end;
 /
 
 
CREATE TABLE Majors_Department_log (
Majors_Department_id NUMBER (3),
Majors_Department_name VARCHAR2(30) NOT NULL ,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_Majors_Department_trgr after insert on Majors_Department
for each row
begin
insert into Majors_Department_log values (:new.Majors_Department_id ,:new.Majors_Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_Majors_Department_trgr after update on Majors_Department
for each row 
begin
insert into Majors_Department_log values (:old.Majors_Department_id ,:old.Majors_Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
insert into Majors_Department_log values (:new.Majors_Department_id ,:new.Majors_Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'insert',DEFAULT,DEFAULT); 
end;
/
CREATE OR REPLACE TRIGGER ad_Majors_Department_trgr after delete on Majors_Department
for each row 
begin 
insert into Majors_Department_log values (:old.Majors_Department_id ,:old.Majors_Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
end;
 /
 
 
CREATE TABLE major_log (
major_id NUMBER (3) ,
major_name VARCHAR2(30) NOT NULL ,
Majors_Department_id NUMBER (3) ,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_major_trgr after insert on major
for each row
begin
insert into major_log values (:new.major_id ,:new.major_name ,:new.Majors_Department_id ,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_major_trgr after update on major
for each row 
begin
insert into major_log values (:old.major_id ,:old.major_name ,:old.Majors_Department_id ,'delete',DEFAULT,DEFAULT); 
insert into major_log values (:new.major_id ,:new.major_name ,:new.Majors_Department_id ,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER ad_major_trgr after delete on major
for each row 
begin 
insert into major_log values (:old.major_id ,:old.major_name ,:old.Majors_Department_id ,'delete',DEFAULT,DEFAULT); 
end;
 /
 
 
CREATE TABLE course_log (
course_id VARCHAR2(10),
course_name VARCHAR2(30) NOT NULL,
credit NUMBER (1) NOT NULL,
clevel NUMBER (1) NOT NULL,
Majors_Department_id NUMBER (3),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_course_trgr after insert on course
for each row
begin
insert into course_log values (:new.course_id ,:new.course_name ,:new.credit , :new.clevel ,:new.Majors_Department_id ,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_course_trgr after update on course
for each row 
begin
insert into course_log values (:old.course_id ,:old.course_name ,:old.credit , :old.clevel ,:old.Majors_Department_id,'Delete',DEFAULT,DEFAULT); 
insert into course_log values (:new.course_id ,:new.course_name ,:new.credit , :new.clevel ,:new.Majors_Department_id,'insert',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER ad_course_trgr after delete on course
for each row 
begin 
insert into course_log values (:old.course_id ,:old.course_name ,:old.credit , :old.clevel ,:old.Majors_Department_id,'Delete',DEFAULT,DEFAULT); 
end;
 /


CREATE TABLE teacher_log (
Teacher_id NUMBER (9),
Employment_Start_Date DATE,
Employment_End_Date DATE,
majors_department_id NUMBER (3),
salary NUMBER (8,2) check (salary >=0),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_teacher_trgr after insert on teacher
for each row
begin
insert into teacher_log values (:new.Teacher_id ,:new.Employment_Start_Date ,:new.Employment_End_Date,:new.Majors_Department_id,:new.salary ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_teacher_trgr after update on teacher
for each row 
begin
insert into teacher_log values (:old.Teacher_id ,:old.Employment_Start_Date ,:old.Employment_End_Date,:old.Majors_Department_id,:old.salary ,'delete' ,DEFAULT,DEFAULT ); 
insert into teacher_log values (:new.Teacher_id ,:new.Employment_Start_Date ,:new.Employment_End_Date,:new.Majors_Department_id,:new.salary ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_teacher_trgr after delete on teacher
for each row 
begin 
insert into teacher_log values (:old.Teacher_id ,:old.Employment_Start_Date ,:old.Employment_End_Date,:old.Majors_Department_id,:old.salary ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /
 
 
CREATE TABLE Manager_log (
Manager_id NUMBER (9) ,
Employment_Start_Date DATE DEFAULT sysdate,
Employment_End_Date DATE,
salary NUMBER (8,2) check (salary >=0),
Manager_Grade VARCHAR2(15) NOT NULL,
Majors_Department_id NUMBER (3) ,
Department_id NUMBER (3) ,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_Manager_trgr after insert on Manager
for each row
begin
insert into Manager_log values (:new.Manager_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Manager_Grade ,:new.Majors_Department_id ,:new.Department_id ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_Manager_trgr after update on Manager
for each row 
begin
insert into Manager_log values (:old.Manager_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Manager_Grade ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
insert into Manager_log values (:new.Manager_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Manager_Grade ,:new.Majors_Department_id ,:new.Department_id ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Manager_trgr after delete on Manager
for each row 
begin 
insert into Manager_log values (:old.Manager_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Manager_Grade ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /
 
 
CREATE TABLE Security_log (
Security_id NUMBER (9) ,
Employment_Start_Date DATE DEFAULT sysdate,
Employment_End_Date DATE,
salary NUMBER (8,2) ,
Department_id NUMBER (3),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_Security_trgr after insert on Security
for each row
begin
insert into Security_log values (:new.Security_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Department_id,'insert' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE OR REPLACE TRIGGER au_Security_trgr after update on Security
for each row 
begin
insert into Security_log values (:old.Security_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Department_id,'delete' ,DEFAULT,DEFAULT ); 
insert into Security_log values (:new.Security_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Department_id,'insert' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE OR REPLACE TRIGGER ad_Security_trgr after delete on Security
for each row 
begin 
insert into Security_log values (:old.Security_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Department_id,'delete' ,DEFAULT,DEFAULT ); 
end;
 /
 
 
CREATE TABLE Secretary_log (
Secretary_id NUMBER (9) ,
Employment_Start_Date DATE DEFAULT sysdate,
Employment_End_Date DATE,
Majors_Department_id NUMBER (3) ,
Department_id NUMBER (3),
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);


CREATE OR REPLACE TRIGGER ai_Secretary_trgr after insert on Secretary 
for each row
begin
insert into Secretary_log values (:new.Secretary_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.Majors_Department_id ,:new.Department_id ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_Secretary_trgr after update on Secretary
for each row 
begin 
insert into Secretary_log values (:old.Secretary_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
insert into Secretary_log values (:new.Secretary_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.Majors_Department_id ,:new.Department_id ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Secretary_trgr after delete on Secretary 
for each row 
begin 
insert into Secretary_log values (:old.Secretary_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /


CREATE TABLE item_log (
item_id NUMBER (3) ,
item_name VARCHAR2(30) ,
item_description VARCHAR2(200),
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_item_trgr after insert on item 
for each row
begin
insert into item_log values (:new.item_id ,:new.item_name ,:new.item_description ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_item_trgr after update on item
for each row 
begin 
insert into item_log values (:old.item_id ,:old.item_name ,:old.item_description ,'delete' ,DEFAULT,DEFAULT ); 
insert into item_log values (:new.item_id ,:new.item_name ,:new.item_description ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_item_trgr after delete on item 
for each row 
begin 
insert into item_log values (:old.item_id ,:old.item_name ,:old.item_description ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /


CREATE TABLE room_items_log (
item_id NUMBER (3) ,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
quantity NUMBER (5),
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_room_items_trgr after insert on room_items 
for each row
begin
insert into room_items_log values (:new.item_id ,:new.room_number ,:new.floor_number ,:new.building_code ,:new.quantity ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_room_items_trgr after update on room_items
for each row 
begin 
insert into room_items_log values (:old.item_id ,:old.room_number ,:old.floor_number ,:old.building_code ,:old.quantity ,'insert' ,DEFAULT,DEFAULT ); 
insert into room_items_log values (:new.item_id ,:new.room_number ,:new.floor_number ,:new.building_code ,:new.quantity ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_room_items_trgr after delete on room_items 
for each row 
begin 
insert into room_items_log values (:old.item_id ,:old.room_number ,:old.floor_number ,:old.building_code ,:old.quantity ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /


CREATE TABLE study_plan_log (
plan_number NUMBER (3),
major_id NUMBER (3),
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_study_plan_trgr after insert on study_plan 
for each row
begin
insert into study_plan_log values (:new.plan_number ,:new.major_id ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_study_plan_trgr after update on study_plan
for each row 
begin 
insert into study_plan_log values (:old.plan_number ,:old.major_id ,'delete' ,DEFAULT,DEFAULT ); 
insert into study_plan_log values (:new.plan_number ,:new.major_id ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_study_plan_trgr after delete on study_plan 
for each row 
begin 
insert into study_plan_log values (:old.plan_number ,:old.major_id ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE TABLE academic_advice_log (
teacher_id NUMBER (9),
sid NUMBER(9),
year DATE DEFAULT sysdate, 
semester NUMBER (1) ,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_academic_advice_trgr after insert on academic_advice
for each row
begin
insert into academic_advice_log values (:new.teacher_id ,:new.sid ,:new.year ,:new.semester,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_academic_advice_trgr after update on academic_advice
for each row 
begin
insert into academic_advice_log values (:old.teacher_id ,:old.sid ,:old.year ,:old.semester,'delete' ,DEFAULT ,DEFAULT );
insert into academic_advice_log values (:new.teacher_id ,:new.sid ,:new.year ,:new.semester,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_academic_advice_trgr after delete on academic_advice
for each row 
begin 
insert into academic_advice_log values (:old.teacher_id ,:old.sid ,:old.year ,:old.semester,'delete' ,DEFAULT ,DEFAULT );
end;
 /


CREATE TABLE section_log (
section_number NUMBER (3),
course_id VARCHAR2(10) ,
year DATE DEFAULT sysdate,
semester NUMBER (1),
teacher_id NUMBER(9),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_section_trgr after insert on section
for each row
begin
insert into section_log values (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.teacher_id,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_section_trgr after update on section
for each row 
begin
insert into section_log values (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.teacher_id,'delete' ,DEFAULT ,DEFAULT );
insert into section_log values (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.teacher_id,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_section_trgr after delete on section
for each row 
begin 
insert into section_log values (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.teacher_id,'delete' ,DEFAULT ,DEFAULT );
end;
 /


CREATE TABLE enroll_log (
sid NUMBER(9),
course_id VARCHAR2(10) ,
section_number NUMBER(3) ,
year DATE DEFAULT sysdate, 
semester NUMBER(1) ,
grade_mid NUMBER (2) ,
grade_final NUMBER (3),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_enroll_trgr after insert on enroll
for each row
begin
insert into enroll_log values (:new.sid ,:new.course_id ,:new.section_number ,:new.year ,:new.semester ,:new.grade_mid ,:new.grade_final ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_enroll_trgr after update on enroll
for each row 
begin
insert into enroll_log values (:old.sid ,:old.course_id ,:old.section_number ,:old.year ,:old.semester ,:old.grade_mid ,:old.grade_final ,'delete' ,DEFAULT ,DEFAULT );
insert into enroll_log values (:new.sid ,:new.course_id ,:new.section_number ,:new.year ,:new.semester ,:new.grade_mid ,:new.grade_final ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_enroll_trgr after delete on enroll
for each row 
begin 
insert into enroll_log values (:old.sid ,:old.course_id ,:old.section_number ,:old.year ,:old.semester ,:old.grade_mid ,:old.grade_final ,'delete' ,DEFAULT ,DEFAULT );
end;
 /


CREATE TABLE section_rooms_log (
section_number NUMBER (3) ,
course_id VARCHAR2 (10) ,
year DATE DEFAULT sysdate, 
semester NUMBER (1),
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
day DATE ,
start_time DATE ,
end_time DATE ,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_section_rooms_trgr after insert on section_rooms
for each row
begin
insert into section_rooms_log values (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.room_number,:new.floor_number ,:new.building_code ,:new.day ,:new.start_time ,:new.end_time ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_section_rooms_trgr after update on section_rooms
for each row 
begin
insert into section_rooms_log values (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.room_number,:old.floor_number ,:old.building_code ,:old.day ,:old.start_time ,:old.end_time ,'delete' ,DEFAULT ,DEFAULT );
insert into section_rooms_log values (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.room_number,:new.floor_number ,:new.building_code ,:new.day ,:new.start_time ,:new.end_time ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_section_rooms_trgr after delete on section_rooms
for each row 
begin 
insert into section_rooms_log values (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.room_number,:old.floor_number ,:old.building_code ,:old.day ,:old.start_time ,:old.end_time ,'delete' ,DEFAULT ,DEFAULT );
end;
 /
 
CREATE TABLE student_log (
sid NUMBER(9),
Full_name_ar  VARCHAR2(100) ,
Full_name_en  VARCHAR2(100) ,
Nationality VARCHAR2(20) ,
national_id  NUMBER(9) ,
sex  CHAR ,
social_status  CHAR , 
guardian_name  VARCHAR2(30),
guardian_national_id  NUMBER(9),
guardian_relation VARCHAR2(10) , 
birh_place  VARCHAR2(10) ,
date_of_birth  DATE ,
religion  VARCHAR2(20)  ,
health_status  VARCHAR2(40) ,
mother_name  VARCHAR2(30) ,
mother_job  VARCHAR2(20)  , 
mother_job_desc  VARCHAR2(100) ,
father_job  VARCHAR2(20) , 
father_job_desc  VARCHAR2(100) ,
parents_status  VARCHAR2(30) ,
number_of_family_members  NUMBER(2) ,
family_university_students NUMBER(2) , 
social_affairs  VARCHAR2(40) ,
phone  NUMBER(12) ,
telephone_home NUMBER(8) ,
emergency_phone NUMBER(12) ,
email VARCHAR2(30) ,
password  VARCHAR2(30) ,
tawjihi_GPA  NUMBER(4,2) ,
tawjihi_field CHAR ,
area_name  VARCHAR2(30) ,
city_name  VARCHAR2(30) ,
block_name  VARCHAR2(30) ,
street_name  VARCHAR2(30) ,
major_id NUMBER(3), 
balance NUMBER(5) ,
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_student_trgr after insert on student
for each row
begin
insert into student_log values (:new.sid ,:new.Full_name_ar ,:new.Full_name_en ,:new.Nationality ,:new.national_id ,:new.sex ,:new.social_status ,:new.guardian_name ,:new.guardian_national_id ,:new.guardian_relation ,:new.birh_place ,:new.date_of_birth ,:new.religion,:new.health_status ,:new.mother_name ,:new.mother_job ,:new.mother_job_desc ,:new.father_job ,:new.father_job_desc ,:new.parents_status,:new.number_of_family_members ,:new.family_university_students ,:new.social_affairs ,:new.phone ,:new.telephone_home ,:new.emergency_phone ,:new.email ,:new.password ,:new.tawjihi_GPA ,:new.tawjihi_field ,:new.area_name ,:new.city_name ,:new.block_name  ,:new.street_name ,:new.major_id ,:new.balance ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_student_trgr after update on student
for each row 
begin
insert into student_log values (:old.sid ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality ,:old.national_id ,:old.sex ,:old.social_status ,:old.guardian_name ,:old.guardian_national_id ,:old.guardian_relation ,:old.birh_place ,:old.date_of_birth ,:old.religion,:old.health_status ,:old.mother_name ,:old.mother_job ,:old.mother_job_desc ,:old.father_job ,:old.father_job_desc ,:old.parents_status,:old.number_of_family_members ,:old.family_university_students ,:old.social_affairs ,:old.phone ,:old.telephone_home ,:old.emergency_phone ,:old.email ,:old.password ,:old.tawjihi_GPA ,:old.tawjihi_field ,:old.area_name ,:old.city_name ,:old.block_name  ,:old.street_name ,:old.major_id ,:old.balance  ,'delete' ,DEFAULT ,DEFAULT );
insert into student_log values (:new.sid ,:new.Full_name_ar ,:new.Full_name_en ,:new.nationality ,:new.national_id ,:new.sex ,:new.social_status ,:new.guardian_name ,:new.guardian_national_id ,:new.guardian_relation ,:new.birh_place ,:new.date_of_birth ,:new.religion,:new.health_status ,:new.mother_name ,:new.mother_job ,:new.mother_job_desc ,:new.father_job ,:new.father_job_desc ,:new.parents_status,:new.number_of_family_members ,:new.family_university_students ,:new.social_affairs ,:new.phone ,:new.telephone_home ,:new.emergency_phone ,:new.email ,:new.password ,:new.tawjihi_GPA ,:new.tawjihi_field ,:new.area_name ,:new.city_name ,:new.block_name  ,:new.street_name , :new.major_id ,:new.balance ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_student_trgr after delete on student
for each row 
begin 
insert into student_log values (:old.sid ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality ,:old.national_id ,:old.sex ,:old.social_status ,:old.guardian_name ,:old.guardian_national_id ,:old.guardian_relation ,:old.birh_place ,:old.date_of_birth ,:old.religion,:old.health_status ,:old.mother_name ,:old.mother_job ,:old.mother_job_desc ,:old.father_job ,:old.father_job_desc ,:old.parents_status,:old.number_of_family_members ,:old.family_university_students ,:old.social_affairs ,:old.phone ,:old.telephone_home ,:old.emergency_phone ,:old.email ,:old.password ,:old.tawjihi_GPA ,:old.tawjihi_field ,:old.area_name ,:old.city_name ,:old.block_name  ,:old.street_name , :old.major_id , :old.balance ,'delete' ,DEFAULT ,DEFAULT );
end;
 /

CREATE TABLE  Nationality_log(
Nationality VARCHAR2(20),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_Nationality_trgr after insert on Nationality 
for each row
begin
insert into Nationality_log values (:new.Nationality ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_Nationality_trgr after update on Nationality
for each row 
begin 
insert into Nationality_log values (:old.Nationality ,'delete' ,DEFAULT,DEFAULT ); 
insert into Nationality_log values (:new.Nationality ,'insert' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Nationality_trgr after delete on Nationality 
for each row 
begin 
insert into Nationality_log values (:old.Nationality ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE TABLE study_plan_courses_log (
plan_number NUMBER (3),
major_id NUMBER (3),
course_id VARCHAR2(10),
year DATE ,
semester NUMBER (1),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_study_plan_courses_trgr after insert on study_plan_courses
for each row
begin
insert into study_plan_courses_log values (:new.plan_number ,:new.major_id  ,:new.course_id,:new.year ,:new.semester ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_study_plan_courses_trgr after update on study_plan_courses
for each row 
begin
insert into study_plan_courses_log values (:old.plan_number ,:old.major_id  ,:old.course_id,:old.year ,:old.semester ,'delete' ,DEFAULT ,DEFAULT );
insert into study_plan_courses_log values (:new.plan_number ,:new.major_id  ,:new.course_id,:new.year ,:new.semester ,'insert' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_study_plan_courses_trgr after delete on study_plan_courses
for each row 
begin 
insert into study_plan_courses_log values (:old.plan_number ,:old.major_id  ,:old.course_id,:old.year ,:old.semester ,'delete' ,DEFAULT ,DEFAULT );
end;
 /
 
 
 --------------------------------------------------------------------------------------------------------------------

-- a Procedure to insert a student and create a user for him as 'S123' where 123 is the sid of the student
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
year NUMBER(4) := EXTRACT (YEAR FROM sysdate);
seq_count NUMBER(1);
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

 execute immediate 'INSERT INTO STUDENT VALUES ('||sid||','''||Full_name_ar  ||''','''||Full_name_en ||''','''||Nationality ||''','||national_id ||','''||sex  ||''','''||social_status  ||''','''|| guardian_name  ||''','||guardian_national_id  ||','''||guardian_relation ||''','''|| birh_place  ||''','''||date_of_birth  ||''','''||religion  ||''','''||health_status  ||''','''||mother_name ||''','''||mother_job  ||''','''|| mother_job_desc  ||''','''||father_job ||''','''||father_job_desc  ||''','''||parents_status  ||''','||number_of_family_members  ||','||family_university_students ||','''|| social_affairs   ||''','||phone  ||','||telephone_home  ||','||emergency_phone ||','''||email ||''','''||password  ||''','||tawjihi_GPA  ||','''||tawjihi_field ||''','''||area_name ||''','''||city_name  ||''','''||block_name ||''','''||street_name  ||''','||major_id ||','||balance ||')' ;
 --execute immediate 'CREATE USER S' ||sid|| ' IDENTIFIED BY 123456';
END;
/

CREATE OR REPLACE PROCEDURE insert_emp(
Full_name_ar VARCHAR2 ,
Full_name_en VARCHAR2 ,
Nationality VARCHAR2 ,
national_id NUMBER ,
sex CHAR ,
social_status CHAR , 
salary NUMBER ,
birh_place VARCHAR2 ,
date_of_birth DATE ,
religion VARCHAR2 ,
health_status VARCHAR2 ,
number_of_family_members NUMBER ,
phone NUMBER ,
telephone_home NUMBER ,
email VARCHAR2 ,
password VARCHAR2 ,
area_name VARCHAR2 ,
city_name VARCHAR2 ,
block_name VARCHAR2 ,
street_name VARCHAR2 ) 
AUTHID CURRENT_USER
IS
year NUMBER(4) := extract (year from sysdate);
seq_count NUMBER(1);
seq_name VARCHAR2(30);
employee_id NUMBER(9);

BEGIN
seq_name := 'E3'||year||'_SEQ';
select count(*) into seq_count from user_sequences where SEQUENCE_NAME =seq_name;

if seq_count = 0 then
execute immediate 'create sequence '||seq_name|| ' start with 3'||year ||'0001 maxvalue 3'||year ||'9999' ;
end if;

execute immediate 'select '||seq_name||'.nextval from dual' into employee_id;


execute immediate 'INSERT INTO EMPLOYEE VALUES (' ||employee_id ||','''||Full_name_ar  ||''','''||Full_name_en ||''','''||Nationality ||''','||national_id ||','''|| sex  ||''','''||social_status  ||''','|| salary||','''|| birh_place  ||''','''||date_of_birth  ||''','''||religion  ||''','''||health_status  ||''','|| number_of_family_members  ||','||  phone  ||','||telephone_home  ||','''||email ||''','''||password  ||''','''||area_name ||''','''||city_name  ||''','''||block_name ||''','''||street_name ||''' )' ;
execute immediate 'CREATE USER E' ||employee_id|| ' IDENTIFIED BY 123456';
END;
/

 --------------------------------------------------------------------------------------------------------------------

-- select * from tab;
-- select trigger_name from user_triggers;

INSERT INTO Address values('GazaStrip','Gaza','Naser','Elgesser');
INSERT INTO Nationality values('Nationality');
INSERT INTO Building values('A','Building Desc');
INSERT INTO floor values(1,'A','Floor Description');
INSERT INTO room values(01,1,'A',100);
INSERT INTO Building values('B','Building Desc');
INSERT INTO floor values(2,'B','Floor Description');
INSERT INTO room values(02,2,'B',50);
INSERT INTO department values(100,'Enge',02,2,'B');
INSERT INTO Majors_Department values(100,'Admission',01,1,'A');
INSERT INTO major values(1,'Information Security',100);
INSERT INTO course values('COMP 2113','Data Base 1',1, 2 ,'DESCRIPTION',100);

begin
insert_emp('Arabic Full Name','English Full Name','Nationality',123456789,'M','S',500,'Gaza',to_date('7-8-9','dd-mm-yy') , 'Islam','Good',20,970555555555,082876543,'Ahmed@mail.com','ABCD', 'GazaStrip','Gaza','Naser','Elgesser');
insert_emp('Arabic Full Name 2','English Full Name 2','Nationality',123456789,'M','S',500,'Gaza', to_date('1-1-10','dd-mm-yy') , 'Islam','Good',20,970555555555,082876543,'Ahmed@mail.com','ABCD', 'GazaStrip','Gaza','Naser','Elgesser');
insert_emp('Arabic Full Name 3','English Full Name 3','Nationality',123456789,'M','S',500,'Gaza',to_date('2-2-03','dd-mm-yy') , 'Islam','Good',20,970555555555,082876543,'Ahmed@mail.com','ABCD', 'GazaStrip','Gaza','Naser','Elgesser');
insert_emp('Arabic Full Name','English Full Name','Nationality',123456789,'M','S',500,'Gaza', to_date('1-2-3','dd-mm-yy') , 'Islam','Good',20,970555555555,082876543,'Ahmed@mail.com','ABCD', 'GazaStrip','Gaza','Naser','Elgesser');
end;
/


INSERT INTO teacher values(120100001,TO_DATE('17/12/2015', 'DD/MM/YYYY'),DATE '2017-12-17',100,499.99);
INSERT INTO manager(MANAGER_ID,EMPLOYMENT_START_DATE,EMPLOYMENT_END_DATE,SALARY,MANAGER_GRADE,DEPARTMENT_ID) values(120100001,DATE '2017-12-17',DATE '2018-12-17',500.00,'Master',100);
INSERT INTO Security values(120100001,DATE '2017-12-17',DATE '2018-12-17',500.00,100);
INSERT INTO Secretary values(120100003,DATE '2013-11-1',DATE'2017-10-6',100,null);
INSERT INTO item values(001,'Lap TOP','Descriotion');
INSERT INTO room_items values(001,01,1,'A',20);
INSERT INTO study_plan values(101,1);
INSERT INTO study_plan_courses values (101,1,'COMP 2113',DATE'2016-10-10',1);

--------------------------------------------------------------------------------------------------------------------

begin
insert_std('Arabic Full Name' , 'English Full Name' , 'Nationality',12345789 , 'M' , 'S' , 'Gardian Name' , 500, 'Father' , 
'Gaza' , to_date('1-1-10','dd-mm-yy') , 'Islam' , 'Good' , 'Mother' , 'Mother job' , 'Mother job desc' ,
 'FATHER_JOB' , 'FATHER_JOB_DESC' , 
'PARENTS_STATUS' , 20 , 9 , 'SOCIAL_AFFAIRS' , 70555555555 , 082876543 , 
0811111 , 'Ahmed@mail.com' , 'ABCD' ,
5 , 'S' , 'GazaStrip' , 'Gaza' , 'Naser' , 'Elgesser' , 1 , 50 );
end;
/

begin
insert_std('Arabic Full Name' , 'English Full Name' , 'Nationality',12345789 , 'M' , 'S' , 'Gardian Name' , 500, 'Father' , 
'Gaza' , to_date('1-1-10','dd-mm-yy') , 'Islam' , 'Good' , 'Mother' , 'Mother job' , 'Mother job desc' ,
 'FATHER_JOB' , 'FATHER_JOB_DESC' , 
'PARENTS_STATUS' , 20 , 9 , 'SOCIAL_AFFAIRS' , 70555555555 , 082876543 , 
0811111 , 'Ahmed@mail.com' , 'ABCD' ,
5 , 'S' , 'GazaStrip' , 'Gaza' , 'Naser' , 'Elgesser' , 1 , 50 );
end;
/

-- chage sex attribute from Male to Female

begin
insert_std('Arabic Full Name' , 'English Full Name' , 'Nationality',12345789 , 'F' , 'S' , 'Gardian Name' , 500, 'Father' , 
'Gaza' , to_date('1-1-10','dd-mm-yy') , 'Islam' , 'Good' , 'Mother' , 'Mother job' , 'Mother job desc' ,
 'FATHER_JOB' , 'FATHER_JOB_DESC' , 
'PARENTS_STATUS' , 20 , 9 , 'SOCIAL_AFFAIRS' , 70555555555 , 082876543 , 
0811111 , 'Ahmed@mail.com' , 'ABCD' ,
5 , 'S' , 'GazaStrip' , 'Gaza' , 'Naser' , 'Elgesser' , 1 , 50 );
end;
/

begin
insert_std('Arabic Full Name' , 'English Full Name' , 'Nationality',12345789 , 'F' , 'S' , 'Gardian Name' , 500, 'Father' , 
'Gaza' , to_date('1-1-10','dd-mm-yy') , 'Islam' , 'Good' , 'Mother' , 'Mother job' , 'Mother job desc' ,
 'FATHER_JOB' , 'FATHER_JOB_DESC' , 
'PARENTS_STATUS' , 20 , 9 , 'SOCIAL_AFFAIRS' , 70555555555 , 082876543 , 
0811111 , 'Ahmed@mail.com' , 'ABCD' ,
5 , 'S' , 'GazaStrip' , 'Gaza' , 'Naser' , 'Elgesser' , 1 , 50 );
end;
/

