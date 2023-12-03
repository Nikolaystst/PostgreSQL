CREATE TABLE towns (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

CREATE TABLE stadiums (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	capacity INT NOT NULL,
	town_id INT NOT NULL,

	CONSTRAINT ck_stadiums_capacity
		CHECK (capacity > 0),
	CONSTRAINT fk_stadiums_towns
		FOREIGN KEY (town_id)
		REFERENCES towns(id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE teams (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	established DATE NOT NULL,
	fan_base INT NOT NULL DEFAULT 0,
	stadium_id INT NOT NULL,

	CONSTRAINT ck_teams_fan_base
		CHECK (fan_base >= 0),
	CONSTRAINT fk_teams_stadiums
		FOREIGN KEY (stadium_id)
		REFERENCES stadiums(id) ON UPDATE CASCADE ON DELETE CASCADE
);



CREATE TABLE coaches (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 0,
	coach_level INT NOT NULL DEFAULT 0,

	CONSTRAINT ck_coaches_salary
		CHECK (salary >= 0),
	CONSTRAINT ck_coaches_coach_level
		CHECK (coach_level >= 0)
);


CREATE TABLE skills_data (
	id SERIAL PRIMARY KEY,
	dribbling INT DEFAULT 0,
	pace INT DEFAULT 0,
	passing INT DEFAULT 0,
	shooting INT DEFAULT 0,
	speed INT DEFAULT 0,
	strength INT DEFAULT 0,

	CONSTRAINT ck_skills_data_dribbling
		CHECK (dribbling >= 0),
	CONSTRAINT ck_skills_data_pace
		CHECK (pace >= 0),
	CONSTRAINT ck_skills_data_passing
		CHECK (passing >= 0),
	CONSTRAINT ck_skills_data_shooting
		CHECK (shooting >= 0),
	CONSTRAINT ck_skills_data_speed
		CHECK (speed >= 0),
	CONSTRAINT ck_skills_data_strength
		CHECK (strength >= 0)
);


CREATE TABLE players (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	age INT NOT NULL DEFAULT 0,
	position CHAR(1) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 0,
	hire_date TIMESTAMP,
	skills_data_id INT NOT NULL,
	team_id INT,

	CONSTRAINT ck_players_age
		CHECK (age >= 0),
	CONSTRAINT ck_players_salary
		CHECK (salary >= 0),
	CONSTRAINT fk_players_skills_data
		FOREIGN KEY (skills_data_id)
		REFERENCES skills_data(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_players_teams
		FOREIGN KEY (team_id)
		REFERENCES teams(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE players_coaches (
	player_id INT,
	coach_id INT,

	CONSTRAINT fk_players_coaches_players
		FOREIGN KEY (player_id)
		REFERENCES players(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_players_coaches_coaches
		FOREIGN KEY (coach_id)
		REFERENCES coaches(id) ON UPDATE CASCADE ON DELETE CASCADE
);





-- 22222222222222222222222222222222222222222222222222222222222222222222222222222222222222


INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT
	first_name,
	last_name,
	salary * 2,
	LENGTH(first_name)
FROM players
WHERE hire_date < '2013-12-13 07:18:46'

-- 3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

UPDATE coaches
SET salary = salary * coach_level
WHERE first_name LIKE 'C%' AND id in (1, 2, 5, 4, 8, 10, 6)


-- 444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

DELETE FROM players
WHERE (first_name, last_name) IN (
    SELECT p.first_name, p.last_name
    FROM players p
    WHERE p.hire_date < '2013-12-13 07:18:46'
);

DELETE FROM players_coaches
WHERE coach_id BETWEEN 11 and 45;

-- 55555555555555555555555555555555555555555555555555555555555555555555555555555555555555

SELECT
	CONCAT(first_name, ' ', last_name) AS full_name,
	age,
	hire_date
FROM players
WHERE first_name LIKE 'M%'
ORDER BY age DESC, full_name ASC;

-- 66666666666666666666666666666666666666666666666666666666666666666666666666666666666666

SELECT
	p.id,
	CONCAT(p.first_name, ' ', p.last_name) AS full_name,
	p.age,
	p.position,
	p.salary,
	sd.pace,
	sd.shooting
FROM players AS p
JOIN skills_data AS sd ON sd.id = p.skills_data_id
WHERE p.team_id IS NULL
	AND
	(sd.pace + sd.shooting > 130)
	AND
	p.position = 'A'

-- 7777777777777777777777777777777777777777777777777777777777777777777777777777777777

SELECT
	t.id,
	t.name,
	COUNT(p.id),
	t.fan_base
FROM
	teams AS t
LEFT JOIN players AS p ON t.id = p.team_id
WHERE t.fan_base > 30000
GROUP BY t.id
ORDER BY COUNT(p.id) DESC, t.fan_base DESC;

-- 88888888888888888888888888888888888888888888888888888888888888888888888888888

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS coach_full_name,
	CONCAT(p.first_name, ' ', p.last_name)  AS player_full_name,
	t.name,
	sd.passing,
	sd.shooting,
	sd.speed
FROM coaches AS c
JOIN players_coaches AS pc ON pc.coach_id = c.id
JOIN players AS p ON p.id = pc.player_id
JOIN skills_data AS sd on sd.id = p.skills_data_id
JOIN teams AS t ON t.id = p.team_id
ORDER BY coach_full_name ASC, player_full_name DESC;


-- 9999999999999999999999999999999999999999999999999999999999999999999999999999

CREATE OR REPLACE FUNCTION fn_stadium_team_name(stadium_name VARCHAR(30))
RETURNS TABLE (fn_stadium_team_name VARCHAR(45)) AS
$$
BEGIN
	RETURN  QUERY
			SELECT
				t1.name
			FROM
				stadiums AS s
			JOIN teams AS t1 on t1.stadium_id = s.id
			WHERE s.name = stadium_name
			ORDER BY t1.name ASC;
END;
$$
LANGUAGE plpgsql;

-- 10101010101010101010101010101010101010101010101010101010101010101010101010101010

CREATE OR REPLACE PROCEDURE sp_players_team_name(IN player_name VARCHAR(30), OUT final1 VARCHAR(50))
AS
$$
BEGIN
	SELECT t.name
	FROM players AS p
	LEFT JOIN teams AS t on t.id = p.team_id
	WHERE CONCAT(p.first_name, ' ', p.last_name) = player_name
	INTO final1;
	IF final1 IS NULL THEN
		final1 := 'The player currently has no team';
	END IF;
END;
$$
LANGUAGE plpgsql