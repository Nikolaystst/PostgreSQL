CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

CREATE TABLE addresses (
	id SERIAL PRIMARY KEY,
	street_name VARCHAR(100) NOT NULL,
	street_number INT NOT NULL,
	town VARCHAR(30) NOT NULL,
	country VARCHAR(50) NOT NULL,
	zip_code INT NOT NULL,

	CONSTRAINT ck_categories_street_number CHECK (street_number > 0),
	CONSTRAINT ck_categories_zip_code CHECK (zip_code > 0)
);

CREATE TABLE publishers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	address_id INT NOT NULL,
	website VARCHAR(40),
	phone VARCHAR(20),

	CONSTRAINT fk_publishers_addresses FOREIGN KEY (address_id) REFERENCES addresses(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE players_ranges (
	id SERIAL PRIMARY KEY,
	min_players INT NOT NULL,
	max_players INT NOT NULL,

	CONSTRAINT ck_player_ranges_min_players CHECK (min_players > 0),
	CONSTRAINT ck_player_ranges_max_players CHECK (max_players > 0)
);

CREATE TABLE creators (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	email VARCHAR(30) NOT NULL
);

CREATE TABLE board_games (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	release_year INT NOT NULL,
	rating NUMERIC(10, 2) NOT NULL,
	category_id INT NOT NULL,
	publisher_id INT NOT NULL,
	players_range_id INT NOT NULL,


	CONSTRAINT ck_board_games_release_year CHECK (release_year > 0),
	CONSTRAINT fk_board_games_categories FOREIGN KEY (category_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_board_games_publishers FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_board_games_players_ranges FOREIGN KEY (players_range_id) REFERENCES players_ranges(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE creators_board_games (
	creator_id INT NOT NULL,
	board_game_id INT NOT NULL,

	CONSTRAINT fk_creators_board_games_creators FOREIGN KEY (creator_id) REFERENCES creators(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_creators_board_games_board_games FOREIGN KEY (board_game_id) REFERENCES board_games(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO categories ("name")
VALUES
	('Abstract Games'),
	('Children Games'),
	('Customizable Games'),
	('Family Games'),
	('Party Games'),
	('Strategy Games'),
	('Thematic Games'),
	('Wargames');


INSERT INTO addresses (street_name, street_number, town, country, zip_code)
VALUES
	('Sunset blvd.', 65, 'New York', 'USA', 10001),
	('London str.', 123, 'New York', 'USA', 15685),
	('Rue de Paris', 3, 'Paris', 'France', 47963),
	('High Street', 8, 'Boston', 'USA', 68732),
	('Chapman Ave', 15, 'Los Angeles', 'USA', 35746),
	('Zaokopowa', 534, 'Warsaw', 'Poland', 10000),
	('Gladeville Rd', 1, 'Nashville', 'USA', 12354),
	('Liberty Str.', 54, 'Barre', 'USA', 93457),
	('Park Ave', 15, 'Providence', 'USA', 12493),
	('Mercedes strasse', 15, 'Gutweiler', 'Germany', 56317),
	('Alexander Str.', 15, 'New Haven', 'USA', 23485),
	('Bassett Str.', 12, 'Middletown', 'USA', 23498),
	('Second Ave', 24, 'Pittsburgh', 'USA', 21348),
	('Green Str.', 2, 'Meadville', 'USA', 46734),
	('Cambridge Ave', 987, 'Phoenix ', 'USA', 38765);


INSERT INTO publishers ("name", address_id, website, phone)
VALUES
	('Fantasy Flight Games', 5, 'www.fantasyflightgames.com', '+18553828880'),
	('Z-Man Games', 9, 'www.zmangames.com', '+12165461654'),
	('Rio Grande Games', 11, 'www.riograndegames.com', '+16546135543'),
	('Asmodee', 13, 'www.asmodee.com', '+18987354656'),
	('Stonemaier Games', 1, 'www.stonemaiergames.com', '+18965478963'),
	('Zczech Games Edition', 8, 'www.czechgames.com', '+17582356651'),
	('Days of Wonder', 14, 'www.daysofwonder.com', '+15558889991'),
	('Renegade Game Studios', 7, 'www.renegadegamestudios.com', '+15588899845'),
	('IELLO', 12, 'www.iello.fr', '+18954631613'),
	('Lookout Games', 10, 'www.lookout-spiele.de', '+10008200005'),
	('CMON', 2, 'www.cmon.com', '+10046464654'),
	('Ravensburger', 4, 'www.ravensburger.com', '+15446874646'),
	('Stronghold Games', 3, 'www.strongholdgames.com', '+10465056486'),
	('Gamewright', 15, 'www.gamewright.com', '+12345678905'),
	('Portal Games', 6, 'www.portalgames.pl', '+13259541983');


INSERT INTO players_ranges (min_players, max_players)
VALUES
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(3, 3),
	(3, 4),
	(3, 5),
	(4, 4),
	(4, 5),
	(5, 5);


INSERT INTO creators (first_name, last_name, email)
VALUES
	('Uwe', 'Rosenberg', 'uwe@rosenberg.net'),
	('Bruno', 'Cathala', 'bruno@cathala.com'),
	('Matt', 'Leacock', 'matt@leacock.net'),
	('Emerson', 'Matsuuchi', 'emerson@matsuuchi.com'),
	('Corey', 'Konieczka', 'corey@konieczka.com'),
	('Alexander', 'Pfister', 'alexander@pfister.com'),
	('Jamey', 'Stegmaier', 'jamey@stegmaier.com');


INSERT INTO board_games ("name", release_year, rating, category_id, publisher_id, players_range_id)
VALUES
	('Beyond the Sun', 2021, 8.19, 6, 1, 1),
	('Sumatra', 2021, 7.08, 4, 2, 2),
	('Small World of Warcraft', 2021, 7.69, 4, 3, 3),
	('Blue Skies', 2021, 6.53, 6, 4, 4),
	('GOLD', 2022, 7.01, 4, 5, 5),
	('Polis', 2022, 8.58, 8, 6, 6),
	('Pan Am', 2022, 7.79, 6, 7, 7),
	('Betrayal at Mystery Mansion', 2022, 6.89, 4, 8, 8),
	('Marshmallow Test', 2022, 6.66, 4, 9, 9),
	('Abandon All Artichokes', 2020, 7.12, 4, 10, 10),
	('Glasgow', 2018, 7.37, 6, 11, 1),
	('KeyForge: Mass Mutation', 2018, 8.27, 3, 12, 2),
	('The Castles of Tuscany', 2018, 7.39, 6, 13, 3),
	('Dragomino', 2018, 7.3, 2, 14, 4),
	('Alma Mater', 2018, 7.68, 6, 15, 5),
	('Santa Monica', 2018, 7.54, 4, 1, 6),
	('Battle Line: Medieval', 2017, 7.73, 6, 2, 7),
	('Mariposas', 2020, 7.2, 4, 3, 8),
	('Kemet: Blood and Sand', 2021, 8.49, 6, 4, 9),
	('Ride the Rails', 2020, 7.38, 6, 5, 10),
	('Fort', 2020, 7.4, 6, 6, 1),
	('My City', 2020, 7.87, 6, 7, 2),
	('Unmatched: Cobble & Fog', 2020, 8.47, 6, 8, 3),
	('Stellar', 2020, 7.6, 6, 9, 4),
	('Kitara', 2020, 7.31, 4, 10, 5),
	('Nidavellir', 2020, 7.95, 4, 11, 6),
	('Dolina królików', 2019, 7.64, 4, 12, 7),
	('Undaunted: North Africa', 2020, 8.09, 8, 13, 8),
	('Verdun 1916: Steel Inferno', 2020, 8.6, 8, 14, 9),
	('The Fox in the Forest Duet', 2020, 7.29, 4, 15, 10),
	('Azul: Summer Pavilion', 2019, 7.83, 1, 1, 1),
	('Kitchen Rush (Revised Edition)', 2019, 7.73, 4, 2, 5),
	('Aristocracy', 2019, 6.63, 4, 3, 9),
	('Tajuto', 2019, 6.73, 4, 4, 3),
	('SPELL', 2020, 8.36, 1, 5, 7),
	('Godspeed', 2020, 7.32, 6, 6, 1),
	('Ankh: Gods of Egypt', 2021, 7.2, 6, 7, 2),
	('Miyabi', 2019, 7.55, 4, 8, 3),
	('Rune Stones', 2019, 7.32, 4, 9, 4),
	('Brief Border Wars', 2020, 7.54, 8, 10, 5),
	('Caylus 1303', 2019, 7.63, 6, 11, 6),
	('Funkoverse Strategy Game', 2019, 7.43, 3, 12, 7),
	('Butterfly', 2019, 6.67, 4, 13, 8),
	('Pictures', 2019, 7.23, 4, 14, 9),
	('Lost Cities: Auf Schatzsuche', 2019, 6.52, 4, 15, 10);


INSERT INTO creators_board_games (creator_id, board_game_id)
VALUES
	(1, 1),
	(1, 5),
	(1, 8),
	(1, 12),
	(1, 15),
	(1, 19),
	(1, 22),
	(1, 26),
	(1, 29),
	(1, 33),
	(1, 36),
	(1, 40),
	(1, 43),
	(2, 2),
	(2, 6),
	(2, 9),
	(2, 13),
	(2, 16),
	(2, 20),
	(2, 23),
	(2, 27),
	(2, 30),
	(2, 34),
	(2, 37),
	(2, 41),
	(2, 44),
	(3, 3),
	(3, 7),
	(3, 10),
	(3, 14),
	(3, 17),
	(3, 21),
	(3, 24),
	(3, 28),
	(3, 31),
	(3, 35),
	(3, 38),
	(3, 42),
	(3, 45),
	(4, 1),
	(4, 4),
	(4, 8),
	(4, 11),
	(4, 15),
	(4, 18),
	(4, 22),
	(4, 29),
	(4, 36),
	(4, 43),
	(4, 28),
	(4, 35),
	(4, 42),
	(6, 3),
	(6, 6),
	(6, 10),
	(6, 13),
	(6, 17),
	(6, 20),
	(6, 24),
	(6, 27),
	(6, 31),
	(6, 34),
	(6, 38),
	(6, 41),
	(6, 45),
	(6, 4),
	(6, 7),
	(6, 11),
	(6, 14),
	(6, 18),
	(6, 21);

DROP TABLE categories CASCADE;
DROP TABLE addresses CASCADE;
DROP TABLE publishers CASCADE;
DROP TABLE players_ranges CASCADE;
DROP TABLE creators CASCADE;
DROP TABLE board_games CASCADE;
DROP TABLE creators_board_games CASCADE;
---------------------------------------------------------

INSERT INTO board_games(name, release_year, rating, category_id, publisher_id, players_range_id)
VALUES
	('Deep Blue', 2019, 5.67, 1, 15, 7),
	('Paris', 2016, 9.78, 7, 1, 5),
	('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
	('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
	('One Small Step', 2019, 5.75, 5, 9, 2);

INSERT INTO publishers(name, address_id, website, phone)
VALUES
	('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
	('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
	('BattleBooks', 13, 'www.battlebooks.com', '+12345678907');

---------------------------------------------------------

UPDATE players_ranges
SET max_players = 3
WHERE min_players = 2 and max_players = 2;

UPDATE board_games
SET name = CONCAT(name, ' V2')
WHERE release_year >= 2020;




---------------------------------------------------------


SELECT *
FROM addresses AS a
JOIN publishers AS p ON P.address_id = a.id
JOIN board_games AS bg ON bg.publisher_id = p.id
WHERE a.town LIKE 'L%'




---------------------------------------------------------
DELETE FROM board_games
WHERE publisher_id IN (
    SELECT p.id
    FROM addresses AS a
    JOIN publishers AS p ON p.address_id = a.id
    JOIN board_games AS bg ON bg.publisher_id = p.id
    WHERE a.town LIKE 'L%'
);

DELETE FROM publishers
WHERE id IN (
    SELECT p.id
    FROM addresses AS a
    JOIN publishers AS p ON p.address_id = a.id
    WHERE a.town LIKE 'L%'
);

DELETE FROM addresses
WHERE town LIKE 'L%';

-------------------------------------------------------------------------------------------
SELECT name, rating FROM board_games
ORDER BY release_year ASC, name DESC;

-------------------------------------------------------------------------------------

SELECT bg.id, bg.name, bg.release_year, c.name
FROM board_games AS bg
JOIN categories AS c ON c.id = bg.category_id
WHERE c.name in ('Strategy Games', 'Wargames')
ORDER BY bg.release_year DESC;


--------------------------------------------------------------------------------------
SELECT
	c.id,
	CONCAT(c.first_name, ' ', c.last_name) AS creator_name,
	c.email
FROM creators AS c
LEFT JOIN creators_board_games AS cbg ON cbg.creator_id = c.id
WHERE cbg.creator_id IS NULL;
-------------------------------------------------------------------------------


SELECT bg.name, bg.rating, c.name FROM board_games AS bg
JOIN players_ranges AS pl ON pl.id = bg.players_range_id
JOIN categories AS c ON c.id = bg.category_id
WHERE bg.rating > 7
		AND
	(LOWER(bg.name) LIKE '%a%' OR bg.rating > 7.5)
		AND
	(pl.min_players >= 2 AND pl.max_players <= 5)
ORDER BY bg.name ASC, bg.rating DESC
LIMIT 5;

-------------------------------------------------------------------------------

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    MAX(bg.rating) AS rating
FROM creators AS c
JOIN creators_board_games AS cbg ON c.id = cbg.creator_id
JOIN board_games AS bg ON bg.id = cbg.board_game_id
WHERE LOWER(c.email) LIKE '%.com'
GROUP BY c.first_name, c.last_name, c.email;

-------------------------------------------------------------------------------

SELECT
    c.last_name,
    CEIL(AVG(bg.rating)) AS average_rating,
	p.name AS publisher_name
FROM creators AS c
JOIN creators_board_games AS cbg ON c.id = cbg.creator_id
JOIN board_games AS bg ON bg.id = cbg.board_game_id
JOIN publishers AS p ON p.id = bg.publisher_id
WHERE p.name = 'Stonemaier Games'
GROUP BY c.last_name, p.name
ORDER BY average_rating DESC;

------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_creator_with_board_games(f_name VARCHAR(30)) RETURNS INT AS
$$
BEGIN
	RETURN (
	SELECT
		COUNT(*)
	FROM creators AS c
	JOIN creators_board_games AS cbg ON cbg.creator_id = c.id
	WHERE c.first_name = f_name);
END;
$$
LANGUAGE plpgsql;

SELECT fn_creator_with_board_games('Bruno')
SELECT fn_creator_with_board_games('Alexander')



----------------------------------------------------------------------------------------
CREATE TABLE search_results (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    release_year INT,
    rating FLOAT,
    category_name VARCHAR(50),
    publisher_name VARCHAR(50),
    min_players VARCHAR(50),
    max_players VARCHAR(50)
);


CREATE OR REPLACE PROCEDURE usp_search_by_category(category VARCHAR(50)) AS
$$
BEGIN
	INSERT INTO search_results(name, release_year, rating, category_name, publisher_name, min_players, max_players)
		SELECT
			b.name,
			b.release_year,
			b.rating,
			c.name,
			p.name,
			CONCAT(pl.min_players::VARCHAR, ' people') AS min_players,
			CONCAT(pl.max_players::VARCHAR, ' people') AS man_players
		FROM board_games AS b
		JOIN publishers AS p ON p.id = b.publisher_id
		JOIN categories AS c ON c.id = b.category_id
		JOIN players_ranges AS pl ON pl.id = b.players_range_id
		WHERE c.name = category
		ORDER BY
			p.name ASC, b.release_year DESC;
END;
$$
LANGUAGE plpgsql


CALL usp_search_by_category('Wargames');

SELECT * FROM search_results;