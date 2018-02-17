-- Author: Joel ÅKerblom
use lab5;

/* Lab 5 - 1
Skriv queries för att skapa en databas och tabeller för att hantera 
personer som har konton med pengar. Konton ska kunna ha en eller 
flera innehavare, värdet av pengar på kontot får aldrig hamna på 
mindre än noll. Använd lämpliga datatyper, nycklar, index och 
foreign keys där det passar. Tabellerna och kolumner ska vara:
a) Users (id, name)
b) Accounts (id, amount)
c) Transfers (id, from_account_id, to_account_id, amount, note, datetime)
d) Owners (user_id, account_id)
*/
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS transfers;
DROP TABLE IF EXISTS owners;

create table users (
	id 			SMALLINT NOT NULL primary key auto_increment,
	name 	    varchar(50) NOT NULL,
    INDEX(name)
);

create table accounts (
    id          SMALLINT NOT NULL primary key auto_increment,
    amount      int NOT NULL
);

create table transfers (
    id          MEDIUMINT NOT NULL primary key auto_increment,
    from_account_id     SMALLINT NOT NULL,
    to_account_id       SMALLINT NOT NULL,
    amount              int NOT NULL,
    note                text,
    datetime            datetime NOT NULL,
    foreign key (from_account_id) references accounts(id),
    foreign key (to_account_id) references accounts(id)
);

create table owners (
    user_id         SMALLINT NOT NULL,
    account_id      SMALLINT NOT NULL,
    INDEX(user_id),
    INDEX(account_id),
    foreign key (user_id) references users(id),
    foreign key (account_id) references accounts(id)
);

-- Lab 5 - 1 - Usage:
/* 
SHOW create table users;
SHOW create table accounts;
SHOW create table transfers;
SHOW create table owners;
*/


/* Lab 5 - 2
Skriv queries för att fylla på med minst 5 användare med minst
två konton vardera. Välj slumpade värden för belopp som finns
för konton. Gör så att minst 5 konton har mer än en ägare. */
INSERT INTO users (name) VALUES("Adam Andersson");
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (1, last_insert_id());
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (1, last_insert_id());

INSERT INTO users (name) VALUES("Bernt Berntsson");
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (2, last_insert_id());
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (2, last_insert_id());

INSERT INTO users (name) VALUES("Cesar Cykel");
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (3, last_insert_id());
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (3, last_insert_id());

INSERT INTO users (name) VALUES("David Dansk");
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (4, last_insert_id());
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (4, last_insert_id());

INSERT INTO users (name) VALUES("Erik Eriksson");
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (5, last_insert_id());
INSERT INTO accounts (amount) VALUES (FLOOR(RAND() * (1000000 - 1000 + 1)) + 1000);
INSERT INTO owners (user_id, account_id) VALUES (5, last_insert_id());

-- Lab 5 - 2 - Usage:
/*
SELECT * FROM users;
SELECT * FROM accounts;
SELECT * FROM owners;
*/


/* Lab 5 - 3 - Usage:
Skriv queries för att skapa en procedure, 
transfer(amount, note, from_account, to_account), 
som för över pengar från ett konto till ett annat. 
Varje överföring ska ha en kort anteckning på max 50 tecken och 
dagens datum samt klockslag. Använd TRANSACTION och COMMIT så att det 
inte kan bli fel vid överföringen. Som sista steg i din procedure ska 
det göras en SELECT som visar överföringen. */
-- use lab5;
DROP PROCEDURE IF EXISTS transfer;
DELIMITER //
CREATE PROCEDURE transfer(IN inamount INT, IN innote TEXT, IN infrom_account SMALLINT, IN into_account SMALLINT)
BEGIN
    declare fr_amount int;
    SELECT amount FROM accounts WHERE id = infrom_account AND amount > inamount INTO fr_amount; 
    if (fr_amount > 0) THEN
        -- Update accounts set amount for TO account
        UPDATE accounts SET amount = amount + inamount WHERE id = into_account;
        -- Add new transfer to transfers table.
        INSERT INTO transfers (amount, note, from_account_id, to_account_id, datetime) 
                       VALUES (inamount, innote, infrom_account, into_account, TIMESTAMP(NOW()));
        -- Update accounts set amount for FROM account
        UPDATE accounts a SET a.amount = (a.amount - inamount) WHERE id = infrom_account;
    end if;
END //
DELIMITER ;

/* Lab 5 - 3 - Usage:
SELECT * FROM `accounts` WHERE id = 1;
SELECT * FROM `accounts` WHERE id = 3;
returns:
id      amount
1       136649
3       9687

call transfer(1337, "Transfer text...", 1, 3);

SELECT * FROM `accounts` WHERE id = 1;
SELECT * FROM `accounts` WHERE id = 3;
Should return:
id      amount
1       135312
3       11024  
*/



/* Lab 5 - 4 
Skriv queries för att skapa en procedure, show_transfers(account_id), 
som listar alla transfers för ett angivet konto sorterade på datum och tid. */
-- use lab5;
DROP PROCEDURE IF EXISTS show_transfers;
DELIMITER //
CREATE PROCEDURE show_transfers(IN account_id SMALLINT)
BEGIN
    SELECT * FROM transfers
    WHERE from_account_id = account_id OR to_account_id = account_id
    ORDER BY datetime ASC;
END //
DELIMITER ;

/* Lab 5 - 4 - Usage: 
call show_transfers(1);
returns:
id 	from_account_id 	to_account_id 	amount 	note 	            datetime 	
1	1	                3	            1337	Transfer text...	2018-02-16 08:27:51
2	1	                3	            13337	Transfer text 2!	2018-02-16 08:43:02
*/


/* Lab 5 - 5
Skriv queries för att skapa en procedure, 
change_ownership(from_user_id, to_user_id, account_id), 
som byter ägare på ett konto. 
Använd TRANSACTION och COMMIT så att det inte kan bli fel vid överföringen.
(OBS! Koden måste kontrollera så att from_user verkligen är ägare till kontot.) 
Avsluta med ett SELECT @status och låt @status vara meddelande 
om "Success!" eller "Denied!" som sätts i din procedure. */

/* Usage:

call change_ownership(1, 2, 1); 
@status
Success!

SELECT * FROM owners WHERE account_id = 1;
user_id     account_id
2           1

call change_ownership(1, 2, 1);
@status
Denied!

-- select @status;  works after the call

*/

-- use lab5;
DROP PROCEDURE IF EXISTS change_ownership;
DELIMITER //
CREATE PROCEDURE change_ownership(IN from_user_id SMALLINT, IN to_user_id SMALLINT, IN account_id SMALLINT)
BEGIN
    set @status := "Denied!"; -- Result of this procedure

    START TRANSACTION; -- Start of transaction

    -- Check if account really belongs to from_user_id
    IF ( SELECT user_id from owners o 
        WHERE o.user_id = from_user_id 
        AND o.account_id = account_id ) 
    THEN BEGIN
        declare own_bef_change SMALLINT;
        declare own_aft_change SMALLINT;

        -- Gets user_id of account_id before any changes
        SELECT user_id FROM owners oo WHERE oo.account_id = account_id INTO @own_bef_change;

        -- Update owners info, set account_id owner user_id to to_user_id
        UPDATE owners ooo SET ooo.user_id = to_user_id WHERE ooo.account_id = account_id;

        -- Get user_id from account_id after updated owner of account
        SELECT user_id FROM owners oooo WHERE oooo.account_id = account_id INTO @own_aft_change;

        -- If owner of acc before change IS NOT same as after change
        IF (@own_bef_change <> @own_aft_change) THEN BEGIN
            SET @status := "Success!";
        END;
        END IF;
    END;
    END IF; -- End check if account really belongs to from_user_id

    COMMIT; -- End of transaction. Now we commit the transactions to the db.

    SELECT @status; -- "Returns" @status as result. @status Can be used later
END //
DELIMITER ;


/* Lab 5 - 6
Skriv queries för att: (1) starta en transaktion, (2) göra en UPDATE, 
(3) sätta en SAVEPOINT, (4) göra en UPDATE, 
(5) göra en ROLLBACK till savepoint, (6) en göra COMMIT. */

-- (1) starta en transaktion
START TRANSACTION; -- Auto-commit mode off

-- (2) göra en UPDATE
UPDATE `owners` SET `user_id` = 5 WHERE `account_id` = 1;

-- (3) sätta en SAVEPOINT
SAVEPOINT p_initial;

-- (4) göra en UPDATE
UPDATE `owners` SET `user_id` = 3 WHERE `account_id` = 1;

-- (5) göra en ROLLBACK till savepoint
ROLLBACK TO p_initial;

-- (6) göra en COMMIT.
COMMIT;

/* Lab 5 - 6 - Usage:

Above will finally result in the below. Step (4) is rolled-back, 
hence did not affect the table final outcome.

SELECT * FROM owners WHERE account_id = 1;

user_id     account_id
5           1

*/


/* Lab 5 - 7
Skriv queries för att skapa login för tre USERS till MySQL 
(inte users för tabellerna med accounts):
a) De tre ska heta: kim, alex, app
b) Ge alla access (GRANT) så de kan göra SELECT och UPDATE på alla tabeller
    i DB för denna laboration
c) Ta bort (REVOKE) så att alex och app inte får göra UPDATE på 
    users, accounts och owners.
d) Begränsa så att alex inte får göra mer än 200 queries per timme      */
