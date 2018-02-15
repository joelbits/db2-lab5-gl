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

-- TODO: Optimize
create table users (
	id 			int NOT NULL primary key auto_increment,
	name 	    varchar(50) NOT NULL,
    INDEX(name)
);

create table accounts (
    id          int NOT NULL primary key auto_increment,
    amount      int NOT NULL
);

create table transfers (
    id          int NOT NULL primary key auto_increment,
    from_account_id     int NOT NULL,
    to_account_id       int NOT NULL,
    amount              int NOT NULL,
    note                text,
    datetime            datetime NOT NULL,
    foreign key (from_account_id) references accounts(id),
    foreign key (to_account_id) references accounts(id)
);

create table owners (
    user_id         int NOT NULL,
    account_id      int NOT NULL,
    INDEX(user_id),
    INDEX(account_id),
    foreign key (user_id) references users(id),
    foreign key (account_id) references accounts(id)
);

-- Lab 5 - 1 - Usage:
/* 
SHOW create table users PROCEDURE ANALYSE;
SHOW create table accounts PROCEDURE ANALYSE;
SHOW create table transfers PROCEDURE ANALYSE;
SHOW create table owners PROCEDURE ANALYSE;
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

