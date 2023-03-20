CREATE TABLE "THING" ("ID" NUMBER(19) PRIMARY KEY NOT NULL,"NAME" VARCHAR(255) NOT NULL);
CREATE SEQUENCE "THING_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE conditions (condition_id int, condition_name VARCHAR(255));
CREATE SEQUENCE "CONDITIONS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE users (user_id int, email VARCHAR(255), password VARCHAR(255), firstname VARCHAR(255), lastname VARCHAR(255), birthdate date);
CREATE SEQUENCE "USERS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE user_conditions (user_condition_id int, user_id int, condition_id int);
CREATE SEQUENCE "USER_CONDITIONS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE user_supplements (user_supplement_id int, user_id int, supplement_id int);
CREATE SEQUENCE "USER_SUPPLEMENTS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE symptoms (symptom_id int, condition_id int, symptom VARCHAR(255));
CREATE SEQUENCE "SYMPTOMS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE supplements (supplement_id int, symptom_id int, description VARCHAR(255));
CREATE SEQUENCE "SUPPLEMENTS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE symptom_logs (symptom_log_id int, symptom_id int, user_id int, severity int, timestamp Timestamp, condition_id int);
CREATE SEQUENCE "SYMPTOM_LOGS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE supplement_logs (supplement_log_id int, supplement_id int, user_id int, dosage int, dosage_unit VARCHAR(255), timestamp Timestamp);
CREATE SEQUENCE "SUPPLEMENT_LOGS_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;