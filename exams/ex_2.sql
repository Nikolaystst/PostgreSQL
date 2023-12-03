CREATE TABLE addresses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	age INT NOT NULL,
	rating NUMERIC(10, 2) DEFAULT 5.5,

	CONSTRAINT ck_drivers_age
		CHECK (age > 0)
);

CREATE TABLE cars (
	id SERIAL PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
	model VARCHAR(20),
	year INT NOT NULL DEFAULT 0,
	mileage INT DEFAULT 0,
	condition CHAR(1) NOT NULL,
	category_id INT NOT NULL,

	CONSTRAINT ck_cars_year
		CHECK (year > 0),
	CONSTRAINT ck_cars_mileage
		CHECK (mileage > 0),
	CONSTRAINT fk_cars_categories
		FOREIGN KEY (category_id) REFERENCES categories(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE courses (
	id SERIAL PRIMARY KEY,
	from_address_id INT NOT NULL,
	start TIMESTAMP NOT NULL,
	bill NUMERIC(10, 2) DEFAULT 10,
	car_id INT NOT NULL,
	client_id INT NOT NULL,

	CONSTRAINT ck_courses_bill CHECK (bill > 0),
	CONSTRAINT fk_courses_addresses FOREIGN KEY (from_address_id) REFERENCES addresses(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_courses_cars FOREIGN KEY (car_id) REFERENCES cars(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_courses_clients FOREIGN KEY (client_id) REFERENCES clients(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE cars_drivers (
	car_id INT NOT NULL,
	driver_id INT NOT NULL,
	CONSTRAINT fk_cars_drivers_cars FOREIGN KEY (car_id) REFERENCES cars(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_cars_drivers_drivers FOREIGN KEY (driver_id) REFERENCES drivers(id) ON UPDATE CASCADE ON DELETE CASCADE
);


DROP TABLE addresses CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE clients CASCADE;
DROP TABLE drivers CASCADE;
DROP TABLE cars CASCADE;
DROP TABLE courses CASCADE;
DROP TABLE cars_drivers CASCADE;


INSERT INTO clients(full_name, phone_number)
SELECT
	CONCAT(first_name, ' ', last_name),
	CONCAT('(088) 9999', id * 2)
FROM drivers
WHERE id BETWEEN 10 AND 20;

UPDATE cars
SET condition = 'C'
where (mileage >= 800000 or mileage IS NULL) AND year <= 2010 AND make != 'Mercedes-Benz';

DELETE FROM clients
WHERE LENGTH(full_name) > 3 AND id NOT IN (SELECT client_id FROM courses);

SELECT make, model, condition
FROM cars
ORDER BY id ASC;

SELECT
	d.first_name, d.last_name, c.make, c.model, c.mileage
FROM drivers AS d
JOIN cars_drivers AS cd ON cd.driver_id = d.id
JOIN cars AS c ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name ASC;


SELECT
	c1.id AS car_id,
	c1.make AS make,
	c1.mileage AS mileage,
	COUNT(c2.bill) AS count_of_courses,
	ROUND(AVG(c2.bill), 2) AS average_bill
FROM cars AS c1
LEFT JOIN courses AS c2 ON c1.id = c2.car_id
GROUP BY c1.id
HAVING COUNT(c2.bill) <> 2
ORDER BY count_of_courses DESC, c1.id ASC;


SELECT
	c.full_name,
	COUNT(cr.car_id),
	SUM(cr.bill)
FROM clients AS c
JOIN courses as cr ON c.id = cr.client_id
WHERE SUBSTRING(c.full_name, 2, 1) = 'a'
GROUP BY c.id
HAVING COUNT(cr.car_id) > 1
ORDER BY c.full_name ASC;

SELECT
	a.name AS address,
	CASE
		WHEN EXTRACT(HOUR FROM cr.start) BETWEEN 6 AND 20 THEN 'Day'
		WHEN EXTRACT(HOUR FROM cr.start) IN (0, 1, 2, 3, 4, 5, 21, 22, 23) THEN 'Night'
		END AS day_time,
	cr.bill,
	cl.full_name,
	ca.make,
	ca.model,
	ca1.name AS category_name
FROM courses AS cr
JOIN clients AS cl ON cl.id = cr.client_id
JOIN cars AS ca ON ca.id = cr.car_id
JOIN addresses AS a ON a.id = cr.from_address_id
JOIN categories AS ca1 ON ca1.id = ca.category_id
ORDER BY cr.id;


CREATE OR REPLACE FUNCTION fn_courses_by_client(
phone_num VARCHAR(20)) RETURNS INT AS
$$
BEGIN
	RETURN (SELECT
			COUNT(CR.id)
			FROM clients AS cl
			LEFT JOIN courses AS cr ON cr.client_id = cl.id
			WHERE phone_number = phone_num);
END;
$$
LANGUAGE plpgsql

SELECT fn_courses_by_client('(803) 6386812')
SELECT fn_courses_by_client('(831) 1391236')
SELECT fn_courses_by_client('(704) 2502909')






CREATE TABLE search_results (
    id SERIAL PRIMARY KEY,
    address_name VARCHAR(50),
    full_name VARCHAR(100),
    level_of_bill VARCHAR(20),
    make VARCHAR(30),
    condition CHAR(1),
    category_name VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address(address_name VARCHAR(100)) AS
$$
BEGIN
	TRUNCATE search_results;
	INSERT INTO search_results(address_name, full_name, level_of_bill, make, condition, category_name)
	SELECT
		a.name,
		cl.full_name,
		CASE
		WHEN cr.bill <= 20 THEN 'Low'
		WHEN cr.bill <= 30 THEN 'Medium'
		WHEN cr.bill > 30 THEN 'High'
		END AS level_of_bill,
		ca.make,
		ca.condition,
		ca1.name
	FROM addresses AS a
	JOIN courses AS cr ON a.id = cr.from_address_id
	JOIN clients AS cl ON cl.id = cr.client_id
	JOIN cars AS ca on ca.id = cr.car_id
	JOIN categories AS ca1 ON ca1.id = ca.category_id
	WHERE a.name = address_name
	ORDER BY ca.make, cl.full_name;
END;
$$
LANGUAGE plpgsql




CALL sp_courses_by_address('700 Monterey Avenue');

SELECT * FROM search_results;


CALL sp_courses_by_address('66 Thompson Drive');

SELECT * FROM search_results;
















