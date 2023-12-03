CREATE TABLE
	employees(
		id serial PRIMARY KEY Not NULL
		,first_name VARCHAR(30)
		,last_name VARCHAR(50)
		,hiring_date date DEFAULT '2023-01-01'
		,salary numeric(10, 2)
		,devices_number int
	);

CREATE TABLE
	departments(
		id serial PRIMARY KEY Not NULL
		,"name" VARCHAR(50)
		,code char(3)
		,description text
	);

CREATE TABLE
	issues(
		id serial PRIMARY KEY UNIQUE
		,description VARCHAR(150)
		,"date" date
		,"start" timestamp
	);

ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50);

ALTER TABLE employees
ALTER COLUMN salary SET Not NULL,
ALTER COLUMN salary SET DEFAULT 0,
ALTER COLUMN hiring_date SET NOT NULL;

ALTER TABLE employees
ALTER COLUMN middle_name TYPE VARCHAR(100);

TRUNCATE TABLE issues;

DROP TABLE departments;





