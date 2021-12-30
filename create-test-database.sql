CREATE DATABASE employees;
CREATE TABLE employees (ID BIGSERIAL PRIMARY KEY NOT NULL, PASSWORD CHAR(256));
INSERT INTO employees (ID,PASSWORD) VALUES ('abc'), ('password123'), ('passwordasdfkljasdlkfj'), ('topsecret123');
# DROP table employees;
# DROP database employees;

