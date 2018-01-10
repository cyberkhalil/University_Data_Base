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
national_id NUMBER(9) NOT NULL UNIQUE,
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
area_name VARCHAR2(30) NOT NULL,
city_name VARCHAR2(30) NOT NULL,
block_name VARCHAR2(30) NOT NULL,
street_name VARCHAR2(30) NOT NULL,
employment_date DATE DEFAULT sysdate NOT NULL,
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
check ( (majors_department_id IS NULL AND  department_id IS NOT NULL) OR (department_id IS NULL AND majors_department_id IS NOT NULL) )  );

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
check ( (majors_department_id IS NULL AND  department_id IS NOT NULL) OR (department_id IS NULL AND majors_department_id IS NOT NULL) ) );

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
FOREIGN KEY (room_number , floor_number , building_code) REFERENCES room (room_number , floor_number , building_code) ,
quantity NUMBER (5) NOT NULL,
PRIMARY KEY (item_id , room_number , floor_number , building_code));

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
year NUMBER(4) NOT NULL,
semester NUMBER (1) ,
FOREIGN KEY (plan_number, major_id) REFERENCES study_plan (plan_number, major_id),
PRIMARY KEY (plan_number, major_id, course_id),
CONSTRAINT stdy_pln_smstr_chk CHECK (semester IN (1,2,3)));

-- 20
CREATE TABLE student (
student_id NUMBER(9) PRIMARY KEY,
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
student_id NUMBER(9) REFERENCES student (student_id) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
semester NUMBER (1),
PRIMARY KEY (teacher_id, student_id, year, semester),
CONSTRAINT acdmic_advc_smstr_chk CHECK (semester IN (1,2,3)));

-- 22
CREATE TABLE section (
section_number NUMBER (3),
course_id VARCHAR2(10) REFERENCES course (course_id) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
semester NUMBER (1) ,
teacher_id NUMBER(9) REFERENCES teacher (teacher_id) ,
PRIMARY KEY (section_number, course_id, year, semester),
CONSTRAINT section_smstr_chk CHECK (semester IN (1,2,3)));

-- 23
CREATE TABLE enroll (
student_id NUMBER(9) REFERENCES student (student_id) ,
course_id VARCHAR2(10) ,
section_number NUMBER(3) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
semester NUMBER(1) ,
grade_mid NUMBER (2) DEFAULT NULL ,
grade_final NUMBER (3) DEFAULT NULL,
FOREIGN KEY (section_number , course_id , year , semester) REFERENCES section (section_number , course_id , year , semester) ,
PRIMARY KEY (student_id , course_id , section_number , year , semester),
CONSTRAINT eroll_grade_chk CHECK ((grade_final+grade_mid >=40)and (grade_final+grade_mid <=100 )));

-- 24
CREATE TABLE section_rooms (
section_number NUMBER (3) ,
course_id VARCHAR2 (10) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
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

select count(*) from tab;
-- should be 24 if every thing went right

----------------------------------------------------------------------------------------------------------

CREATE TABLE Address_log (
street_name VARCHAR2(30) NOT NULL,
block_name VARCHAR2(30) NOT NULL, 
city_name VARCHAR2(30) NOT NULL, 
area_name VARCHAR2(30) NOT NULL, 
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_address_trgr after INSERT on address 
for each row
begin
INSERT into address_log VALUES (:new.street_name ,:new.block_name ,:new.city_name ,:new.area_name ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_address_trgr after update on address
for each row 
begin 
INSERT into ADDRESS_LOG VALUES (:old.street_name ,:old.block_name ,:old.city_name ,:old.area_name , 'delete',DEFAULT,DEFAULT );
INSERT into ADDRESS_LOG VALUES (:new.street_name ,:new.block_name ,:new.city_name ,:new.area_name , 'INSERT',DEFAULT,DEFAULT ); 
end;
 /
 
CREATE OR REPLACE TRIGGER ad_address_trgr after delete on address 
for each row 
begin 
INSERT into ADDRESS_LOG VALUES (:old.street_name ,:old.block_name ,:old.city_name ,:old.area_name ,'delete' ,DEFAULT ,DEFAULT );
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
area_name  VARCHAR2(30) NOT NULL,
city_name  VARCHAR2(30) NOT NULL,
block_name  VARCHAR2(30) NOT NULL,
street_name  VARCHAR2(30) NOT NULL,
employment_date DATE NOT NULL,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_employee_trgr after INSERT on employee
for each row
begin
INSERT into employee_log VALUES (:new.employee_id ,:new.Full_name_ar ,:new.Full_name_en ,:new.nationality ,:new.national_id 
,:new.sex ,:new.social_status ,:new.salary ,:new.birh_place , :new.date_of_birth ,:new.religion ,:new.health_status ,:new.number_of_family_members 
,:new.phone ,:new.telephone_home ,:new.email ,:new.area_name ,:new.city_name ,:new.block_name  ,:new.street_name ,:new.employment_date ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /

CREATE OR REPLACE TRIGGER au_employee_trgr after update on employee
for each row 
begin
INSERT into employee_log VALUES (:old.employee_id ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality  ,:old.national_id,:new.sex  ,:old.social_status  ,:old.salary  ,:old.birh_place,:old.date_of_birth ,:old.religion  ,:old.health_status ,:old.number_of_family_members ,:old.phone ,:old.telephone_home ,:old.email , :old.area_name ,:old.city_name  ,:old.block_name  ,:old.street_name  ,:old.employment_date ,'delete' ,DEFAULT ,DEFAULT );
INSERT into employee_log VALUES (:new.employee_id ,:new.Full_name_ar ,:new.Full_name_en ,:new.nationality  ,:new.national_id,:new.sex  ,:new.social_status  ,:new.salary  ,:new.birh_place,:new.date_of_birth ,:new.religion  ,:new.health_status ,:new.number_of_family_members ,:new.phone ,:new.telephone_home ,:new.email , :new.area_name ,:new.city_name  ,:new.block_name  ,:new.street_name  ,:new.employment_date ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_employee_trgr after delete on employee
for each row 
begin 
INSERT into employee_log VALUES (:old.employee_id ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality  ,:old.national_id,:old.sex  ,:old.social_status  ,:old.salary  ,:old.birh_place, :old.date_of_birth ,:old.religion  ,:old.health_status ,:old.number_of_family_members,:old.phone  ,:old.telephone_home ,:old.email ,:old.area_name ,:old.city_name  ,:old.block_name  ,:old.street_name  , :old.employment_date ,'delete' ,DEFAULT ,DEFAULT );
end;
 /
CREATE TABLE building_log (
building_code CHAR (1) ,
building_desc VARCHAR2 (100),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL );

CREATE OR REPLACE TRIGGER ai_building_trgr after INSERT on building
for each row
begin
INSERT into building_log VALUES (:new.building_code,:new.building_desc ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_building_trgr after update on building
for each row 
begin 
INSERT into building_log VALUES (:old.building_code,:old.building_desc,'delete' ,DEFAULT,DEFAULT );
INSERT into building_log VALUES (:new.building_code,:new.building_desc,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_building_trgr after delete on building
FOR each row 
begin 
INSERT into building_log VALUES (:old.building_code,:old.building_desc,'delete' ,DEFAULT,DEFAULT );
end;
 /


CREATE TABLE floor_log (
floor_number NUMBER (2),
building_code CHAR (1),
floor_desc VARCHAR2 (100),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL );

CREATE OR REPLACE TRIGGER ai_floor_trgr after INSERT on floor
for each row
begin
INSERT into floor_log VALUES (:new.floor_number ,:new.building_code,:new.floor_desc ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_floor_trgr after update on floor
for each row 
begin 
INSERT into floor_log VALUES (:old.floor_number ,:old.building_code,:old.floor_desc ,'delete' ,DEFAULT,DEFAULT );
INSERT into floor_log VALUES (:new.floor_number ,:new.building_code,:new.floor_desc ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_floor_trgr after delete on floor
for each row 
begin 
INSERT into floor_log VALUES (:old.floor_number ,:old.building_code,:old.floor_desc,'delete' , DEFAULT ,DEFAULT );
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

CREATE OR REPLACE TRIGGER ai_room_trgr after INSERT on room
for each row
begin
INSERT into room_log VALUES (:new.room_number ,:new.floor_number ,:new.building_code,:new.capacity ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_room_trgr after update on room
for each row 
begin
INSERT into room_log VALUES (:old.room_number ,:old.floor_number ,:old.building_code,:old.capacity ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into room_log VALUES (:new.room_number ,:new.floor_number ,:new.building_code,:new.capacity ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_room_trgr after delete on room
for each row 
begin 
INSERT into room_log VALUES (:old.room_number ,:old.floor_number ,:old.building_code,:old.capacity ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /
 
 
CREATE TABLE Department_log (
Department_id NUMBER (3),
Department_name VARCHAR2(30) NOT NULL,
room_number NUMBER (2),
floor_number NUMBER (2),
building_code CHAR (1),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);


CREATE OR REPLACE TRIGGER ai_Department_trgr after INSERT on Department
for each row
begin
INSERT into Department_log VALUES (:new.Department_id ,:new.Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_Department_trgr after update on Department
for each row 
begin
INSERT into Department_log VALUES (:old.Department_id ,:old.Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
INSERT into Department_log VALUES (:new.Department_id ,:new.Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Department_trgr after delete on Department
for each row 
begin 
INSERT into Department_log VALUES (:old.Department_id ,:old.Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
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

CREATE OR REPLACE TRIGGER ai_Majors_Department_trgr after INSERT on Majors_Department
for each row
begin
INSERT into Majors_Department_log VALUES (:new.Majors_Department_id ,:new.Majors_Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_Majors_Department_trgr after update on Majors_Department
for each row 
begin
INSERT into Majors_Department_log VALUES (:old.Majors_Department_id ,:old.Majors_Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
INSERT into Majors_Department_log VALUES (:new.Majors_Department_id ,:new.Majors_Department_name ,:new.room_number,:new.floor_number ,:new.building_code ,'INSERT',DEFAULT,DEFAULT); 
end;
/
CREATE OR REPLACE TRIGGER ad_Majors_Department_trgr after delete on Majors_Department
for each row 
begin 
INSERT into Majors_Department_log VALUES (:old.Majors_Department_id ,:old.Majors_Department_name ,:old.room_number,:old.floor_number ,:old.building_code ,'delete',DEFAULT,DEFAULT); 
end;
 /
 
 
CREATE TABLE major_log (
major_id NUMBER (3) ,
major_name VARCHAR2(30) NOT NULL ,
Majors_Department_id NUMBER (3) ,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_major_trgr after INSERT on major
for each row
begin
INSERT into major_log VALUES (:new.major_id ,:new.major_name ,:new.Majors_Department_id ,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_major_trgr after update on major
for each row 
begin
INSERT into major_log VALUES (:old.major_id ,:old.major_name ,:old.Majors_Department_id ,'delete',DEFAULT,DEFAULT); 
INSERT into major_log VALUES (:new.major_id ,:new.major_name ,:new.Majors_Department_id ,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER ad_major_trgr after delete on major
for each row 
begin 
INSERT into major_log VALUES (:old.major_id ,:old.major_name ,:old.Majors_Department_id ,'delete',DEFAULT,DEFAULT); 
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

CREATE OR REPLACE TRIGGER ai_course_trgr after INSERT on course
for each row
begin
INSERT into course_log VALUES (:new.course_id ,:new.course_name ,:new.credit , :new.clevel ,:new.Majors_Department_id ,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER au_course_trgr after update on course
for each row 
begin
INSERT into course_log VALUES (:old.course_id ,:old.course_name ,:old.credit , :old.clevel ,:old.Majors_Department_id,'Delete',DEFAULT,DEFAULT); 
INSERT into course_log VALUES (:new.course_id ,:new.course_name ,:new.credit , :new.clevel ,:new.Majors_Department_id,'INSERT',DEFAULT,DEFAULT); 
end;
 /
CREATE OR REPLACE TRIGGER ad_course_trgr after delete on course
for each row 
begin 
INSERT into course_log VALUES (:old.course_id ,:old.course_name ,:old.credit , :old.clevel ,:old.Majors_Department_id,'Delete',DEFAULT,DEFAULT); 
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

CREATE OR REPLACE TRIGGER ai_teacher_trgr after INSERT on teacher
for each row
begin
INSERT into teacher_log VALUES (:new.Teacher_id ,:new.Employment_Start_Date ,:new.Employment_End_Date,:new.Majors_Department_id,:new.salary ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_teacher_trgr after update on teacher
for each row 
begin
INSERT into teacher_log VALUES (:old.Teacher_id ,:old.Employment_Start_Date ,:old.Employment_End_Date,:old.Majors_Department_id,:old.salary ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into teacher_log VALUES (:new.Teacher_id ,:new.Employment_Start_Date ,:new.Employment_End_Date,:new.Majors_Department_id,:new.salary ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_teacher_trgr after delete on teacher
for each row 
begin 
INSERT into teacher_log VALUES (:old.Teacher_id ,:old.Employment_Start_Date ,:old.Employment_End_Date,:old.Majors_Department_id,:old.salary ,'delete' ,DEFAULT,DEFAULT ); 
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

CREATE OR REPLACE TRIGGER ai_Manager_trgr after INSERT on Manager
for each row
begin
INSERT into Manager_log VALUES (:new.Manager_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Manager_Grade ,:new.Majors_Department_id ,:new.Department_id ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_Manager_trgr after update on Manager
for each row 
begin
INSERT into Manager_log VALUES (:old.Manager_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Manager_Grade ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into Manager_log VALUES (:new.Manager_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Manager_Grade ,:new.Majors_Department_id ,:new.Department_id ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Manager_trgr after delete on Manager
for each row 
begin 
INSERT into Manager_log VALUES (:old.Manager_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Manager_Grade ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
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

CREATE OR REPLACE TRIGGER ai_Security_trgr after INSERT on Security
for each row
begin
INSERT into Security_log VALUES (:new.Security_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Department_id,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE OR REPLACE TRIGGER au_Security_trgr after update on Security
for each row 
begin
INSERT into Security_log VALUES (:old.Security_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Department_id,'delete' ,DEFAULT,DEFAULT ); 
INSERT into Security_log VALUES (:new.Security_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.salary ,:new.Department_id,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE OR REPLACE TRIGGER ad_Security_trgr after delete on Security
for each row 
begin 
INSERT into Security_log VALUES (:old.Security_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.salary ,:old.Department_id,'delete' ,DEFAULT,DEFAULT ); 
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


CREATE OR REPLACE TRIGGER ai_Secretary_trgr after INSERT on Secretary 
for each row
begin
INSERT into Secretary_log VALUES (:new.Secretary_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.Majors_Department_id ,:new.Department_id ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_Secretary_trgr after update on Secretary
for each row 
begin 
INSERT into Secretary_log VALUES (:old.Secretary_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into Secretary_log VALUES (:new.Secretary_id ,:new.Employment_Start_Date ,:new.Employment_End_Date ,:new.Majors_Department_id ,:new.Department_id ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Secretary_trgr after delete on Secretary 
for each row 
begin 
INSERT into Secretary_log VALUES (:old.Secretary_id ,:old.Employment_Start_Date ,:old.Employment_End_Date ,:old.Majors_Department_id ,:old.Department_id ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /


CREATE TABLE item_log (
item_id NUMBER (3) ,
item_name VARCHAR2(30) ,
item_description VARCHAR2(200),
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_item_trgr after INSERT on item 
for each row
begin
INSERT into item_log VALUES (:new.item_id ,:new.item_name ,:new.item_description ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_item_trgr after update on item
for each row 
begin 
INSERT into item_log VALUES (:old.item_id ,:old.item_name ,:old.item_description ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into item_log VALUES (:new.item_id ,:new.item_name ,:new.item_description ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_item_trgr after delete on item 
for each row 
begin 
INSERT into item_log VALUES (:old.item_id ,:old.item_name ,:old.item_description ,'delete' ,DEFAULT,DEFAULT ); 
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

CREATE OR REPLACE TRIGGER ai_room_items_trgr after INSERT on room_items 
for each row
begin
INSERT into room_items_log VALUES (:new.item_id ,:new.room_number ,:new.floor_number ,:new.building_code ,:new.quantity ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_room_items_trgr after update on room_items
for each row 
begin 
INSERT into room_items_log VALUES (:old.item_id ,:old.room_number ,:old.floor_number ,:old.building_code ,:old.quantity ,'INSERT' ,DEFAULT,DEFAULT ); 
INSERT into room_items_log VALUES (:new.item_id ,:new.room_number ,:new.floor_number ,:new.building_code ,:new.quantity ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_room_items_trgr after delete on room_items 
for each row 
begin 
INSERT into room_items_log VALUES (:old.item_id ,:old.room_number ,:old.floor_number ,:old.building_code ,:old.quantity ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /


CREATE TABLE study_plan_log (
plan_number NUMBER (3),
major_id NUMBER (3),
action_name char (6) NOT NULL, 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_study_plan_trgr after INSERT on study_plan 
for each row
begin
INSERT into study_plan_log VALUES (:new.plan_number ,:new.major_id ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_study_plan_trgr after update on study_plan
for each row 
begin 
INSERT into study_plan_log VALUES (:old.plan_number ,:old.major_id ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into study_plan_log VALUES (:new.plan_number ,:new.major_id ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_study_plan_trgr after delete on study_plan 
for each row 
begin 
INSERT into study_plan_log VALUES (:old.plan_number ,:old.major_id ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE TABLE academic_advice_log (
teacher_id NUMBER (9),
student_id NUMBER(9),
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
semester NUMBER (1) ,
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_academic_advice_trgr after INSERT on academic_advice
for each row
begin
INSERT into academic_advice_log VALUES (:new.teacher_id ,:new.student_id ,:new.year ,:new.semester,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_academic_advice_trgr after update on academic_advice
for each row 
begin
INSERT into academic_advice_log VALUES (:old.teacher_id ,:old.student_id ,:old.year ,:old.semester,'delete' ,DEFAULT ,DEFAULT );
INSERT into academic_advice_log VALUES (:new.teacher_id ,:new.student_id ,:new.year ,:new.semester,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_academic_advice_trgr after delete on academic_advice
for each row 
begin 
INSERT into academic_advice_log VALUES (:old.teacher_id ,:old.student_id ,:old.year ,:old.semester,'delete' ,DEFAULT ,DEFAULT );
end;
 /


CREATE TABLE section_log (
section_number NUMBER (3),
course_id VARCHAR2(10) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
semester NUMBER (1),
teacher_id NUMBER(9),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_section_trgr after INSERT on section
for each row
begin
INSERT into section_log VALUES (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.teacher_id,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_section_trgr after update on section
for each row 
begin
INSERT into section_log VALUES (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.teacher_id,'delete' ,DEFAULT ,DEFAULT );
INSERT into section_log VALUES (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.teacher_id,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_section_trgr after delete on section
for each row 
begin 
INSERT into section_log VALUES (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.teacher_id,'delete' ,DEFAULT ,DEFAULT );
end;
 /


CREATE TABLE enroll_log (
student_id NUMBER(9),
course_id VARCHAR2(10) ,
section_number NUMBER(3) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
semester NUMBER(1) ,
grade_mid NUMBER (2) ,
grade_final NUMBER (3),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_enroll_trgr after INSERT on enroll
for each row
begin
INSERT into enroll_log VALUES (:new.student_id ,:new.course_id ,:new.section_number ,:new.year ,:new.semester ,:new.grade_mid ,:new.grade_final ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_enroll_trgr after update on enroll
for each row 
begin
INSERT into enroll_log VALUES (:old.student_id ,:old.course_id ,:old.section_number ,:old.year ,:old.semester ,:old.grade_mid ,:old.grade_final ,'delete' ,DEFAULT ,DEFAULT );
INSERT into enroll_log VALUES (:new.student_id ,:new.course_id ,:new.section_number ,:new.year ,:new.semester ,:new.grade_mid ,:new.grade_final ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_enroll_trgr after delete on enroll
for each row 
begin 
INSERT into enroll_log VALUES (:old.student_id ,:old.course_id ,:old.section_number ,:old.year ,:old.semester ,:old.grade_mid ,:old.grade_final ,'delete' ,DEFAULT ,DEFAULT );
end;
 /


CREATE TABLE section_rooms_log (
section_number NUMBER (3) ,
course_id VARCHAR2 (10) ,
year NUMBER(4) DEFAULT EXTRACT (YEAR FROM sysdate), 
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

CREATE OR REPLACE TRIGGER ai_section_rooms_trgr after INSERT on section_rooms
for each row
begin
INSERT into section_rooms_log VALUES (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.room_number,:new.floor_number ,:new.building_code ,:new.day ,:new.start_time ,:new.end_time ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_section_rooms_trgr after update on section_rooms
for each row 
begin
INSERT into section_rooms_log VALUES (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.room_number,:old.floor_number ,:old.building_code ,:old.day ,:old.start_time ,:old.end_time ,'delete' ,DEFAULT ,DEFAULT );
INSERT into section_rooms_log VALUES (:new.section_number ,:new.course_id ,:new.year ,:new.semester ,:new.room_number,:new.floor_number ,:new.building_code ,:new.day ,:new.start_time ,:new.end_time ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_section_rooms_trgr after delete on section_rooms
for each row 
begin 
INSERT into section_rooms_log VALUES (:old.section_number ,:old.course_id ,:old.year ,:old.semester ,:old.room_number,:old.floor_number ,:old.building_code ,:old.day ,:old.start_time ,:old.end_time ,'delete' ,DEFAULT ,DEFAULT );
end;
 /
 
CREATE TABLE student_log (
student_id NUMBER(9),
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

CREATE OR REPLACE TRIGGER ai_student_trgr after INSERT on student
for each row
begin
INSERT into student_log VALUES (:new.student_id ,:new.Full_name_ar ,:new.Full_name_en ,:new.Nationality ,:new.national_id ,:new.sex ,:new.social_status ,:new.guardian_name ,:new.guardian_national_id ,:new.guardian_relation ,:new.birh_place ,:new.date_of_birth ,:new.religion,:new.health_status ,:new.mother_name ,:new.mother_job ,:new.mother_job_desc ,:new.father_job ,:new.father_job_desc ,:new.parents_status,:new.number_of_family_members ,:new.family_university_students ,:new.social_affairs ,:new.phone ,:new.telephone_home ,:new.emergency_phone ,:new.email ,:new.tawjihi_GPA ,:new.tawjihi_field ,:new.area_name ,:new.city_name ,:new.block_name  ,:new.street_name ,:new.major_id ,:new.balance ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_student_trgr after update on student
for each row 
begin
INSERT into student_log VALUES (:old.student_id ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality ,:old.national_id ,:old.sex ,:old.social_status ,:old.guardian_name ,:old.guardian_national_id ,:old.guardian_relation ,:old.birh_place ,:old.date_of_birth ,:old.religion,:old.health_status ,:old.mother_name ,:old.mother_job ,:old.mother_job_desc ,:old.father_job ,:old.father_job_desc ,:old.parents_status,:old.number_of_family_members ,:old.family_university_students ,:old.social_affairs ,:old.phone ,:old.telephone_home ,:old.emergency_phone ,:old.email , :old.tawjihi_GPA ,:old.tawjihi_field ,:old.area_name ,:old.city_name ,:old.block_name  ,:old.street_name ,:old.major_id ,:old.balance  ,'delete' ,DEFAULT ,DEFAULT );
INSERT into student_log VALUES (:new.student_id ,:new.Full_name_ar ,:new.Full_name_en ,:new.nationality ,:new.national_id ,:new.sex ,:new.social_status ,:new.guardian_name ,:new.guardian_national_id ,:new.guardian_relation ,:new.birh_place ,:new.date_of_birth ,:new.religion,:new.health_status ,:new.mother_name ,:new.mother_job ,:new.mother_job_desc ,:new.father_job ,:new.father_job_desc ,:new.parents_status,:new.number_of_family_members ,:new.family_university_students ,:new.social_affairs ,:new.phone ,:new.telephone_home ,:new.emergency_phone ,:new.email , :new.tawjihi_GPA ,:new.tawjihi_field ,:new.area_name ,:new.city_name ,:new.block_name  ,:new.street_name , :new.major_id ,:new.balance ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_student_trgr after delete on student
for each row 
begin 
INSERT into student_log VALUES (:old.student_id ,:old.Full_name_ar ,:old.Full_name_en ,:old.nationality ,:old.national_id ,:old.sex ,:old.social_status ,:old.guardian_name ,:old.guardian_national_id ,:old.guardian_relation ,:old.birh_place ,:old.date_of_birth ,:old.religion,:old.health_status ,:old.mother_name ,:old.mother_job ,:old.mother_job_desc ,:old.father_job ,:old.father_job_desc ,:old.parents_status,:old.number_of_family_members ,:old.family_university_students ,:old.social_affairs ,:old.phone ,:old.telephone_home ,:old.emergency_phone ,:old.email ,:old.tawjihi_GPA ,:old.tawjihi_field ,:old.area_name ,:old.city_name ,:old.block_name  ,:old.street_name , :old.major_id , :old.balance ,'delete' ,DEFAULT ,DEFAULT );
end;
 /

CREATE TABLE  Nationality_log(
Nationality VARCHAR2(20),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_Nationality_trgr after INSERT on Nationality 
for each row
begin
INSERT into Nationality_log VALUES (:new.Nationality ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER au_Nationality_trgr after update on Nationality
for each row 
begin 
INSERT into Nationality_log VALUES (:old.Nationality ,'delete' ,DEFAULT,DEFAULT ); 
INSERT into Nationality_log VALUES (:new.Nationality ,'INSERT' ,DEFAULT,DEFAULT ); 
end;
 /
CREATE OR REPLACE TRIGGER ad_Nationality_trgr after delete on Nationality 
for each row 
begin 
INSERT into Nationality_log VALUES (:old.Nationality ,'delete' ,DEFAULT,DEFAULT ); 
end;
 /

CREATE TABLE study_plan_courses_log (
plan_number NUMBER (3),
major_id NUMBER (3),
course_id VARCHAR2(10),
year NUMBER(4), 
semester NUMBER (1),
action_name char(6) NOT NULL , 
action_date date DEFAULT sysdate NOT NULL, 
action_user VARCHAR2(30) DEFAULT user NOT NULL);

CREATE OR REPLACE TRIGGER ai_study_plan_courses_trgr after INSERT on study_plan_courses
for each row
begin
INSERT into study_plan_courses_log VALUES (:new.plan_number ,:new.major_id  ,:new.course_id,:new.year ,:new.semester ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER au_study_plan_courses_trgr after update on study_plan_courses
for each row 
begin
INSERT into study_plan_courses_log VALUES (:old.plan_number ,:old.major_id  ,:old.course_id,:old.year ,:old.semester ,'delete' ,DEFAULT ,DEFAULT );
INSERT into study_plan_courses_log VALUES (:new.plan_number ,:new.major_id  ,:new.course_id,:new.year ,:new.semester ,'INSERT' ,DEFAULT ,DEFAULT );
end;
 /
CREATE OR REPLACE TRIGGER ad_study_plan_courses_trgr after delete on study_plan_courses
for each row 
begin 
INSERT into study_plan_courses_log VALUES (:old.plan_number ,:old.major_id  ,:old.course_id,:old.year ,:old.semester ,'delete' ,DEFAULT ,DEFAULT );
end;
 /
 
----------------------------------------------------------------------------------------------------------
-- The Roles

CREATE ROLE students_role;
CREATE ROLE employees_role;
CREATE ROLE teacher_role;
CREATE ROLE manager_role;
CREATE ROLE security_role;
CREATE ROLE secretary_role;

----------------------------------------------------------------------------------------------------------
-- creating insertion procedures

-- a procedure to insert a student and create a user for him as 'S123' where 123 is the student_id of the student
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
student_id NUMBER(9);

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

execute immediate 'select '||seq_name||'.nextval from dual' into student_id;
 
execute immediate 'INSERT INTO STUDENT VALUES ('||student_id||','''||Full_name_ar  ||''','''||Full_name_en ||''','''||Nationality ||''','||national_id ||','''||sex  ||''','''||social_status  ||''','''|| guardian_name  ||''','||guardian_national_id  ||','''||guardian_relation ||''','''|| birh_place  ||''','''||date_of_birth  ||''','''||religion  ||''','''||health_status  ||''','''||mother_name ||''','''||mother_job  ||''','''|| mother_job_desc  ||''','''||father_job ||''','''||father_job_desc  ||''','''||parents_status  ||''','||number_of_family_members  ||','||family_university_students ||','''|| social_affairs   ||''','||phone  ||','||telephone_home  ||','||emergency_phone ||','''||email ||''','||tawjihi_GPA  ||','''||tawjihi_field ||''','''||area_name ||''','''||city_name  ||''','''||block_name ||''','''||street_name  ||''','||major_id ||','||balance ||')' ;
execute immediate 'CREATE USER S' ||student_id|| ' IDENTIFIED BY 123456';
execute immediate 'Grant students_role to S' ||student_id ; 
 
END;
/

-- a procedure to insert an employee and create a user for him as 'E123' where 123 is the student_id of the student
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
area_name VARCHAR2 ,
city_name VARCHAR2 ,
block_name VARCHAR2 ,
street_name VARCHAR2,
employment_date DATE ) 
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

execute immediate 'INSERT INTO EMPLOYEE VALUES (' ||employee_id ||','''||Full_name_ar  ||''','''||Full_name_en ||''','''||Nationality ||''','||national_id ||','''|| sex  ||''','''||social_status  ||''','|| salary||','''|| birh_place  ||''','''||date_of_birth  ||''','''||religion  ||''','''||health_status  ||''','|| number_of_family_members  ||','||  phone  ||','||telephone_home  ||','''||email ||''','''||area_name ||''','''||city_name  ||''','''||block_name ||''','''||street_name ||''','''||employment_date||''' )' ;
execute immediate 'CREATE USER E' ||employee_id|| ' IDENTIFIED BY 123456';
execute immediate 'Grant employees_role to E' || employee_id;
END;
/

----------------------------------------------------------------------------------------------------------
-- insertion operations

INSERT INTO address VALUES('Gaza Strip','Gaza','Naser','Elgesser');
INSERT INTO address VALUES('Gaza North','Jabalia','Al Nazlah','Al Saftawy');
INSERT INTO address VALUES('Rafah','Rafah','Yebna','Kir');

INSERT INTO nationality VALUES('Palestinian');
INSERT INTO nationality VALUES('Egyptian');
INSERT INTO nationality VALUES('Jordanian');

INSERT INTO building VALUES('A','Management building.');
INSERT INTO building VALUES('B','Male Students building.');
INSERT INTO building VALUES('W','Female Students building.');

INSERT INTO floor VALUES(1,'A','Management First floor.');
INSERT INTO floor VALUES(2,'A','Management Computer labs.');
INSERT INTO floor VALUES(3,'A','Management Electroincs labs.');

INSERT INTO floor VALUES(1,'B','Male First floor.');
INSERT INTO floor VALUES(2,'B','Male Computer labs.');
INSERT INTO floor VALUES(3,'B','Male Electroincs labs.');

INSERT INTO floor VALUES(1,'W','Female First floor.');
INSERT INTO floor VALUES(2,'W','Female Computer labs.');
INSERT INTO floor VALUES(3,'W','Female Electroincs labs.');

INSERT INTO room VALUES(01,1,'A',30);
INSERT INTO room VALUES(01,2,'A',20);
INSERT INTO room VALUES(02,2,'A',45);
INSERT INTO room VALUES(03,1,'A',30);
INSERT INTO room VALUES(03,2,'A',20);
INSERT INTO room VALUES(04,1,'A',45);
INSERT INTO room VALUES(05,1,'A',45);

INSERT INTO room VALUES(01,1,'B',10);
INSERT INTO room VALUES(02,1,'B',50);
INSERT INTO room VALUES(01,2,'B',25);

INSERT INTO room VALUES(01,2,'W',15);
INSERT INTO room VALUES(01,3,'W',30);
INSERT INTO room VALUES(02,3,'W',65);

INSERT INTO department VALUES(100,'Acceptance and Registration',01,1,'A');
INSERT INTO department VALUES(101,'Studnents Affairs',01,2,'A');
INSERT INTO department VALUES(102,'Academic Affairs',05,1,'A');

INSERT INTO majors_department VALUES(100,'Engineering',03,1,'A');
INSERT INTO majors_department VALUES(101,'Languages',03,2,'A');
INSERT INTO majors_department VALUES(102,'Nursing',04,1,'A');

INSERT INTO major VALUES(1,'Information Security',100);
INSERT INTO major VALUES(2,'English Translator',101);
INSERT INTO major VALUES(3,'Arabic Teacher',101);

INSERT INTO course VALUES('COMP2113','Data Base 1',1, 2 ,'DESCRIPTION',100);
INSERT INTO course VALUES('UNIV1122','English',1, 2 ,'DESCRIPTION',100);
INSERT INTO course VALUES('UNIV1125','Arabic',1, 2 ,'DESCRIPTION',100);

----------------------------------------------------------------------------------------------------------
-- Insertion by procedures
begin
insert_emp('مصطفى أحمد','Mostafa Ahmed','Palestinian',300123456,'M','M',1500,'Gaza',to_date('4-5-1964','dd-mm-yyyy') , 'Islam','Good',7,00972591225472,082876528,'m_ahmed@hotmail.com', 'Gaza Strip','Gaza','Naser','Elgesser' , DATE '2015-7-10');
insert_emp('أحمد شعبان','Ahmed Shaban','Egyptian',300321654,'M','S',700,'Cairo', to_date('1-7-1984','dd-mm-yyyy') , 'Islam','broken arm',3,00972599547231,082895312,'shaban1112@gmail.com', 'Gaza North','Jabalia','Al Nazlah','Al Saftawy', DATE '2016-8-15');
insert_emp('ديمة منصور','Dima Mansor','Jordanian',300712698,'F','M',1300,'Amman',to_date('5-6-1976','dd-mm-yyyy') , 'Islam','Good',5,00972567412534,082865723,'dima_m1976@yaho.com', 'Rafah','Rafah','Yebna','Kir', DATE '2013-8-21');

insert_emp('حسن شملخ','Hasan Shamalakh','Egyptian',308122456,'M','M',1500,'Giza',to_date('7-6-1978','dd-mm-yyyy') , 'Islam','Good',7,00972591229412,082876528,'h_shmalakh@yaho.com', 'Gaza Strip','Gaza','Naser','Elgesser', DATE '2012-1-14');
insert_emp('سامي بدرة','Samy Badrah','Jordanian',307321644,'M','S',700,'Zarqa', to_date('1-7-1977','dd-mm-yyyy') , 'Islam','broken leg',3,00972569549425,082895312,'S123badr@gmail.com', 'Gaza North','Jabalia','Al Nazlah','Al Saftawy', DATE '2017-5-1');
insert_emp('سارة اسماعيل','Sarah Isamel','Jordanian',303714198,'F','M',1300,'Karak',to_date('9-10-1966','dd-mm-yyyy') , 'Islam','Good',5,00972567413214,082865723,'sar_ismael7856@yaho.com', 'Rafah','Rafah','Yebna','Kir', DATE '2017-5-15');
end;
/


INSERT INTO teacher VALUES(320180001, DATE '2017-07-17',DATE '2018-1-17',100,499.99);
INSERT INTO teacher VALUES(320180002, DATE '2017-07-17',DATE '2018-1-17',101,300.14);
INSERT INTO teacher VALUES(320180003, DATE '2017-07-17',DATE '2018-1-17',102,600);

INSERT INTO manager(MANAGER_ID,EMPLOYMENT_START_DATE,EMPLOYMENT_END_DATE,SALARY,MANAGER_GRADE,DEPARTMENT_ID) VALUES(320180004,DATE '2017-12-17',DATE '2018-1-17',240.58,'Master',100);

INSERT INTO Security VALUES(320180005,DATE '2017-12-17',DATE '2018-12-17',500.00,100);

INSERT INTO Secretary VALUES(320180006,DATE '2013-11-1',DATE'2017-10-6',100,null);

INSERT INTO item VALUES(001,'PC','Desktop PC');
INSERT INTO item VALUES(002,'Lap TOP','Lap TOP, a moveable PC');
INSERT INTO item VALUES(003,'LCD','Tool for presenting computer monitor on wall or appropriate surface');

INSERT INTO room_items VALUES(001,01,1,'B',8);
INSERT INTO room_items VALUES(003,01,1,'B',1);

INSERT INTO room_items VALUES(001,01,2,'W',10);
INSERT INTO room_items VALUES(003,01,2,'W',1);

INSERT INTO room_items VALUES(002,01,1,'A',15);
INSERT INTO room_items VALUES(003,01,1,'A',1);

INSERT INTO study_plan VALUES(101,1);
INSERT INTO study_plan VALUES(101,2);
INSERT INTO study_plan VALUES(101,3);

INSERT INTO study_plan_courses VALUES (101,1,'COMP2113',2018,1);
INSERT INTO study_plan_courses VALUES (101,1,'UNIV1122',2018,2);
INSERT INTO study_plan_courses VALUES (101,2,'UNIV1122',2016,2);
INSERT INTO study_plan_courses VALUES (101,3,'UNIV1125',2015,1);

----------------------------------------------------------------------------------------------------------
-- Insertion by procedures

begin
insert_std('محمد بركات' , 'Mohammed Barakat' , 'Palestinian',400321548, 'M' , 'S' , 'Khaled Barakat' , 407864284, 'Father' , 'Gaza' , to_date('7-2-1995','dd-mm-yyyy') , 'Islam' , 'Good' , 'Eman' , 'housewife' , 'managing household affairs' , 'Doctor' , 'cure ill or injured people' , 'both_alive' , 12 , 3 , 'government assistance' , 00972567513567 , 082876543 , 0097595763124 , 'Moh7med855@mail.com' ,88 , 'S' , 'Gaza Strip' , 'Gaza' , 'Naser' , 'Elgesser' , 1    , 150 );
insert_std('فؤاد سلمان' , 'Fouad Soliman' , 'Jordanian',400953215, 'M' , 'M' , 'Ibrahim Soliman' , 401119513, 'Uncle' , 'Amman' , to_date('26-9-1971','dd-mm-yyyy') , 'Islam' , 'Cut arm' , 'Noor' , 'school teacher' , 'Teach school students' , '-' , '-' , 'dead_father' , 8 , 1 , 'UNRWA assistance' , 00972594599835 , 082883714 , 00972591533841 , 'FSol415@gmail.com' ,85 , 'S' , 'Gaza North','Jabalia','Al Nazlah','Al Saftawy' , 2    , 150 );
insert_std('سميه شاكر' , 'Somayyah Shaker' , 'Egyptian',402625375, 'F' , 'S' , 'Mohammed Shaker' , 402381853, 'Brother' , 'Giza' , to_date('24-8-1978','dd-mm-yyyy') , 'Islam' , 'Paralized' , 'Marwa' , '-' , '-' , '-' , '-' , 'both_dead' , 6 , 2 , 'UNRWA assistance' , 00972563875071 , 082881989 , 00972591499557 , 'Somayyah1978@mail.com' ,67 , 'L' , 'Rafah','Rafah','Yebna','Kir' , 3    , 150 );
insert_std('مريم الخياط' , 'Mariam Al-Khayyat' , 'Palestinian',402531181, 'F' , 'M' , 'Ali Al-Khayyat' , 400490070, 'Father' , 'Rafah' , to_date('4-6-1987','dd-mm-yyyy') , 'Christianity' , 'Good' , 'Sarah' , 'university teacher' , 'teach university students' , 'Carpenter' , 'make and repair wooden objects' , 'both_alive' , 10 , 1 , 'Other assistance' , 00972593894811 , 082831132 , 00972564402409 , 'M-Khayyat@yaho.com' ,96 , 'S' , 'Gaza Strip' , 'Gaza' , 'Naser' , 'Elgesser' , 1    , 150 );
end;
/
