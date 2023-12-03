
CREATE VIEW view_river_info AS
SELECT
	CONCAT_WS(' ', 'The river', river_name, 'flows into the', outflow, 'and is', length, 'kilometers long.') AS "River Information"
FROM
	rivers
ORDER BY river_name ASC;





CREATE VIEW view_continents_countries_currencies_details AS
SELECT
	CONCAT(con.continent_name, ': ', con.continent_code) AS "Continent Details",
	CONCAT(cou.country_name, ' - ', capital, ' - ', area_in_sq_km, ' - ', 'km2') AS "Country Information",
	CONCAT(cur.description, ' (', cur.currency_code, ')') AS "Currencies"
FROM
	continents AS con,
	countries AS cou,
	currencies AS cur
WHERE
	con.continent_code = cou.continent_code
		AND
	cou.currency_code = cur.currency_code
ORDER BY "Country Information" ASC,
	"Currencies" ASC;





ALTER TABLE countries
ADD COLUMN capital_code CHAR(2);

UPDATE countries
SET capital_code = SUBSTRING(capital, 1, 2);


SELECT
	(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1] AS river_length
FROM
	view_river_info;


SELECT
	REPLACE(mountain_range, 'a', '@') AS "replace_a",
	REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM
	mountains;



SELECT
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS "translated_name"
FROM
	countries;




SELECT
	continent_name,
	LTRIM(continent_name) AS trim
FROM
	continents;



SELECT
	continent_name,
	RTRIM(continent_name) AS trim
FROM
	continents;


SELECT
	LTRIM(peak_name, 'M') AS "Left Trim",
	RTRIM(peak_name, 'm') AS "Right Trim"
FROM
	peaks;




SELECT
	CONCAT(m.mountain_range, ' ', p.peak_name) AS "Mountain Information",
	CHAR_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "Characters Length",
	BIT_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "Bits of a String"
FROM
	mountains AS m,
	peaks AS p
WHERE
	m.id = p.mountain_id;




SELECT
	population,
	LENGTH(population::VARCHAR)
FROM
	countries;



SELECT
	peak_name,
	LEFT(peak_name, 4) AS "Positive Left",
	LEFT(peak_name, -4) AS "Negative Left"
FROM
	peaks;




SELECT
	peak_name,
	RIGHT(peak_name, 4) AS "Positive Right",
	RIGHT(peak_name, -4) AS "Negative Right"
FROM
	peaks;



UPDATE countries
SET iso_code = UPPER(LEFT(country_name, 3))
WHERE iso_code IS NULL;





UPDATE countries
SET country_code = LOWER(REVERSE(country_code));



SELECT
	CONCAT(elevation, ' ', REPEAT('-', 3), REPEAT('>', 2), ' ', peak_name) as "Elevation -->> Peak Name"
FROM
	peaks
WHERE
	 elevation >= 4884;



CREATE TABLE bookings_calculation AS
SELECT
	booked_for
FROM
	bookings
WHERE
	apartment_id = 93;

ALTER TABLE bookings_calculation
ADD COLUMN multiplication NUMERIC,
ADD COLUMN modulo NUMERIC;

UPDATE bookings_calculation
SET
	multiplication = (booked_for * 50)::NUMERIC,
	modulo = (booked_for % 50)::NUMERIC;




SELECT
	latitude,
	ROUND(latitude, 2),
	TRUNC(latitude, 2)
FROM
	apartments;





SELECT
	longitude,
	ABS(longitude)
FROM
	apartments;





SELECT
	TO_CHAR(billing_day, 'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS') AS "Billing Day"
FROM
	bookings;




SELECT
	EXTRACT(YEAR FROM booked_at) AS "YEAR",
	EXTRACT(MONTH FROM booked_at) AS "MONTH",
	EXTRACT(DAY FROM booked_at) AS "DAY",
	EXTRACT(HOUR FROM booked_at AT TIME ZONE 'UTC') AS "HOUR",
	EXTRACT(MINUTE FROM booked_at) AS "MINUTE",
	CEIL(EXTRACT(SECOND FROM booked_at)) AS "SECOND"
FROM
	bookings;




SELECT
	user_id,
	AGE(starts_at, booked_at) as "Early Birds"
FROM
	bookings
WHERE
	AGE(starts_at, booked_at) >= INTERVAL '10 months';



SELECT
	companion_full_name,
	email
FROM
	users
WHERE
	companion_full_name ILIKE '%aNd%'
		AND
	email NOT LIKE '%@gmail';


SELECT
	LEFT(first_name, 2) AS initials,
	COUNT('initials') AS "user_count"
FROM
	users
GROUP BY
	initials
ORDER BY
	user_count DESC,
	initials ASC;






SELECT
	SUM(booked_for) AS "total_value"
FROM
	bookings
WHERE
	apartment_id = 90;





SELECT
	AVG(multiplication) AS "average_value"
FROM
	bookings_calculation;
