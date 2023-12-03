----------------------------------------1----------------------------------------------

CREATE TABLE owners (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50)
);

CREATE TABLE animal_types (
	id SERIAL PRIMARY KEY,
	animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE cages (
	id SERIAL PRIMARY KEY,
	animal_type_id INT NOT NULL
);

CREATE TABLE animals (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	birthdate DATE NOT NULL,
	owner_id INT,
	animal_type_id INT NOT NULL
);

CREATE TABLE volunteers_departments (
	id SERIAL PRIMARY KEY,
	department_name VARCHAR(30) NOT NULL
);

CREATE TABLE volunteers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50),
	animal_id INT,
	department_id INT NOT NULL
);

CREATE TABLE animals_cages (
	cage_id INT NOT NULL,
	animal_id INT NOT NULL
);

ALTER TABLE cages
ADD CONSTRAINT fk_cages_animal_types
	FOREIGN KEY (animal_type_id) REFERENCES animal_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE animals
ADD CONSTRAINT fk_animals_owners
	FOREIGN KEY (owner_id) REFERENCES owners(id) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk_animals_animal_types
	FOREIGN KEY (animal_type_id) REFERENCES animal_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE volunteers
ADD CONSTRAINT fk_volunteers_animals
	FOREIGN KEY (animal_id) REFERENCES animals(id) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk_volunteers_volunteers_departments
	FOREIGN KEY (department_id) REFERENCES volunteers_departments(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE animals_cages
ADD CONSTRAINT fk_animals_cages_cages
	FOREIGN KEY (cage_id) REFERENCES cages(id) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk_animals_cages_animals
	FOREIGN KEY (animal_id) REFERENCES animals(id) ON UPDATE CASCADE ON DELETE CASCADE;


-------------------------------------------------------------------------------------

DROP TABLE volunteers CASCADE;
DROP TABLE volunteers_departments CASCADE;
DROP TABLE animals_cages CASCADE;
DROP TABLE animal_types CASCADE;
DROP TABLE animals CASCADE;
DROP TABLE owners CASCADE;
DROP TABLE cages CASCADE;

---------------------------------------------2----------------------------------------------

INSERT INTO volunteers (name, phone_number, address, animal_id, department_id)
VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5);

INSERT INTO animals (name, birthdate, owner_id, animal_type_id)
VALUES
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4);

---------------------------------------3---------------------------------------------------

UPDATE animals
SET owner_id = (select id from owners where name = 'Kaloqn Stoqnov')
WHERE owner_id is NULL;

----------------------------------------4--------------------------------------------------

DELETE FROM volunteers_departments WHERE department_name = 'Education program assistant';


-----------------------------------------5--------------------------------------------------

SELECT name, phone_number, address, animal_id, department_id
FROM volunteers
ORDER BY name ASC, department_id ASC;

---------------------------------------6-----------------------------------------------

SELECT a.name, at.animal_type, TO_CHAR(a.birthdate, 'DD.MM.YYYY') AS "birthdate"
FROM animals AS a JOIN animal_types AS at ON a.animal_type_id = at.id
ORDER BY a.name ASC;

------------------------------------------7--------------------------------------------

SELECT o.name, COUNT(*) AS count_of_animals
FROM owners AS o JOIN animals AS a ON o.id = a.owner_id
GROUP BY o.name
ORDER BY count_of_animals DESC, o.name ASC
LIMIT 5;


------------------------------------------------8-----------------------------------------

SELECT
	CONCAT(o.name, ' - ', a.name) AS "Owners-Animals",
	o.phone_number AS "Phone Number",
	ag.cage_id AS "Cage ID"
FROM owners AS o
JOIN animals AS a ON a.owner_id = o.id
JOIN animals_cages AS ag ON ag.animal_id = a.id
JOIN animal_types AS at ON at.id = a.animal_type_id
WHERE at.animal_type = 'Mammals'
ORDER BY o.name ASC, a.name DESC;

---------------------------------------------9---------------------------------------------

SELECT
	v.name,
	v.phone_number,
	SUBSTRING(TRIM(REPLACE(v.address, 'Sofia', '')), 3)
FROM volunteers AS v
JOIN volunteers_departments AS vd ON vd.id = v.department_id
WHERE vd.department_name = 'Education program assistant' AND v.address LIKE '%Sofia%'
ORDER BY v.name ASC;

-------------------------------------------------10----------------------------------------

SELECT
	a.name AS animal,
	EXTRACT(YEAR FROM a.birthdate) AS birth_year,
	at.animal_type as animal_type
FROM animals AS a JOIN animal_types AS at on at.id = a.animal_type_id
WHERE
	owner_id IS NULL and
	animal_type_id != 3 and
	AGE('01/01/2022' ,birthdate) < '5 years'
ORDER BY a.name ASC;


--------------------------------------------11---------------------------------------------

CREATE OR REPLACE FUNCTION fn_get_volunteers_count_from_department(
	searched_volunteers_department VARCHAR(30)
) RETURNS INT AS
$$
BEGIN
	RETURN (SELECT count(*)
			FROM volunteers AS v JOIN volunteers_departments AS vd ON vd.id = v.department_id
			WHERE vd.department_name = searched_volunteers_department);
END;
$$
LANGUAGE plpgsql;

--------------------------------------12-------------------------------------
CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not
(IN animal_name VARCHAR(30), OUT final1 VARCHAR(50)) AS
$$
BEGIN
	SELECT o.name
	FROM animals as a LEFT JOIN owners AS o ON o.id = a.owner_id
	WHERE a.name = animal_name
	INTO final1;
	IF final1 IS NULL THEN
		final1 := 'For adoption';
	END IF;
	RETURN;
END;
$$
LANGUAGE plpgsql





