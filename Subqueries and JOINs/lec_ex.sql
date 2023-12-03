-----------------------1-------------------------
SELECT
	CONCAT(a.address, ' ', a.address_2) AS "apartment_address",
	b.booked_for AS "nights"
FROM
	apartments AS a
JOIN
	bookings AS b
ON
	a.booking_id = b.booking_id
ORDER BY
	a.apartment_id ASC;



-----------------------2------------------------
SELECT
	a.name,
	a.country,
	b.booked_at::DATE
FROM
	apartments AS a
LEFT JOIN
	bookings AS b
ON
	a.booking_id = b.booking_id
LIMIT
	10;



--------------------3---------------------------
SELECT
	b.booking_id,
	b.starts_at::DATE,
	b.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS "Customer Name"
FROM
	bookings AS b
RIGHT JOIN
	customers AS c
ON
	c.customer_id = b.customer_id
ORDER BY
	"Customer Name" ASC
LIMIT 10;




----------------------4------------------------
SELECT
	b.booking_id,
	a.name AS "apartment_owner",
	a.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS "customer_name"
FROM
	apartments AS a
FULL JOIN
	bookings AS b
ON
	a.booking_id = b.booking_id
FULL JOIN
	customers AS c
ON
	b.customer_id = c.customer_id
ORDER BY
	b.booking_id,
	"apartment_owner",
	"customer_name";



-----------------------5--------------------------
SELECT
	b.booking_id,
	c.first_name
FROM
	bookings AS b
CROSS JOIN
	customers as c
ORDER BY
	c.first_name ASC;



------------------------6---------------------------
SELECT
	b.booking_id,
	b.apartment_id,
	c.companion_full_name
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	b.apartment_id IS NULL;



---------------------7--------------------------------
SELECT
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	c.job_type = 'Lead';



----------------------------------8-----------------------
SELECT
	COUNT(*)
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	c.last_name = 'Hahn';




---------------------------------9-------------------------
SELECT
	a.name,
	SUM(b.booked_for)
FROM
	apartments AS a
JOIN
	bookings AS b
ON
	b.apartment_id = a.apartment_id
GROUP BY
	a.name
ORDER BY
	a.name ASC;



---------------------------10---------------------------
SELECT
	a.country,
	count(b.booking_id) AS "booking_count"
FROM
	apartments AS a
JOIN
	bookings AS b
ON
	b.apartment_id = a.apartment_id
WHERE
	b.booked_at > '2021-05-18 07:52:09.904+03'
	and
	b.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY
	a.country
ORDER BY
	"booking_count" DESC;

-----------------------11--------------------------------
SELECT
	mc.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM
	mountains AS m
JOIN
	peaks AS p
ON
	p.mountain_id = m.id
JOIN
	mountains_countries AS mc
ON
	m.id = mc.mountain_id
WHERE
	mc.country_code = 'BG'
	AND
	p.elevation > 2835
ORDER BY
	p.elevation DESC;


------------------------------12---------------------------------
SELECT
	mc.country_code,
	COUNT(*) AS "mountain_range_count"
FROM
	mountains AS m
JOIN
	mountains_countries as mc
ON
	m.id = mc.mountain_id
WHERE
	mc.country_code in ('US', 'RU', 'BG')
GROUP BY
	mc.country_code
ORDER BY
	"mountain_range_count" DESC;


-------------------------------13------------------------------

SELECT
	c.country_name,
	r.river_name
FROM
	countries AS c
LEFT JOIN
	countries_rivers AS cr
USING
	(country_code)
LEFT JOIN
	rivers AS r
ON
	r.id = cr.river_id
WHERE
	c.continent_code = 'AF'
ORDER BY
	c.country_name ASC
LIMIT 5;



-----------------------------------14-----------------------------
SELECT
	MIN("f") AS "min_average_area"
FROM
	(SELECT
		AVG(c1.area_in_sq_km) AS "f"
	FROM
		countries AS c1
	GROUP BY
		c1.continent_code) AS "final";






--------------------------------15-------------------------------
SELECT
	COUNT(*)
FROM
	mountains_countries AS mc
RIGHT JOIN
	countries as c
ON
	mc.country_code = c.country_code
WHERE
	mc.country_code IS NULL;



-------------------------------16--------------------------------
CREATE TABLE monasteries (
	id SERIAL PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);



INSERT INTO
	monasteries(monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
	('Bachkovo Monastery "Virgin Mary"', 'BG'),
	('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR');



ALTER TABLE
	countries
ADD COLUMN
	three_rivers BOOLEAN DEFAULT FALSE;

UPDATE countries
SET three_rivers = (
	SELECT
		COUNT(*) > 3
	FROM
		countries_rivers
	WHERE countries_rivers.country_code = countries.country_code
	);



SELECT
	m.monastery_name,
	c.country_name
FROM
	monasteries AS m
JOIN
	countries AS c
USING
	(country_code)
WHERE
	NOT three_rivers
ORDER BY
	m.monastery_name ASC;

--------------------------17---------------------------

UPDATE countries
 SET country_name = 'Burma'
 WHERE country_name = 'Myanmar';

 INSERT INTO
         monasteries (monastery_name, country_code)
         (
         SELECT
                 'Hanga Abbey',
                 country_code
         FROM
                 countries
         WHERE
                 country_name = 'Tanzania'
         );

 INSERT INTO
         monasteries (monastery_name, country_code)
         (
         SELECT
                 'Myin-Tin-Daik',
                 country_code
         FROM
                 countries
         WHERE
                 country_name = 'Myanmar'
         );


 SELECT
         con.continent_name AS "Continent Name",
         c.country_name AS "Country Name",
         COUNT(m.country_code) AS "Monasteries Count"
 FROM
         continents con
 JOIN
         countries c USING(continent_code)
 LEFT JOIN
         monasteries m USING(country_code)
 WHERE
         c.three_rivers = false
 GROUP BY
         c.country_name,
         con.continent_name
 ORDER BY
         "Monasteries Count" DESC,
         "Country Name";

