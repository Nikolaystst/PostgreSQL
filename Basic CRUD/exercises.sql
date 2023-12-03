SELECT
	*
FROM
	cities
ORDER BY
	id;

SELECT
	CONCAT(name, ' ', state) AS "Cities Information",
	area AS "Area (km2)"
FROM
	cities;

SELECT
	DISTINCT name,
	area AS "Area (km2)"
FROM
	cities
ORDER BY
	name DESC;

SELECT
	id as "ID",
	CONCAT(first_name, ' ', last_name) AS "Full Name",
	job_title AS "Job Title"
FROM
	employees
ORDER BY
	first_name ASC
LIMIT 50;

SELECT
	id,
	CONCAT(first_name, ' ',middle_name, ' ', last_name) AS "Full Name",
	hire_date AS "Hire Date"
FROM
	employees
ORDER BY
	hire_date
OFFSET 9;

SELECT
	id,
	CONCAT(number, ' ', street) AS "Address",
	city_id
FROM
	addresses
WHERE
	ID >= 20;

SELECT
	CONCAT(number, ' ', street) AS "Address",
	city_id
FROM
	addresses
WHERE
	city_id > 0 and city_id % 2 = 0
ORDER BY
	city_id ASC;

SELECT
	name,
	start_date,
	end_date
FROM
	projects
WHERE
	start_date >= '2016-06-01 07:00:00'
		AND
	end_date < '2023-06-04 00:00:00'
ORDER BY
	start_date ASC;

SELECT
	number,
	street
FROM
	addresses
WHERE
	id BETWEEN 50 AND 100
		OR
	number < 1000;

SELECT
	employee_id,
	project_id
FROM
	employees_projects
WHERE
	employee_id IN (200, 250)
		AND
	project_id NOT IN (50, 100);

SELECT
	name,
	start_date
FROM
	projects
WHERE
	name IN ('Mountain', 'Road', 'Touring')
LIMIT 20;

SELECT
	CONCAT(first_name, ' ', last_name) AS "Full name",
	job_title,
	salary
FROM
	employees
WHERE
	salary IN (12500, 14000, 23600, 25000)
ORDER BY
	salary DESC;

SELECT
	id,
	first_name,
	last_name
FROM
	employees
WHERE
	middle_name IS NULL
LIMIT 3;

INSERT INTO
	departments(department, manager_id)
VALUES
	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109);

CREATE TABLE company_chart AS
SELECT
	CONCAT(first_name, ' ', last_name) as "Full name",
	job_title as "Job Title",
	department_id as "Department ID",
	manager_id as "Manager ID"
FROM
	employees;

UPDATE
	projects
SET
	end_date = start_date + INTERVAL '5 months'
WHERE
	end_date is null;

UPDATE
	employees
SET
	salary = salary + 1500,
	job_title = CONCAT('Senior' ,' ', job_title)
WHERE
	hire_date BETWEEN '1998-1-1' AND '2000-1-5';

DELETE FROM
	addresses
WHERE
	city_id IN (5, 17, 20, 30);

CREATE VIEW view_company_chart AS
SELECT
	"Full name",
	"Job Title"
FROM
	company_chart
WHERE
	"Manager ID" = 184;

CREATE VIEW view_addresses AS
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS "Full Name",
	e.department_id,
	CONCAT(a.number, ' ', a.street) AS "Address"
FROM
	employees as e,
	addresses as a
WHERE
	e.address_id = a.id
ORDER BY
	"Address" ASC;

CREATE VIEW
	view_addresses
AS
SELECT
	e.first_name || ' ' || e.last_name AS "Full Name",
	e.department_id,
	a.number || ' ' || a.street AS "Address"
FROM
	employees AS e
JOIN
	addresses AS a
		ON
	e.address_id = a.id
ORDER BY
	"Address" ASC;

ALTER VIEW view_addresses
RENAME TO view_employee_addresses_info;

DROP VIEW view_company_chart;

UPDATE projects
SET
	name = UPPER(name);

CREATE VIEW view_initials AS
SELECT
	SUBSTRING(first_name, 1, 2) AS initial,
	last_name
FROM
	employees
ORDER BY
	last_name ASC;

SELECT
	name,
	start_date
FROM
	projects
WHERE
	name LIKE 'MOUNT%'
ORDER BY
	id ASC;
