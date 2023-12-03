---------------------------1----------------------------------
CREATE OR REPLACE FUNCTION fn_full_name (
	first_name VARCHAR(50), last_name VARCHAR(50)
) RETURNS VARCHAR(101) AS
$$
DECLARE full_name VARCHAR(101);
BEGIN
	full_name := INITCAP(first_name) || ' ' || INITCAP(last_name);
	RETURN full_name;
END;
$$
LANGUAGE plpgsql



-------------------------------------2---------------------------
CREATE OR REPLACE FUNCTION fn_calculate_future_value (
	initial_sum NUMERIC,
	yearly_interest_rate DECIMAL,
	number_of_years INT
)
RETURNS DECIMAL(1000, 4) AS
$$
DECLARE future_value DECIMAL(1000, 4);
BEGIN
	future_value := initial_sum * POWER(1 + yearly_interest_rate, number_of_years);
	RETURN future_value;
END;
$$
LANGUAGE PLPGSQL



--------------------------------3----------------------------------
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
	set_of_letters VARCHAR(50), word VARCHAR(50)
) RETURNS BOOLEAN AS
$$
DECLARE f1f2f3 BOOLEAN;
BEGIN
	f1f2f3 := TRIM(LOWER(word), LOWER(set_of_letters)) = '';
	RETURN f1f2f3;
END;
$$
LANGUAGE plpgsql



---------------------------------4-------------------------------
CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE (
	name VARCHAR(50),
	game_type_id INT,
	is_finished BOOLEAN
) AS
$$
BEGIN
	RETURN QUERY
		SELECT
			g.name,
			g.game_type_id,
			g.is_finished
		FROM games AS g
		WHERE g.is_finished = is_game_over;
END;
$$
LANGUAGE plpgsql;


-------------------------------5------------------------------
CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT) RETURNS VARCHAR(50) AS
$$
DECLARE final1 VARCHAR(50);
BEGIN
	IF level <= 40 THEN
		final1 := 'Normal Difficulty';
	ELSIF level BETWEEN 41 AND 60 THEN
		final1 := 'Nightmare Difficulty';
	ELSE
		final1 := 'Hell Difficulty';
	END IF;
	RETURN final1;
END;
$$
LANGUAGE plpgsql;

SELECT
	user_id,
	level,
	cash,
	fn_difficulty_level(level) AS difficulty_level
FROM users_games
ORDER BY user_id




--------------------------------7---------------------------
CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(searched_balance NUMERIC) AS
$$
DECLARE holder RECORD;
BEGIN
	FOR holder IN
		SELECT
			CONCAT(a1.first_name, ' ', a1.last_name) AS full_name,
			SUM(a2.balance) AS total_balance
		FROM account_holders AS a1 JOIN accounts AS a2 ON a2.account_holder_id = a1.id
		GROUP BY full_name
		HAVING SUM(a2.balance) > searched_balance
		ORDER BY full_name ASC
	LOOP
		RAISE NOTICE '% - %', holder.full_name, holder.total_balance;
	END LOOP;
END;
$$
LANGUAGE plpgsql

CALL sp_retrieving_holders_with_balance_higher_than(200000)


-------------------------------8---------------------------------
CREATE OR REPLACE PROCEDURE sp_deposit_money(account_id INT, money_amount NUMERIC(10, 4))
AS
$$
BEGIN
	UPDATE accounts
	SET balance = balance + money_amount
	WHERE account_id = id;
END;
$$
LANGUAGE plpgsql



-------------------------------9----------------------------------
CREATE OR REPLACE PROCEDURE sp_withdraw_money(account_id INT, money_amount NUMERIC(10, 4)) AS
$$
DECLARE current_balance DECIMAL;
BEGIN
	current_balance := (SELECT balance FROM accounts WHERE id = account_id);
	IF current_balance - money_amount >= 0 THEN
		UPDATE accounts
		SET balance = balance - money_amount
		WHERE id = account_id;
	ELSE
		RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
	END IF;
END;
$$
LANGUAGE plpgsql



----------------------------------------10---------------------------------------
CREATE OR REPLACE PROCEDURE sp_transfer_money(sender_id INT, receiver_id INT, amount NUMERIC(10,4)) AS
$$
DECLARE current NUMERIC(10,4);
BEGIN
	current := (SELECT balance FROM accounts WHERE id = sender_id);
	CALL sp_withdraw_money(sender_id, amount);
	IF current != (SELECT balance FROM accounts WHERE id = sender_id) THEN
		CALL sp_deposit_money(receiver_id, amount);
	END IF;
END;
$$
LANGUAGE plpgsql


triggers
------------------------------------------------11---------------------------------

CREATE TABLE logs(
	id SERIAL PRIMARY KEY,
	account_id INT,
	old_sum NUMERIC,
	new_sum NUMERIC
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs() RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
	VALUES (old.id, old.balance, new.balance);
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_account_balance_change
	AFTER UPDATE OF balance ON accounts
	FOR EACH ROW
		WHEN (old.balance != new.balance)
	EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs();

UPDATE accounts
SET balance = 1500.00
WHERE "id" = 1;

SELECT * FROM logs

-------------------------------------12-----------------------------------------

CREATE TABLE notification_emails(
	id SERIAL PRIMARY KEY,
	recipient_id INT,
	subject VARCHAR(255),
	body VARCHAR(255)
);


CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change() RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO notification_emails(recipient_id, subject, body)
	VALUES (
		OLD.account_id,
		'Balance change for account: %', OLD.account_id,
		CONCAT_WS(' ', 'ON', DATE(NOW()), 'your balance was changed from', NEW.old_sum, 'to', NEW.new_sum)
	);
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_send_email_on_balance_change
	AFTER UPDATE ON logs
	FOR EACH ROW
		WHEN (NEW.old_sum != NEW.new_sum)
	EXECUTE FUNCTION trigger_fn_send_email_on_balance_change();

SELECT * FROM notification_emails

