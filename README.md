University_Data_Base
===================

**This project contains a full database about a university, which you can just copy and use easily.**

***************************************************************

## About ##
|            |                           |  
| ---------- | ------------------------- |  
| Title:     |  University_Data_Base  |  
| DBMS :     |  [Oracle DBMS][oracleLink]  |  
| Authors:   |  [Eyad AL-‘Amawi][EyadLink]  - [Waleed Mortaja][WaleedLink] - [Mahmoud Khalil][MahmoudLink]|  
| Copyrights:   | Open Source      |  

[oracleLink]: 	https://www.oracle.com/engineered-systems/database-appliance/index.html
[MahmoudLink]: https://www.facebook.com/cyber.khalil/

## Introduction ##
This is a database project made with the SQL (DDL, DML) & pl\sql languages (for Oracle DBMS) & Its designed as the ERD (Entity Relationship Diagram), which is provided as jpg file in the project files [link][ERDLink]

[ERDLink]: https://github.com/khalil2535/University_Data_Base/blob/master/final.jpg

## Contents ##
  ### DDL ###
  1.  #### Tables :- #####
  There are 24 tables (without the log ones) in this database, which contain all the data that we need to store as records (rows)
  Those tables can describe the relation between the students, teachers, courses, and even more than 15 objects.
  
  2.  #### Log Tables :- #####
  For each table from those 24, there is a log table, which is used to save every manipulation(DML) happen in the table and who did that and what changes, so the log table keeps a record of who did what in which record and when.
  
  3.  #### Triggers :- #####
  For each log table there is a three triggers so in simple calcoulation there are 72 trigger in our data base, the trigger goal is to auto save a record about the manipulations from the orign tables in the log tables, those three triggers are responible for saving every insert, update, delete operation, who (which user) & when in the log tables ..
  
  4.  #### Procedures :- #####
  Because of there is a alot of users in data base and for each student, employee there should be a user we made a procedure to insert into the (student, employee) tables that give every one a unique username that got the ability to see and edit his/her own information and its using the pl\sql also to run the sequences as thier normal job, so there is no need to enter an id for every insertion operation in the student's or employees tables.
  
  5.  #### Sequences :- #####
  There is a 3 sequences in this database our goal from them is to auto make the id's for every student (male of female) and every employee the male students sequence starts every year from 1(year)0001 to 1(year)9999 so in every year just around 10 thousand of male student's can register in the database of university but if you need more you just have to adding 0 after the year in that sequence to keep ability to regist more that that number, its autom increment number is 1 to make it easy for every one to know how many student reigisted in the university ..
  

  6.  #### Roles :- #####
  Because we can't give the ability for each student to remove, drop, or delete anything in the database, we gave everyone a role that he can't overrun anything except their normal abilities as selected from their table or from their courses table, so we prevented them from editing a record in another table as a security measure in the database.
  
  7.  #### Views :- #####
  There are some views we made for the most common queries in the database, and to make the process more secure.
  
   ### DML ###
   There are already some ready records in the database, which is used to check that everything is working well in the database, and it's also in the same file; you can just delete them or don't copy them if you don't need them in your database, or just keep them.
   
   *#Ps. Those records are based on a realworld examples in our university*
   
  ### PL\SQL ###
  ##### In the triggers & the procedures there is pl\sql language we used it in our project ######
  
  
   ### ERD ###
   ![ERD](https://raw.githubusercontent.com/khalil2535/University_Data_Base/master/documents/Entity%20Relationship%20Diagram/ERD.jpg)
  
  
  As a  last word, we want to give all the thanks to our god then to our teachers for learning us these skills in the first subject in our database 
  ### Teachers:- ###
  #### [Dr.Nael Aburas][NaelLink] - [Dr.Rami Lubbad][RamiLink] #### 
  [RamiLink]: https://www.facebook.com/rlubbad
  [NaelLink]: https://www.facebook.com/nael.aburas
