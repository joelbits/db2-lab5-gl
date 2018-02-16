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
        INSERT INTO transfers (amount, note, from_account_id, to_account_id, datetime)            VALUES (inamount, innote, infrom_account, into_account, TIMESTAMP(NOW()));
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